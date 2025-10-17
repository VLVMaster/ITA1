#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct ReportsView: View {
    @EnvironmentObject private var store: InsuranceStore

    private var availableYears: [Int] {
        let years = store.policies.map { Calendar.current.component(.year, from: $0.coverageStart) }
        return Array(Set(years)).sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Policy year") {
                    Picker("Policy year", selection: $store.selectedYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Totals") {
                    ReportRow(title: "Out-of-pocket", amount: store.totalOutOfPocket(for: store.selectedYear))
                    ReportRow(title: "Reimbursed", amount: store.totalReimbursed(for: store.selectedYear))
                    ReportRow(title: "Outstanding", amount: store.totalOutstanding(for: store.selectedYear))
                }

                Section {
                    Button(action: {}) {
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                    }
                    .disabled(true)
                    .tint(.accentColor)
                }
            }
            .navigationTitle("Reports")
        }
    }
}

private struct ReportRow: View {
    let title: String
    let amount: Decimal

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(amount.formattedCurrency())
                .bold()
        }
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
            .environmentObject(InsuranceStore())
    }
}
#endif
