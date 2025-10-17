#if !os(Linux)
import Foundation
import SwiftUI

enum ClaimStatus: String, CaseIterable, Identifiable, Codable {
    case draft
    case submitted
    case approved
    case paid
    case denied

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .draft: return "Draft"
        case .submitted: return "Submitted"
        case .approved: return "Approved"
        case .paid: return "Paid"
        case .denied: return "Denied"
        }
    }

    var tint: Color {
        switch self {
        case .draft: return .gray
        case .submitted: return .blue
        case .approved: return .green
        case .paid: return .teal
        case .denied: return .red
        }
    }
}

struct VetExpense: Identifiable, Hashable, Codable {
    let id: UUID
    var amount: Decimal
    var date: Date
    var payee: String
    var notes: String
    var receiptLink: URL?
    var isClaimable: Bool

    init(id: UUID = UUID(), amount: Decimal, date: Date, payee: String, notes: String, receiptLink: URL? = nil, isClaimable: Bool) {
        self.id = id
        self.amount = amount
        self.date = date
        self.payee = payee
        self.notes = notes
        self.receiptLink = receiptLink
        self.isClaimable = isClaimable
    }
}

struct Reimbursement: Identifiable, Hashable, Codable {
    let id: UUID
    var amount: Decimal
    var date: Date
    var reference: String

    init(id: UUID = UUID(), amount: Decimal, date: Date, reference: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.reference = reference
    }
}

struct Claim: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var status: ClaimStatus
    var openedOn: Date
    var expenses: [VetExpense]
    var approvedAmount: Decimal?
    var reimbursements: [Reimbursement]

    init(id: UUID = UUID(), title: String, status: ClaimStatus, openedOn: Date, expenses: [VetExpense] = [], approvedAmount: Decimal? = nil, reimbursements: [Reimbursement] = []) {
        self.id = id
        self.title = title
        self.status = status
        self.openedOn = openedOn
        self.expenses = expenses
        self.approvedAmount = approvedAmount
        self.reimbursements = reimbursements
    }

    var reimbursedToDate: Decimal {
        reimbursements.reduce(into: 0) { $0 += $1.amount }
    }

    var totalClaimableExpenses: Decimal {
        expenses.filter { $0.isClaimable }.reduce(into: 0) { $0 += $1.amount }
    }
}

struct DogPolicy: Identifiable, Hashable, Codable {
    let id: UUID
    var dogName: String
    var photoSymbol: String
    var provider: String
    var policyNumber: String
    var annualLimit: Decimal
    var excess: Decimal
    var coverPercentage: Double
    var coPayPercentage: Double
    var coverageStart: Date
    var coverageEnd: Date
    var renewalDate: Date
    var ownerSharePercentage: Double
    var coverageDescription: String
    var healthNotes: [String]
    var expenses: [VetExpense]
    var claims: [Claim]

    init(
        id: UUID = UUID(),
        dogName: String,
        photoSymbol: String,
        provider: String,
        policyNumber: String,
        annualLimit: Decimal,
        excess: Decimal,
        coverPercentage: Double,
        coPayPercentage: Double,
        coverageStart: Date,
        coverageEnd: Date,
        renewalDate: Date,
        ownerSharePercentage: Double,
        coverageDescription: String,
        healthNotes: [String] = [],
        expenses: [VetExpense] = [],
        claims: [Claim] = []
    ) {
        self.id = id
        self.dogName = dogName
        self.photoSymbol = photoSymbol
        self.provider = provider
        self.policyNumber = policyNumber
        self.annualLimit = annualLimit
        self.excess = excess
        self.coverPercentage = coverPercentage
        self.coPayPercentage = coPayPercentage
        self.coverageStart = coverageStart
        self.coverageEnd = coverageEnd
        self.renewalDate = renewalDate
        self.ownerSharePercentage = ownerSharePercentage
        self.coverageDescription = coverageDescription
        self.healthNotes = healthNotes
        self.expenses = expenses
        self.claims = claims
    }

    var coverUsed: Decimal {
        claims.reduce(into: 0) { partial, claim in
            partial += coveredAmount(for: claim)
        }
    }

    var remainingCover: Decimal {
        max(annualLimit - coverUsed, 0)
    }

    func coveredAmount(for claim: Claim) -> Decimal {
        let claimable = claim.approvedAmount ?? claim.totalClaimableExpenses
        let insurerShare = claimable * Decimal(coverPercentage)
        let afterCopay = insurerShare * Decimal(1 - coPayPercentage)
        return max(afterCopay, 0)
    }

    var outstandingClaimsTotal: Decimal {
        claims.reduce(into: 0) { partial, claim in
            let due = coveredAmount(for: claim) - claim.reimbursedToDate
            if due > 0 { partial += due }
        }
    }

    var outOfPocketYTD: Decimal {
        let claimableSpend = claims.reduce(into: 0) { partial, claim in
            partial += claim.totalClaimableExpenses
        }
        let reimbursed = claims.reduce(into: 0) { partial, claim in
            partial += claim.reimbursedToDate
        }
        return max(claimableSpend - reimbursed, 0)
    }
}

extension Decimal {
    static func += (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs + rhs
    }

    func formattedCurrency(locale: Locale = .current) -> String {
        let formatter = NumberFormatter.currencyFormatter(locale: locale)
        return formatter.string(from: self as NSDecimalNumber) ?? "£0"
    }

    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}

extension NumberFormatter {
    static func currencyFormatter(locale: Locale = .current) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter
    }

    static var percentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }
}

extension Date {
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
#endif
