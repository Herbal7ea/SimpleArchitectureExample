import Foundation
import RxSwift
import RxRelay

class MainPresenter {
    
    let personsBynameRelay = BehaviorRelay<Dictionary<String, [Person]>>(value: [:])
    
    var numberOfSections: Int { return names.count }
    var bag = DisposeBag()

    private let interactor: ModelInteractor
    private let personsGrouper: PersonsGrouper
    private var names = [String]()
    
    init(interactor: ModelInteractor, personsGrouper: PersonsGrouper) {
        self.interactor = interactor
        self.personsGrouper = personsGrouper
        
        loadPersons()
    }
    
    func loadPersons() {
        interactor.personsRelay.subscribe(onNext: { [weak self] persons in
            print("🏎 personsRelay: \(persons.first?.nickname)")
            self?.handleUpdates(for: persons)
        }).disposed(by: bag)
            
        interactor.modelErrorRelay.subscribe(onNext: { [weak self] error in
            self?.notifyOfError(error)
        }).disposed(by: bag)
    }
    
    
    
    //public for testing
    //TODO: jbott - 06.17.19 - adds a warning - must be some more elegant way to fix this
    @available(*, deprecated, message: "This method should not be used outside of this class, it is public for testing purposes only" )
    func handleUpdates(for persons: [Person]) {
        let personsByname = personsGrouper.groupPersonsByname(persons)
        names = personsGrouper.namesStortedFor(groupPersons: personsByname)
        personsBynameRelay.accept(personsByname)
    }
    
    func notifyOfError(_ error: Error){
        print("❗️🧙🏻‍♂️❗️ You shall not pass!: \(error)")
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return personsIn(section: section)?.count ?? 0
    }
    
    func personsIn(section: Int) -> [Person]? {
        let sectionName = names[section]
        return personsBynameRelay.value[sectionName]
    }
    
    func nameNameFor(section: Int) -> String {
        return names[section]
    }
    
    func personFor(indexPath: IndexPath) -> Person? {
        let name = names[indexPath.section]
        let person = personsBynameRelay.value[name]?[indexPath.row]
        return person
    }
}
