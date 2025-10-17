import SwiftUI

struct PolicyDetailView: View {
    @EnvironmentObject private var store: InsuranceStore
    @State private var isPresentingExpenseSheet = false
    @State private var selectedClaim: Claim?

    let policy: DogPolicy

    var body: some View {
        List {
            Section("Policy Details") {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        DetailTile(title: "Provider", value: policy.provider)
                        DetailTile(title: "Policy No.", value: policy.policyNumber)
                    }
                    GridRow {
                        DetailTile(title: "Annual Limit", value: policy.annualLimit.currencyFormatted)
                        DetailTile(title: "Excess", value: policy.excess.currencyFormatted)
                    }
                    GridRow {
                        DetailTile(title: "Cover %", value: NumberFormatter.percent.string(from: NSNumber(value: policy.coverPercentage)) ?? "")
                        DetailTile(title: "Renewal", value: policy.renewalDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }

                ProgressView(value: (policy.coverUsed as NSDecimalNumber).doubleValue,
                             total: (policy.annualLimit as NSDecimalNumber).doubleValue) {
                    Text("Cover Used")
                } currentValueLabel: {
                    Text(policy.coverUsed.currencyFormatted)
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

#Preview {
    NavigationStack {
        PolicyDetailView(policy: SampleData.policies[0])
            .environmentObject(InsuranceStore())
    }
}
