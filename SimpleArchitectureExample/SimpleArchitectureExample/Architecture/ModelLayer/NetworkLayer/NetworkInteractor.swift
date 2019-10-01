import Foundation

protocol NetworkInteractor {
    func loadPersons(finished: @escaping PersonsResultClosure)
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure)
}

class NetworkInteraction: NetworkInteractor {
    func loadPersons(finished: @escaping PersonsResultClosure) {
        fatalError("Not Implemented")
    }
    
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure) {
        fatalError("Not Implemented")
    }
}
