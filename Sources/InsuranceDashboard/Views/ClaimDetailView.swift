#if canImport(SwiftUI)
import SwiftUI

struct ClaimDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: InsuranceStore

    @State private var workingClaim: Claim
    @State private var newReimbursementAmount: Decimal = 0
    @State private var newReimbursementDate: Date = Date()
    @State private var newReimbursementReference: String = ""

    let policy: DogPolicy

    init(policy: DogPolicy, claim: Claim) {
        self.policy = policy
        _workingClaim = State(initialValue: claim)
    }

    var body: some View {
        Form {
            Section("Claim") {
                TextField("Title", text: $workingClaim.title)
                Picker("Status", selection: $workingClaim.status) {
                    ForEach(Claim.Status.allCases) { status in
                        Text(status.displayName).tag(status)
                    }
                }
                Text("Expected reimbursement: \(workingClaim.expectedReimbursement.currencyFormatted)")
                if workingClaim.amountApproved > 0 {
                    Text("Approved: \(workingClaim.amountApproved.currencyFormatted)")
                }
            }

            Section("Expenses") {
                if workingClaim.expenses.isEmpty {
                    Text("No expenses attached yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(workingClaim.expenses) { expense in
                        HStack {
                            Text(expense.payee)
                            Spacer()
                            Text(expense.amount.currencyFormatted)
                        }
                    }
                }
            }

            Section("Reimbursements") {
                ForEach(workingClaim.reimbursements) { reimbursement in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(reimbursement.date, style: .date)
                            Spacer()
                            Text(reimbursement.amount.currencyFormatted)
                        }
                        if !reimbursement.reference.isEmpty {
                            Text(reimbursement.reference)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    DecimalField("Amount", value: $newReimbursementAmount)
                    DatePicker("Date", selection: $newReimbursementDate, displayedComponents: .date)
                    TextField("Reference", text: $newReimbursementReference)
                    Button("Add Payment", action: addReimbursement)
                        .disabled(newReimbursementAmount <= 0)
                }
            }

            Section("Summary") {
                StatusPill(status: workingClaim.status)
                Text("Outstanding: \(workingClaim.outstandingAmount.currencyFormatted)")
            }
        }
        .navigationTitle("Claim Detail")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close", action: dismiss.callAsFunction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(buttonTitle, action: save)
            }
        }
    }

    private func save() {
        store.updateClaim(workingClaim, for: policy)
        dismiss()
    }

    private var buttonTitle: String {
        switch workingClaim.status {
        case .draft: "Submit"
        case .submitted: "Mark as Approved"
        case .approved: "Mark as Paid"
        case .paid: "Done"
        }
    }

    private func addReimbursement() {
        guard newReimbursementAmount > 0 else { return }
        let reimbursement = Claim.Reimbursement(
            amount: newReimbursementAmount,
            date: newReimbursementDate,
            reference: newReimbursementReference
        )
        workingClaim.reimbursements.append(reimbursement)
        newReimbursementAmount = 0
        newReimbursementDate = Date()
        newReimbursementReference = ""
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ClaimDetailView(policy: SampleData.policies[0], claim: SampleData.policies[0].claims[0])
            .environmentObject(InsuranceStore())
    }
}
#endif
#endif
