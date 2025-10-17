#if canImport(SwiftUI)
import SwiftUI

struct ReportsView: View {
    @EnvironmentObject private var store: InsuranceStore

    private var filteredPolicies: [DogPolicy] {
        store.policies
    }

    private var totals: (outOfPocket: Decimal, reimbursed: Decimal, outstanding: Decimal) {
        let outOfPocket = filteredPolicies.reduce(Decimal.zero) { $0 + $1.outOfPocketYTD }
        let reimbursed = filteredPolicies.flatMap { $0.claims }
            .reduce(Decimal.zero) { sum, claim in
                sum + claim.reimbursements.reduce(.zero) { $0 + $1.amount }
            }
        let outstanding = filteredPolicies.reduce(Decimal.zero) { $0 + $1.outstandingClaimsTotal }
        return (outOfPocket, reimbursed, outstanding)
    }

    var body: some View {
        Form {
            Section("Policy Year") {
                Picker("Policy Year", selection: $store.policyYearFilter) {
                    ForEach(yearOptions, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Totals") {
                SummaryRow(title: "Out-of-pocket", value: totals.outOfPocket)
                SummaryRow(title: "Reimbursed", value: totals.reimbursed)
                SummaryRow(title: "Outstanding", value: totals.outstanding)
            }

            Section {
                Button("Export CSV") {
                    // Hook for later implementation
                }
                .disabled(true)
            }
        }
        .navigationTitle("Reports")
    }

    private var yearOptions: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current - 3)...(current + 1))
    }
}

private struct SummaryRow: View {
    let title: String
    let value: Decimal

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value.currencyFormatted)
                .font(.headline)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ReportsView()
            .environmentObject(InsuranceStore())
    }
}
#endif
#endif
