#if canImport(SwiftUI)
import SwiftUI

struct PolicyDetailView: View {
    @EnvironmentObject private var store: InsuranceStore
    @State private var isPresentingExpenseSheet = false
    @State private var selectedClaim: Claim?

    let policy: DogPolicy

    var body: some View {
        List {
            Section("Dog Profile") {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: policy.photoSymbolName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .padding(12)
                        .background(.blue.opacity(0.1), in: Circle())

                    VStack(alignment: .leading, spacing: 6) {
                        Text(policy.dogName)
                            .font(.title2)
                            .bold()
                        Text("Policy: \(policy.policyNumber)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(policy.provider)
                            .font(.subheadline)
                    }
                }

                if !policy.coverageDescription.isEmpty {
                    Text(policy.coverageDescription)
                        .font(.body)
                }
            }

            Section("Policy Details") {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        DetailTile(title: "Insurance Code", value: policy.insuranceCode)
                        DetailTile(title: "Provider", value: policy.provider)
                    }
                    GridRow {
                        DetailTile(title: "Policy No.", value: policy.policyNumber)
                        DetailTile(title: "Annual Limit", value: policy.annualLimit.currencyFormatted)
                    }
                    GridRow {
                        DetailTile(title: "Excess", value: policy.excess.currencyFormatted)
                        DetailTile(title: "Co-pay", value: policy.coPay.currencyFormatted)
                    }
                    GridRow {
                        DetailTile(title: "Insurer Pays", value: NumberFormatter.percent.string(from: NSNumber(value: policy.insurerCoveragePercentage)) ?? "")
                        DetailTile(title: "You Pay", value: NumberFormatter.percent.string(from: NSNumber(value: policy.ownerSharePercentage)) ?? "")
                    }
                    GridRow {
                        DetailTile(title: "Cover Start", value: policy.coverStartDate.formatted(date: .abbreviated, time: .omitted))
                        DetailTile(title: "Cover End", value: policy.coverEndDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    GridRow {
                        DetailTile(title: "Renewal Countdown", value: "\(policy.renewalCountdown) days")
                        DetailTile(title: "Cover Remaining", value: (policy.annualLimit - policy.coverUsed).currencyFormatted)
                    }
                }

                ProgressView(value: (policy.coverUsed as NSDecimalNumber).doubleValue,
                             total: (policy.annualLimit as NSDecimalNumber).doubleValue) {
                    Text("Cover Used")
                } currentValueLabel: {
                    Text(policy.coverUsed.currencyFormatted)
                }
            }

            if !policy.healthIssues.isEmpty {
                Section("Health Notes") {
                    ForEach(policy.healthIssues, id: \.self) { issue in
                        Text("• \(issue)")
                    }
                }
            }

            if !policy.expenses.isEmpty {
                Section("Expenses") {
                    ForEach(policy.expenses) { expense in
                        ExpenseRow(expense: expense)
                    }
                }
            }

            Section("Claims") {
                ForEach(policy.claims) { claim in
                    Button {
                        selectedClaim = claim
                    } label: {
                        ClaimRow(claim: claim)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(policy.dogName)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Vet Expense") {
                    isPresentingExpenseSheet = true
                }
                Spacer()
                Button("New Claim") {
                    selectedClaim = Claim(
                        policyId: policy.id,
                        title: "New Claim",
                        status: .draft,
                        expenses: [],
                        expectedReimbursement: 0,
                        amountApproved: 0,
                        reimbursements: []
                    )
                }
            }
        }
        .sheet(isPresented: $isPresentingExpenseSheet) {
            NavigationStack {
                AddExpenseView(policy: policy)
            }
        }
        .sheet(item: $selectedClaim) { claim in
            NavigationStack {
                ClaimDetailView(policy: policy, claim: claim)
            }
        }
    }
}

private struct DetailTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(expense.payee)
                    .font(.headline)
                Spacer()
                Text(expense.amount.currencyFormatted)
            }
            Text(expense.date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
            if !expense.notes.isEmpty {
                Text(expense.notes)
                    .font(.subheadline)
            }
            if expense.isClaimable {
                Text("Claimable")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.green.opacity(0.1), in: Capsule())
            }
        }
        .padding(.vertical, 6)
    }
}

private struct ClaimRow: View {
    let claim: Claim

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(claim.title)
                    .font(.headline)
                Spacer()
                StatusPill(status: claim.status)
            }
            Text("Expected: \(claim.expectedReimbursement.currencyFormatted)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if claim.amountApproved > 0 {
                Text("Approved: \(claim.amountApproved.currencyFormatted)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 6)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        PolicyDetailView(policy: SampleData.policies[0])
            .environmentObject(InsuranceStore())
    }
}
#endif
#endif
