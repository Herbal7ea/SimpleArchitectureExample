import UIKit
import RxSwift

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    private var presenter: DetailPresenter!
    private var navigationCoordinator:NavigationCoordinator!
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRx()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            navigationCoordinator.detailVCDismissed()
        }
    }
    
    func inject(presenter: DetailPresenter, navigationCoordinator: NavigationCoordinator) {
        self.presenter = presenter
        self.navigationCoordinator = navigationCoordinator
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupRx() {
        presenter.transactionsRelay
                 .observeOn(MainScheduler.instance)
                 .subscribe(onNext: { [weak self] transactions in
                    self?.tableView.reloadData()
                 }).disposed(by: bag)
    }
}

// MARK: - Factory Methods
extension DetailViewController {
    static func newInstance(with person: Person) -> DetailViewController {
        let vc = DetailViewController(nibName: "\(self)", bundle: nil)
        DependencyRegistry.shared.prepare(vc, with: person)
        
        return vc
    }
}


// MARK: - UITableViewDataSource
extension DetailViewController  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //will be more when when group by month
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.transactionsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let transaction = presenter.transaction(for: indexPath)
        let amount = transaction.amountFormatted(for: presenter.person)
        let cell = UITableViewCell()
            cell.textLabel?.text = "\(transaction.date.short) -  \(transaction.description): \(amount)"
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension DetailViewController {
    
}




