import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: InsuranceStore

    var body: some View {
        List {
            Section("Policy Year") {
                Picker("Policy Year", selection: $store.policyYearFilter) {
                    ForEach(yearOptions, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Policies") {
                ForEach(store.policies) { policy in
                    NavigationLink(value: policy) {
                        PolicyCard(policy: policy)
                    }
                }
            }
        }
        .navigationDestination(for: DogPolicy.self) { policy in
            PolicyDetailView(policy: policy)
        }
        .navigationTitle("Dashboard")
    }

    private var yearOptions: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current - 3)...(current + 1))
    }
}

private struct PolicyCard: View {
    let policy: DogPolicy

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(policy.dogName)
                    .font(.headline)
                Spacer()
                Text("Renewal in \(policy.renewalCountdown) days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                GridRow {
                    ValueTile(title: "Cover Used", value: policy.coverUsed, limit: policy.annualLimit)
                    ValueTile(title: "Outstanding", value: policy.outstandingClaimsTotal)
                }
                GridRow {
                    ValueTile(title: "Out-of-pocket", value: policy.outOfPocketYTD)
                    ValueTile(title: "Cover Remaining", value: policy.annualLimit - policy.coverUsed)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

private struct ValueTile: View {
    let title: String
    let value: Decimal
    var limit: Decimal?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value.currencyFormatted)
                .font(.headline)
            if let limit {
                ProgressView(value: (value as NSDecimalNumber).doubleValue,
                             total: (limit as NSDecimalNumber).doubleValue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(InsuranceStore())
    }
}
