import Foundation
import RxSwift
import RxRelay

protocol DataInteractor {
    
    var personsRelay: BehaviorRelay<[Person]> { get }
    
    func updatePersons()
    
    func persist(entities: [PersonEntity], finished:@escaping PersonsClosure)

    func loadPersonAsync(_ pageNumber: Int, finished: @escaping ([Person]) -> Void)
    func loadAllPersonsAsync(finished: ([Person]) -> Void)
}

class DataInteraction: DataInteractor {

    var personsRelay = BehaviorRelay(value: [Person]())
    var currentDataLayer = CoreDataLayer()
    
    init() {
        currentDataLayer.setupCoreData()
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
//            self.updatePersons()
//        }
    }
    
    func updatePersons() {
        
        currentDataLayer.updatePersonThroughChildContext { [weak self] in
            guard let strongSelf = self else { return }
            
            print(strongSelf.personsRelay.value)
            let persons = strongSelf.currentDataLayer.loadPerson(0)
            print(persons[0].name)
        }
        
        currentDataLayer.fakeImportFromOtherServer { [weak self] in
            guard let strongSelf = self else { return }
            
            let persons = strongSelf.currentDataLayer.loadAllPersons()
            strongSelf.personsRelay.accept(persons)
            strongSelf.personsRelay.value.forEach { print("\($0.nickname)") }
        }
    }
    
    func persist(entities: [PersonEntity], finished: @escaping PersonsClosure) {
        currentDataLayer.persist(entities: entities, finished: finished)
    }
    
    func loadPersonAsync(_ pageNumber: Int, finished: @escaping PersonsClosure) {
        currentDataLayer.loadPersonAsync(pageNumber, finished: finished)
    }
    
    func loadAllPersonsAsync(finished: PersonsClosure) {
        currentDataLayer.loadAllPersonsAsync(finished: finished)
    }
}

