//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var currency: String
    @NSManaged public var currentBalance: NSDecimalNumber
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var nickname: String

}
