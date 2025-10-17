#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: InsuranceStore

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach($store.policies) { $policy in
                        NavigationLink(destination: PolicyDetailView(policy: $policy)) {
                            PolicyCard(policy: policy)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Dashboard")
            }
            .tabItem {
                Label("Dashboard", systemImage: "speedometer")
            }

            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar")
                }
        }
    }
}

private struct PolicyCard: View {
    let policy: DogPolicy

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: policy.photoSymbol)
                    .font(.largeTitle)
                    .frame(width: 48, height: 48)
                    .padding(12)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(policy.dogName)
                        .font(.title3.bold())
                    Text("Policy · \(policy.provider)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Renewal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(policy.renewalDate, style: .date)
                        .font(.subheadline)
                        .bold()
                }
            }

            ProgressView(value: policy.coverUsed.doubleValue, total: policy.annualLimit.doubleValue) {
                Text("Cover used")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            HStack {
                MetricColumn(title: "Used", value: policy.coverUsed.formattedCurrency())
                Divider()
                MetricColumn(title: "Remaining", value: policy.remainingCover.formattedCurrency())
                Divider()
                MetricColumn(title: "Outstanding", value: policy.outstandingClaimsTotal.formattedCurrency())
                Divider()
                MetricColumn(title: "Out-of-pocket", value: policy.outOfPocketYTD.formattedCurrency())
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        )
        .padding(.horizontal)
    }
}

private struct MetricColumn: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .semibold))
            Text(value)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(InsuranceStore())
    }
}
#endif
