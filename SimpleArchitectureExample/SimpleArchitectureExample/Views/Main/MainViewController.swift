import UIKit
import RxSwift
import RxRelay

private var tableHeaderSize = 103

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    private var presenter: MainPresenter!
    private var navigationCoordinator: NavigationCoordinator!
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DependencyRegistry.shared.prepare(self)
        
        setupTable()
        setupBinding()
    }
        
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PersonOverviewCell.nib, forCellReuseIdentifier: PersonOverviewCell.identifier)

        let width = Int(self.view.bounds.size.width)
        
        let headerView = MainSummaryHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: tableHeaderSize))
            headerView.prepare(balance: "USD $20")
        
        tableView.tableHeaderView = headerView
    }

    //TODO: jbott - 06.26.19 - create indicator to show data is out of sync until after network data loaded
    func setupBinding() {
        presenter.personsBynameRelay
                 .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] accunts in
                self?.tableView.reloadData()
            }).disposed(by: bag)
    }
    
    func inject(presenter: MainPresenter, navigationCoordinator: NavigationCoordinator) {
        self.presenter = presenter
        self.navigationCoordinator = navigationCoordinator
    }
}

// MARK: - UITableViewDataSource
extension MainViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.nameNameFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = presenter.personFor(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonOverviewCell.identifier, for: indexPath) as! PersonOverviewCell
            cell.prepare(with: person)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = presenter.personFor(indexPath: indexPath)!
        navigationCoordinator.rowTappedForPerson(person)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = UIColor(hex: "#432213FF")
            header.textLabel?.textColor = .white
    }
}
