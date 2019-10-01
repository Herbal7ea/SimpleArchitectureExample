//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var personId: Int64
    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: String
    @NSManaged public var id: Int64
    @NSManaged public var transactionDescription: String

}
