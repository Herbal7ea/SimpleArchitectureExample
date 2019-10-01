import Foundation
import CoreData

struct PersonEntity: Codable {
    var id: Int
    var nickname: String
    var name: String
    var currency: String
    var currentBalance: Decimal
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        nickname,
        name = "class",
        currency,
        currentBalance
    }
}

struct PeopleResultWrapper: Codable {
    var people: [PersonEntity]
}

extension Person {
    convenience init(entity: PersonEntity, context: NSManagedObjectContext) {
        self.init(context: context)
            id = Int64(entity.id)
            nickname = entity.nickname
            name = entity.name
            currency = entity.currency
            currentBalance = entity.currentBalance as NSDecimalNumber
    }
}
