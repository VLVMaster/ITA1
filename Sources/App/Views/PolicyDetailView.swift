#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct PolicyDetailView: View {
    @EnvironmentObject private var store: InsuranceStore
    @Binding var policy: DogPolicy

    @State private var showingExpenseForm = false
    @State private var selectedClaim: Claim?

    var body: some View {
        List {
            coverageSection
            expensesSection
            claimsSection
            notesSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle(policy.dogName)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    showingExpenseForm = true
                } label: {
                    Label("Add Vet Expense", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    createNewClaim()
                } label: {
                    Label("New Claim", systemImage: "doc.badge.plus")
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showingExpenseForm) {
            ExpenseFormView(policy: $policy)
        }
        .sheet(item: $selectedClaim) { claim in
            ClaimDetailView(policy: $policy, claim: binding(for: claim))
                .environmentObject(store)
        }
    }

    private var coverageSection: some View {
        Section("Policy Summary") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: policy.photoSymbol)
                        .font(.system(size: 52))
                        .frame(width: 70, height: 70)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(policy.provider)
                            .font(.headline)
                        Text("Policy #\(policy.policyNumber)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(policy.coverageDescription)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ProgressView(value: policy.coverUsed.doubleValue, total: policy.annualLimit.doubleValue) {
                        HStack {
                            Text("Cover used")
                            Spacer()
                            Text("\(Int(policy.coverUsed.doubleValue / policy.annualLimit.doubleValue * 100))%")
                                .foregroundStyle(.secondary)
                        }
                        .font(.footnote)
                    }

                    HStack {
                        Label(policy.coverageStart.formatted("dd MMM yyyy"), systemImage: "calendar")
                        Spacer()
                        Text("to")
                        Spacer()
                        Label(policy.coverageEnd.formatted("dd MMM yyyy"), systemImage: "calendar")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                Grid(horizontalSpacing: 20, verticalSpacing: 12) {
                    GridRow {
                        summaryCell(title: "Annual limit", value: policy.annualLimit.formattedCurrency())
                        summaryCell(title: "Excess", value: policy.excess.formattedCurrency())
                    }
                    GridRow {
                        summaryCell(title: "Cover %", value: NumberFormatter.percentFormatter.string(from: NSNumber(value: policy.coverPercentage)) ?? "-")
                        summaryCell(title: "Co-pay", value: NumberFormatter.percentFormatter.string(from: NSNumber(value: policy.coPayPercentage)) ?? "-")
                    }
                    GridRow {
                        summaryCell(title: "You pay", value: NumberFormatter.percentFormatter.string(from: NSNumber(value: policy.ownerSharePercentage)) ?? "-")
                        summaryCell(title: "Renewal", value: policy.renewalDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var expensesSection: some View {
        Section("Expenses") {
            if policy.expenses.isEmpty {
                ContentUnavailableView("No expenses logged", systemImage: "stethoscope", description: Text("Use Add Vet Expense to track costs."))
            } else {
                ForEach(policy.expenses) { expense in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(expense.amount.formattedCurrency())
                                .font(.headline)
                            Spacer()
                            Text(expense.date, style: .date)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Text(expense.payee)
                            .font(.subheadline)
                        if !expense.notes.isEmpty {
                            Text(expense.notes)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        if let receipt = expense.receiptLink {
                            Link("Receipt", destination: receipt)
                                .font(.footnote)
                        }
                        if expense.isClaimable {
                            Label("Claimable", systemImage: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var claimsSection: some View {
        Section("Claims") {
            if policy.claims.isEmpty {
                ContentUnavailableView("No claims", systemImage: "doc.plaintext", description: Text("Log claims to monitor reimbursements."))
            } else {
                ForEach(policy.claims) { claim in
                    Button {
                        selectedClaim = claim
                    } label: {
                        ClaimRow(policy: policy, claim: claim)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var notesSection: some View {
        Section("Health Notes") {
            if policy.healthNotes.isEmpty {
                Text("No notes recorded.")
            } else {
                ForEach(policy.healthNotes, id: \.self) { note in
                    Label(note, systemImage: "pawprint")
                }
            }
        }
    }

    private func summaryCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func binding(for claim: Claim) -> Binding<Claim> {
        guard let index = policy.claims.firstIndex(where: { $0.id == claim.id }) else {
            return .constant(claim)
        }
        return $policy.claims[index]
    }

    private func createNewClaim() {
        let newClaim = Claim(title: "New Claim", status: .draft, openedOn: Date())
        policy.claims.insert(newClaim, at: 0)
        selectedClaim = newClaim
    }
}

private struct ClaimRow: View {
    let policy: DogPolicy
    let claim: Claim

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(claim.title)
                    .font(.headline)
                Spacer()
                StatusPill(status: claim.status)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Expected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(policy.coveredAmount(for: claim).formattedCurrency())
                        .font(.subheadline)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Reimbursed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(claim.reimbursedToDate.formattedCurrency())
                        .font(.subheadline)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Outstanding")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    let outstanding = max(policy.coveredAmount(for: claim) - claim.reimbursedToDate, 0)
                    Text(outstanding.formattedCurrency())
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}

struct PolicyDetailView_Previews: PreviewProvider {
    @State static var policy = SampleData.policies().first!

    static var previews: some View {
        NavigationStack {
            PolicyDetailView(policy: $policy)
                .environmentObject(InsuranceStore())
        }
    }
}
#endif
