//

import UIKit

class PersonOverviewCell: UITableViewCell {

    @IBOutlet var personLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    private var person: Person?
    
    var balance: String {
        guard let person = person,
            let locale = person.locale
            else { return "" }
        let d = person.currentBalance as Decimal
        return "\(person.currency) \(d.toCurrencyString(for: locale))"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        person = nil
        personLabel.text = ""
        balanceLabel.text = ""
    }
    
    func prepare(with person: Person?) {
        self.person = person
        
        //TODO: jbott - 06/16/18 - determing if this value changes, inject values
        if let person = person {
            personLabel.text = person.nickname
            balanceLabel.text = balance
        }
    }
}

// MARK: - cell creation methods
extension PersonOverviewCell {
    static var identifier = "\(String(describing: self))"
    static var nib: UINib {
        return UINib(nibName: "\(String(describing: self))", bundle: nil)
    }
}
