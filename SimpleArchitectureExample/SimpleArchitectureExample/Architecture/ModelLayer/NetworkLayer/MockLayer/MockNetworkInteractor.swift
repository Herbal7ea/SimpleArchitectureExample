import Foundation
import Swifter

typealias NetworkResultClosure<T> = (Result<T, NetworkError>)-> Void

class MockNetworkInteraction: NetworkInteractor {
    static var shared = MockNetworkInteraction()
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init() {
        setupServer()
    }

}

// MARK: - Swifter Specific
private let defaultLocalhost = URL(string: "http://127.0.0.1:8080")!

private let server = HttpServer()

private extension JsonFile {
    var url: URL { return defaultLocalhost.appendingPathComponent(self.pathString) }
}

extension MockNetworkInteraction {
    private func setupServer() {
        server["/people"] = { _ in .ok(.json(self.personsJson)) }
        server["/transactions/1"] = { _ in .ok(.json(self.transactions1)) }
        server["/transactions/2"] = { _ in .ok(.json(self.transactions2)) }
        server["/transactions/3"] = { _ in .ok(.json(self.transactions3)) }
        
        server.listenAddressIPv4 = "127.0.0.1"
        try! server.start(forceIPv4: true)
    }
}

// Mark - NetworkInteractor Methods
extension MockNetworkInteraction {
    func loadPersons(finished: @escaping PersonsResultClosure) {
        DispatchQueue.global().async {
            
            sleep(2) //faking network delay
            
            self.loadJson(PeopleResultWrapper.self, url: JsonFile.people.url) { result in
                //I can force ignore the catch because this is a mock network layer
                let persons = try! result.get().people
                
                //URLSession by default is on a background thread
                //Since this layer was the one do depart, it's responsible to join main thread again
                //do all conversion work on background thread, return results on main thread
                //sometimes additional work is done in the Model layer (translation, conversion, CoreData stuff, etc.),
                //then it's permisible to stay on background thread, and join 1 layer up
                DispatchQueue.main.async {
                    finished(.success(persons))
                }
            }
        }
    }
    
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure) {
        return loadTransactions(fileType: id.transactionId, finished: finished)
    }
    
    private func loadTransactions(fileType: JsonFile, finished: @escaping TransactionsResultClosure) {
        loadJson(TransactionResultWrapper.self, fileType: fileType) { result in
            let transactions = try! result.get().transactions
            
            DispatchQueue.main.async {
                finished(.success(transactions))
            }
        }
    }
}

// MARK: - JSON File Specific
extension MockNetworkInteraction {
    private var personsJson: [String: Any] {
        return loadJsonFromFile(fileName: JsonFile.people.rawValue)
    }
    
    private var transactions1: [String: Any] {
        return loadJsonFromFile(fileName: JsonFile.transaction1.rawValue)
    }
    
    private var transactions2: [String: Any] {
        return loadJsonFromFile(fileName: JsonFile.transaction2.rawValue)
    }
    
    private var transactions3: [String: Any] {
        return loadJsonFromFile(fileName: JsonFile.transaction3.rawValue)
    }
    
    
    private func loadJsonFromFile(type: JsonFile) -> [String: Any] {
        return loadJsonFromFile(fileName: type.rawValue)
    }
    
    private func loadJsonFromFile(fileName: String) -> [String: Any] {
        //safe to use explicitly unwrapped optional here, as it will crash immediately on the developers side if there are errors.
        //per Swift Talks: https://www.objc.io/blog/2018/03/27/unwrapping-optionals/
        let filepath = Bundle.main.path(forResource: fileName, ofType: "json")!
        let data = try! String(contentsOfFile: filepath).data(using: .utf8)!
        
        let result = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return result
    }
    
}

// MARK: - Generic JSON Loading/Parsing
extension MockNetworkInteraction {
    
    private func loadJson<T: Codable>(_ type: T.Type, fileType: JsonFile, onResult: @escaping NetworkResultClosure<T>) {
        return loadJson(type, url: fileType.url, onResult: onResult)
    }
    
    private func loadJson<T: Codable>(_ type: T.Type, url: URL, onResult: @escaping NetworkResultClosure<T>) {
        //don't need weak self, because Network Layer has one instance, which should last the life of the Application
        //And we don't own UrlSession.shared, so no circular reference or memory leak
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { onResult(.failure(.requestError(message: error!.localizedDescription))) ; return }
            guard let data = data else { onResult(.failure(.unableToLoadingData)) ; return }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                onResult(.success(result))
            } catch {
                onResult(.failure(.unableToParseJson(message: error.localizedDescription)))
            }
        }.resume()
    }
    
}

private extension Int {
    var transactionId: JsonFile {
        guard 1...3 ~= self else { fatalError("Only have ids 1, 2, 3")}
        
        switch self {
        case 1:
            return .transaction1
        case 2:
            return .transaction2
        case 3:
            return .transaction3
        default:
            fatalError("Only have ids 1, 2, 3")
        }
    }
}
