import Foundation

struct TransactionEntity: Codable {
    var id: Int
    var date: Date
    var amount: Decimal
    var personId: Int
    var description: String
}

struct TransactionResultWrapper: Codable {
    var transactions: [TransactionEntity]
}
