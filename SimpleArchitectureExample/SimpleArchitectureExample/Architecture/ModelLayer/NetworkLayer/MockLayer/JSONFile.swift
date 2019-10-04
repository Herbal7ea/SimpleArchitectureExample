import Foundation

enum JsonFile: String {
    
    var pathString: String { return self.rawValue.replacingOccurrences(of: "_", with: "/") }
    
    case people,
    transaction1 = "transactions_1",
    transaction2 = "transactions_2",
    transaction3 = "transactions_3",
    postings
}
