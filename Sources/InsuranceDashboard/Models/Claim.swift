import Foundation

struct Claim: Identifiable, Hashable {
    enum Status: String, CaseIterable, Identifiable {
        case draft
        case submitted
        case approved
        case paid

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .draft: "Draft"
            case .submitted: "Submitted"
            case .approved: "Approved"
            case .paid: "Paid"
            }
        }

        var accentColorName: String {
            switch self {
            case .draft: "Gray"
            case .submitted: "Blue"
            case .approved: "Green"
            case .paid: "Teal"
            }
        }
    }

    struct Reimbursement: Identifiable, Hashable {
        let id = UUID()
        var amount: Decimal
        var date: Date
        var reference: String
    }

    let id = UUID()
    var policyId: UUID
    var title: String
    var status: Status
    var expenses: [Expense]
    var expectedReimbursement: Decimal
    var amountApproved: Decimal
    var reimbursements: [Reimbursement]

    var outstandingAmount: Decimal {
        expectedReimbursement - reimbursements.reduce(.zero) { $0 + $1.amount }
    }
}
