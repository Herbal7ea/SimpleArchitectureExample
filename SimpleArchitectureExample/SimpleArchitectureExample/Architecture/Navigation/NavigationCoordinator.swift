import UIKit

class NavigationCoordinator {
    private var navigationController: UINavigationController!
    
    func registerInitialNavigationController(_ mvc: MainViewController){
        self.navigationController = mvc.navigationController
    }
    
    func rowTappedForPerson(_ person: Person) {
        let vc = DependencyRegistry.shared.createDetailViewController(with: person)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func detailVCDismissed() {
        //handle back event if need be
    }
}
