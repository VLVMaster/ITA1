import Foundation

struct DogPolicy: Identifiable, Hashable {
    let id = UUID()
    var dogName: String
    var photoSymbolName: String
    var provider: String
    var policyNumber: String
    var insuranceCode: String
    var coverageDescription: String
    var annualLimit: Decimal
    var excess: Decimal
    var coPay: Decimal
    var insurerCoveragePercentage: Double
    var ownerSharePercentage: Double
    var coverStartDate: Date
    var coverEndDate: Date

    var claims: [Claim]
    var expenses: [Expense]
    var healthIssues: [String]

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
        Calendar.current.dateComponents([.day], from: Date(), to: coverEndDate).day ?? 0
    }
}
