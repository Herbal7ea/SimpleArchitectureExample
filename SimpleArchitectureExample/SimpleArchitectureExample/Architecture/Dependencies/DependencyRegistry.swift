import UIKit

class DependencyRegistry {
    static var shared = DependencyRegistry()

    private var navigationCoordinator = NavigationCoordinator()
    private var networkInteractor: NetworkInteractor = MockNetworkInteraction() //using mock until endpoints are finished // NetworkInteraction()
    private var dataInteractor: DataInteractor = DataInteraction()
    
    private var modelInteractor: ModelInteractor { //singleton
        return ModelInteraction(networkInteractor: networkInteractor, dataInteractor: dataInteractor)
    }
    
    private var mainPresenter: MainPresenter {
        return MainPresenter(interactor: modelInteractor, personsGrouper: personsGrouper)
    }
    
    private var personsGrouper: PersonsGrouper = PersonsGroupingHelper()
    
    func createDetailViewController(with person: Person) -> DetailViewController {
        return DetailViewController.newInstance(with: person)
    }
    
    //this is the initial view controller, so we need to do some extra setup
    func prepare(_ mvc: MainViewController) {
        navigationCoordinator.registerInitialNavigationController(mvc)
        
        let presenter = mainPresenter
        mvc.inject(presenter: presenter, navigationCoordinator: navigationCoordinator)
    }
    
    func prepare(_ vc: DetailViewController, with person: Person) {
        let presenter = DetailPresenter(person: person, modelInteractor: modelInteractor)
        vc.inject(presenter: presenter, navigationCoordinator: navigationCoordinator)
    }
}
