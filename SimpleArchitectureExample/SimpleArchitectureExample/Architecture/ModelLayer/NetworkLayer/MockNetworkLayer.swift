import Foundation
import Swifter

typealias AccountsResultClosure = (Result<[Account], NetworkError>)-> Void
typealias TransactionsResultClosure = (Result<[Transaction], NetworkError>)-> Void
typealias NetworkResultClosure<T> = (Result<T, NetworkError>)-> Void

private let defaultLocalhost = URL(string: "http://localhost:8080")!


enum JsonFile: String {
    
    var url: URL { return defaultLocalhost.appendingPathComponent(self.pathString) }
    var pathString: String { return self.rawValue.replacingOccurrences(of: "_", with: "/") }
    
    case accounts,
    transaction1 = "transactions_1",
    transaction2 = "transactions_2",
    transaction3 = "transactions_3"
}

class MockNetworkLayer {
    static var shared = MockNetworkLayer()
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func loadAccounts(finished: @escaping AccountsResultClosure) {
        loadJson(AccountsResultWrapper.self, url: JsonFile.accounts.url) { result in
            //I can force ignore the catch because this is a mock network layer
            let accounts = try! result.get().accounts
            finished(.success(accounts))
        }
    }
    
    func loadTransactions(fileType: JsonFile, finished: @escaping TransactionsResultClosure) {
        loadJson(TransactionResultWrapper.self, fileType: fileType) { result in
            let transactions = try! result.get().transactions
            finished(.success(transactions))
        }
    }
    
    
    
    init() {
        setupServer()
    }
}

// MARK: - JSON File Specific
extension MockNetworkLayer {
    private var accountsJson: [String: Any] {
        return loadJsonFromFile(fileName: JsonFile.accounts.rawValue)
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
extension MockNetworkLayer {
    
    private func loadJson<T: Codable>(_ type: T.Type, fileType: JsonFile, finished: @escaping NetworkResultClosure<T>) {
        return loadJson(type, url: fileType.url, finished: finished)
    }
    
    private func loadJson<T: Codable>(_ type: T.Type, url: URL, finished: @escaping NetworkResultClosure<T>) {
        //don't need weak self, because Network Layer has one instance, which should last the life of the Application
        //And we don't own UrlSession.shared, so no circular reference or memory leak
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { finished(.failure(.requestError(message: error!.localizedDescription))) ; return }
            guard let data = data else { finished(.failure(.unableToLoadingData)) ; return }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                finished(.success(result))
            } catch {
                finished(.failure(.unableToParseJson(message: error.localizedDescription)))
            }
        }.resume()
    }
    
}

// MARK: - Swifter Specific
let server = HttpServer()

extension MockNetworkLayer {
    private func setupServer() {
        server["/accounts"] = { _ in .ok(.json(self.accountsJson)) }
        server["/transactions/1"] = { _ in .ok(.json(self.transactions1)) }
        server["/transactions/2"] = { _ in .ok(.json(self.transactions2)) }
        server["/transactions/3"] = { _ in .ok(.json(self.transactions3)) }
        
        try! server.start()
    }
    
}
