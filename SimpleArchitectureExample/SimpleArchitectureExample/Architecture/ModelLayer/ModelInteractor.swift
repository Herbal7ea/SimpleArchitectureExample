import Foundation
import RxSwift
import RxRelay

typealias PersonsResultClosure = (Result<[PersonEntity], NetworkError>)-> Void
typealias TransactionsResultClosure = (Result<[TransactionEntity], NetworkError>)-> Void

protocol ModelInteractor {
    var personsRelay: BehaviorRelay<[Person]> { get }
    var modelErrorRelay: PublishRelay<NetworkError> { get }

    func loadPersons(finished: @escaping PersonsResultClosure)
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure)
}




class ModelInteraction: ModelInteractor {
    private var networkLayer: NetworkInteractor
    private var dataLayer: DataInteractor
    var personsRelay: BehaviorRelay<[Person]>
    var modelErrorRelay = PublishRelay<NetworkError>() // given time, I would make a Model Error class that maps to the network and data layer Errors classes
    
    init(networkInteractor: NetworkInteractor, dataInteractor: DataInteractor) {
        self.networkLayer = networkInteractor
        self.dataLayer = dataInteractor
        personsRelay = dataLayer.personsRelay
        
        getPersons()
    }
    
    func loadPersons(finished: @escaping PersonsResultClosure) {
        networkLayer.loadPersons(finished: finished)
    }
    
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure) {
        networkLayer.loadTransactions(id: id, finished: finished)
    }
    
    private func persist(entities: [PersonEntity], finished:@escaping PersonsClosure) {
        dataLayer.persist(entities: entities, finished: finished)
    }
    
    //All of the complexity (local db call, network call, conversion to Core Data,
    //loading of local results again, are all removed from presentation layer because we
    //are using the RxRelay to simplify the public UI - subscription is expected
    //to be called multiple times.
    func getPersons() {
        //load local data
        //model interactor lasts the life of the app, so just `self` is safe to use here
        //All threading is transparent to this layer but - Main Thread here
        dataLayer.loadAllPersonsAsync { localPersons in
            print("🐴 loaded local data: \(localPersons[0].nickname)")
            self.personsRelay.accept(localPersons)
            
            //load Network Data
            self.loadNetworkPersons()
        }
    }


    func loadNetworkPersons() {
        //BG Thread hear
        networkLayer.loadPersons { result in
            switch result {
            case .success(let personEntities):
                
                print("🦄 loaded network data: \(personEntities[0].nickname)")
                
                //convert and save to local db
                //BG thread here
                self.dataLayer.persist(entities: personEntities) { newLocalPersons in
                    print("🍄 loaded network data: \(newLocalPersons.first?.nickname)")
                    //update again with latest from network
                    //normally I would use a time stamp to diff what I have loaded vs. what is new from the server.
                    //Back to main Thread in this closure
                    self.personsRelay.accept(newLocalPersons)                    }
            case .failure(let error):
                //notify user of error
                //TODO: add UI to present message to user
                self.modelErrorRelay.accept(.requestError(message: error.localizedDescription))
            }
        }
    }
    
//    func loadPersonAsync(_ pageNumber: Int, finished: @escaping ([Person]) -> Void) {
//        dataLayer.loadPersonAsync(pageNumber, finished: finished)
//    }
//
//    func loadAllPersonsAsync(finished: ([Person]) -> Void) {
//        dataLayer.loadAllPersonsAsync(finished: finished)
//    }

}
