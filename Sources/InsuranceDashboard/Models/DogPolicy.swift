import Foundation

struct DogPolicy: Identifiable, Hashable {
    let id = UUID()
    var dogName: String
    var provider: String
    var policyNumber: String
    var annualLimit: Decimal
    var excess: Decimal
    var coverPercentage: Double
    var renewalDate: Date

    var claims: [Claim]
    var expenses: [Expense]

    var coverUsed: Decimal {
        claims.reduce(.zero) { $0 + $1.amountApproved }
    }

    var outstandingClaimsTotal: Decimal {
        claims.filter { $0.status == .submitted || $0.status == .approved }
            .reduce(.zero) { $0 + $1.outstandingAmount }
    }

    var outOfPocketYTD: Decimal {
        expenses.reduce(.zero) { $0 + $1.amount }
    }

    var renewalCountdown: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: renewalDate).day ?? 0
    }
}
