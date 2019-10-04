import Foundation

protocol NetworkInteractor {
    func loadPostings(finished: @escaping PostingsResultClosure)
    func loadPersons(finished: @escaping PersonsResultClosure)
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure)
}

class NetworkInteraction: NetworkInteractor {
    
    func loadPostings(finished: @escaping PostingsResultClosure) {
        fatalError("Not Implemented")
    }
    
    func loadPersons(finished: @escaping PersonsResultClosure) {
        fatalError("Not Implemented")
    }
    
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure) {
        fatalError("Not Implemented")
    }
}
