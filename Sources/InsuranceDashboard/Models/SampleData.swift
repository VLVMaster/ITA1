import Foundation

enum SampleData {
    static var policies: [DogPolicy] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        let expense1 = Expense(
            amount: 120,
            date: Date().addingTimeInterval(-86400 * 40),
            payee: "Happy Paws Vet",
            notes: "Annual checkup",
            receiptURL: nil,
            isClaimable: true,
            amountClaimed: 120
        )

        let expense2 = Expense(
            amount: 80,
            date: Date().addingTimeInterval(-86400 * 8),
            payee: "Healthy Hounds Clinic",
            notes: "Medication refill",
            receiptURL: nil,
            isClaimable: false,
            amountClaimed: 0
        )

        let claim1 = Claim(
            policyId: UUID(),
            title: "Allergy Treatment",
            status: .approved,
            expenses: [expense1],
            expectedReimbursement: 96,
            amountApproved: 96,
            reimbursements: [
                .init(amount: 96, date: Date().addingTimeInterval(-86400 * 15), reference: "PAY123")
            ]
        )

        let claim2 = Claim(
            policyId: UUID(),
            title: "Surgery",
            status: .submitted,
            expenses: [expense1],
            expectedReimbursement: 600,
            amountApproved: 0,
            reimbursements: []
        )

        return [
            DogPolicy(
                dogName: "Luna",
                provider: "Canine Shield",
                policyNumber: "CS-2390",
                annualLimit: 2000,
                excess: 75,
                coverPercentage: 0.8,
                renewalDate: formatter.date(from: "2024/10/10") ?? Date(),
                claims: [claim1, claim2],
                expenses: [expense1, expense2]
            ),
            DogPolicy(
                dogName: "Max",
                provider: "Healthy Hound",
                policyNumber: "HH-5421",
                annualLimit: 3000,
                excess: 100,
                coverPercentage: 0.9,
                renewalDate: formatter.date(from: "2025/01/18") ?? Date(),
                claims: [],
                expenses: []
            )
        ]
    }
}
