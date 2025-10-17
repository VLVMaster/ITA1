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
                photoSymbolName: "pawprint.fill",
                provider: "Canine Shield",
                policyNumber: "CS-2390",
                insuranceCode: "LUNA-7842",
                coverageDescription: "Comprehensive illness and injury with holistic add-on",
                annualLimit: 2000,
                excess: 75,
                coPay: 25,
                insurerCoveragePercentage: 0.8,
                ownerSharePercentage: 0.2,
                coverStartDate: formatter.date(from: "2023/10/11") ?? Date(),
                coverEndDate: formatter.date(from: "2024/10/10") ?? Date(),
                claims: [claim1, claim2],
                expenses: [expense1, expense2],
                healthIssues: [
                    "Seasonal allergies",
                    "Hip dysplasia monitoring"
                ]
            ),
            DogPolicy(
                dogName: "Max",
                photoSymbolName: "dog.fill",
                provider: "Healthy Hound",
                policyNumber: "HH-5421",
                insuranceCode: "MAX-9981",
                coverageDescription: "Accident-only cover with dental add-on",
                annualLimit: 3000,
                excess: 100,
                coPay: 35,
                insurerCoveragePercentage: 0.85,
                ownerSharePercentage: 0.15,
                coverStartDate: formatter.date(from: "2024/01/19") ?? Date(),
                coverEndDate: formatter.date(from: "2025/01/18") ?? Date(),
                claims: [],
                expenses: [],
                healthIssues: [
                    "Sensitive stomach",
                    "Luxating patella"
                ]
            )
        ]
    }
}
