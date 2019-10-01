import Foundation
import RxSwift
import RxRelay

class DetailPresenter {
    private var interactor: ModelInteractor
    var person: Person
    
    let transactionsRelay = BehaviorRelay(value: [TransactionEntity]())
    
    init(person: Person, modelInteractor: ModelInteractor) {
        self.person = person
        self.interactor = modelInteractor
        
        loadTransactions()
    }
    
    func loadTransactions() {
        interactor.loadTransactions(id: Int(person.id)) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let transactions):
                weakSelf.handleNewTransactions(transactions)
            case .failure(let error):
                print("❗️🧙🏻‍♂️❗️ You shall not pass!: \(error)")
            }
        }
    }
    
    func handleNewTransactions(_ transactions: [TransactionEntity]) {
        //TODO: jbott - 06.16.19 - filter, sort, and group
        transactionsRelay.accept(transactions)
    }
    
    func transaction(for indexPath: IndexPath) -> TransactionEntity {
        return transactionsRelay.value[indexPath.row]
    }

}
