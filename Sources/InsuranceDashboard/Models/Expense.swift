import Foundation

struct Expense: Identifiable, Hashable {
    let id = UUID()
    var amount: Decimal
    var date: Date
    var payee: String
    var notes: String
    var receiptURL: URL?
    var isClaimable: Bool
    var amountClaimed: Decimal
}
