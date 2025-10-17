#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct ExpenseFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var policy: DogPolicy

    @State private var amount: Decimal = 0
    @State private var date = Date()
    @State private var payee = ""
    @State private var notes = ""
    @State private var receiptURL = ""
    @State private var isClaimable = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Payee", text: $payee)
                    TextField("Notes", text: $notes, axis: .vertical)
                }

                Section("Extras") {
                    TextField("Receipt URL", text: $receiptURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Toggle("Claimable", isOn: $isClaimable)
                }
            }
            .navigationTitle("Add Vet Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveExpense)
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        amount > 0 && !payee.isEmpty
    }

    private func saveExpense() {
        var receipt: URL?
        if let url = URL(string: receiptURL), !receiptURL.isEmpty {
            receipt = url
        }

        let expense = VetExpense(amount: amount, date: date, payee: payee, notes: notes, receiptLink: receipt, isClaimable: isClaimable)
        policy.expenses.append(expense)
        dismiss()
    }
}

struct ExpenseFormView_Previews: PreviewProvider {
    @State static var policy = SampleData.policies().first!

    static var previews: some View {
        ExpenseFormView(policy: $policy)
    }
}
#endif
