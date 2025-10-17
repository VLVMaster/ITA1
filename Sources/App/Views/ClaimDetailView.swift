#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct ClaimDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var policy: DogPolicy
    @Binding var claim: Claim

    @State private var reimbursementAmount: Decimal = 0
    @State private var reimbursementReference = ""
    @State private var reimbursementDate = Date()

    private var expectedReimbursement: Decimal {
        policy.coveredAmount(for: claim)
    }

    private var outstanding: Decimal {
        max(expectedReimbursement - claim.reimbursedToDate, 0)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Claim Summary") {
                    HStack {
                        Text("Status")
                        Spacer()
                        StatusPill(status: claim.status)
                    }

                    Picker("Status", selection: $claim.status) {
                        ForEach(ClaimStatus.allCases) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Expected reimbursement")
                            Spacer()
                            Text(expectedReimbursement.formattedCurrency())
                        }
                        HStack {
                            Text("Approved amount")
                            Spacer()
                            Text((claim.approvedAmount ?? 0).formattedCurrency())
                        }
                        HStack {
                            Text("Reimbursed")
                            Spacer()
                            Text(claim.reimbursedToDate.formattedCurrency())
                        }
                        HStack {
                            Text("Outstanding")
                            Spacer()
                            Text(outstanding.formattedCurrency())
                                .foregroundStyle(outstanding > 0 ? Color.orange : .secondary)
                        }
                    }
                    .font(.subheadline)
                }

                Section("Expenses") {
                    if claim.expenses.isEmpty {
                        ContentUnavailableView("No expenses", systemImage: "stethoscope", description: Text("Attach vet bills to submit."))
                    } else {
                        ForEach(claim.expenses) { expense in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(expense.amount.formattedCurrency())
                                    Spacer()
                                    Text(expense.date, style: .date)
                                }
                                .font(.subheadline)

                                Text(expense.payee)
                                    .font(.footnote)
                                if !expense.notes.isEmpty {
                                    Text(expense.notes)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }

                Section("Reimbursements") {
                    if claim.reimbursements.isEmpty {
                        ContentUnavailableView("None logged", systemImage: "creditcard", description: Text("Add reimbursements as they are paid."))
                    } else {
                        ForEach(claim.reimbursements) { reimbursement in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(reimbursement.amount.formattedCurrency())
                                        .font(.headline)
                                    Text(reimbursement.reference)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(reimbursement.date, style: .date)
                                    .font(.footnote)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Log new payment")
                            .font(.subheadline)
                            .bold()

                        TextField("Amount", value: $reimbursementAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                            .keyboardType(.decimalPad)
                        TextField("Reference", text: $reimbursementReference)
                        DatePicker("Date", selection: $reimbursementDate, displayedComponents: .date)
                        Button {
                            addReimbursement()
                        } label: {
                            Label("Add payment", systemImage: "plus.circle.fill")
                        }
                        .disabled(!canAddReimbursement)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle(claim.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var canAddReimbursement: Bool {
        reimbursementAmount > 0 && !reimbursementReference.isEmpty
    }

    private func addReimbursement() {
        guard canAddReimbursement else { return }
        let reimbursement = Reimbursement(amount: reimbursementAmount, date: reimbursementDate, reference: reimbursementReference)
        claim.reimbursements.append(reimbursement)
        reimbursementAmount = 0
        reimbursementReference = ""
        reimbursementDate = Date()
    }
}

struct ClaimDetailView_Previews: PreviewProvider {
    @State static var policy = SampleData.policies().first!
    @State static var claim = SampleData.policies().first!.claims.first!

    static var previews: some View {
        ClaimDetailView(policy: $policy, claim: $claim)
    }
}
#endif
