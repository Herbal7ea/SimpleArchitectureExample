//

import UIKit


class MainSummaryHeaderView: UIView, NibView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var moneyTypeLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!

    private var balance = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNib()
        
        
        //After attaching HeaderView to TableView, bg is gray
        //this doesn't work as well ⬇️
        //backgroundColor = UIColor.init(hex: "#FB7F48")
        //Setting tableview to orange - because of time constraints
        //initialize additional data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//
//        //TODO: jbott - 06/16/18 - determing if this value changes, inject values
//        moneyTypeLabel.text = "🌈 Digital Money" //hard coding for now, don't know the variations
//        balanceLabel.text = balance
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        //TODO: jbott - 06/16/18 - determing if this value changes, inject values
//        moneyTypeLabel.text = "🦄 Digital Money" //hard coding for now, don't know the variations
//        balanceLabel.text = balance
//    }
    
    @IBAction func accessoryTapped(_ sender: Any) {
        print("It'sa me mario 🍄")
    }
    
    func prepare(balance: String) {
        self.balance = balance

        //TODO: jbott - 06/16/18 - determing if this value changes, inject values
        moneyTypeLabel.text = "Milk Money" //hard coding for now, don't know the variations
        balanceLabel.text = balance
    }
}

public protocol NibView where Self: UIView {
    var contentView: UIView! { get set }
    
    func loadFromNib()
}

public extension NibView {
    func loadFromNib() {
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        
        let bundle = Bundle(for: type(of: self))
            bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}



