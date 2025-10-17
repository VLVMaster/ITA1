#if !os(Linux)
import Foundation

enum SampleData {
    static let calendar = Calendar.current

    static func policies() -> [DogPolicy] {
        let today = Date()
        let yearComponent = calendar.dateComponents([.year], from: today).year ?? 2024

        let startOfYear = calendar.date(from: DateComponents(year: yearComponent, month: 1, day: 1)) ?? today
        let endOfYear = calendar.date(from: DateComponents(year: yearComponent, month: 12, day: 31)) ?? today
        let renewal = calendar.date(byAdding: .day, value: 120, to: today) ?? today

        let riley = DogPolicy(
            dogName: "Riley",
            photoSymbol: "dog.fill",
            provider: "Happy Paws Insurance",
            policyNumber: "HP-349221",
            annualLimit: 6000,
            excess: 125,
            coverPercentage: 0.8,
            coPayPercentage: 0.1,
            coverageStart: startOfYear,
            coverageEnd: endOfYear,
            renewalDate: renewal,
            ownerSharePercentage: 0.2,
            coverageDescription: "Comprehensive illness & injury cover with complementary therapies",
            healthNotes: [
                "Ongoing allergies - weekly cytopoint",
                "Hip dysplasia monitoring"
            ],
            expenses: [
                VetExpense(amount: 75, date: today, payee: "Pawsome Vets", notes: "Annual wellness exam", isClaimable: false)
            ],
            claims: [
                Claim(
                    title: "Knee Surgery",
                    status: .approved,
                    openedOn: calendar.date(byAdding: .month, value: -6, to: today) ?? today,
                    expenses: [
                        VetExpense(amount: 1800, date: calendar.date(byAdding: .month, value: -7, to: today) ?? today, payee: "Pawsome Vets", notes: "TPLO surgery", isClaimable: true),
                        VetExpense(amount: 220, date: calendar.date(byAdding: .month, value: -6, to: today) ?? today, payee: "Pawsome Vets", notes: "Follow-up x-ray", isClaimable: true)
                    ],
                    approvedAmount: 1600,
                    reimbursements: [
                        Reimbursement(amount: 1200, date: calendar.date(byAdding: .month, value: -5, to: today) ?? today, reference: "PAY-8712")
                    ]
                ),
                Claim(
                    title: "Allergy Management",
                    status: .submitted,
                    openedOn: calendar.date(byAdding: .month, value: -2, to: today) ?? today,
                    expenses: [
                        VetExpense(amount: 180, date: calendar.date(byAdding: .month, value: -2, to: today) ?? today, payee: "DermVet Clinic", notes: "Cytopoint injection", isClaimable: true)
                    ]
                )
            ]
        )

        let lola = DogPolicy(
            dogName: "Lola",
            photoSymbol: "dog.circle.fill",
            provider: "Best Friends Mutual",
            policyNumber: "BF-228910",
            annualLimit: 8000,
            excess: 100,
            coverPercentage: 0.9,
            coPayPercentage: 0.0,
            coverageStart: startOfYear,
            coverageEnd: endOfYear,
            renewalDate: calendar.date(byAdding: .month, value: 8, to: today) ?? today,
            ownerSharePercentage: 0.1,
            coverageDescription: "Accident & illness cover with dental add-on",
            healthNotes: [
                "Luxating patella history",
                "Daily joint supplements"
            ],
            expenses: [
                VetExpense(amount: 95, date: calendar.date(byAdding: .day, value: -12, to: today) ?? today, payee: "CityVet", notes: "Anal gland expression", isClaimable: false)
            ],
            claims: [
                Claim(
                    title: "Patella Consultation",
                    status: .paid,
                    openedOn: calendar.date(byAdding: .month, value: -10, to: today) ?? today,
                    expenses: [
                        VetExpense(amount: 350, date: calendar.date(byAdding: .month, value: -10, to: today) ?? today, payee: "CityVet", notes: "Specialist consultation", isClaimable: true)
                    ],
                    approvedAmount: 315,
                    reimbursements: [
                        Reimbursement(amount: 315, date: calendar.date(byAdding: .month, value: -9, to: today) ?? today, reference: "PAY-5531")
                    ]
                )
            ]
        )

        let max = DogPolicy(
            dogName: "Max",
            photoSymbol: "pawprint.circle.fill",
            provider: "TailGuard",
            policyNumber: "TG-982110",
            annualLimit: 5000,
            excess: 150,
            coverPercentage: 0.7,
            coPayPercentage: 0.2,
            coverageStart: startOfYear,
            coverageEnd: endOfYear,
            renewalDate: calendar.date(byAdding: .month, value: 5, to: today) ?? today,
            ownerSharePercentage: 0.3,
            coverageDescription: "Injury first policy with behavioural therapy allowance",
            healthNotes: [
                "Arthritis in rear legs",
                "Behavioural reactivity - in training"
            ],
            expenses: [
                VetExpense(amount: 210, date: calendar.date(byAdding: .month, value: -1, to: today) ?? today, payee: "Northside Vet", notes: "Cold laser therapy", isClaimable: true)
            ],
            claims: [
                Claim(
                    title: "Physio Course",
                    status: .draft,
                    openedOn: calendar.date(byAdding: .month, value: -1, to: today) ?? today,
                    expenses: [
                        VetExpense(amount: 210, date: calendar.date(byAdding: .month, value: -1, to: today) ?? today, payee: "Northside Vet", notes: "Laser therapy", isClaimable: true)
                    ]
                )
            ]
        )

        return [riley, lola, max]
    }
}
#endif
