#if canImport(SwiftUI)
import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: InsuranceStore

    @State private var amount: Decimal = 0
    @State private var date: Date = Date()
    @State private var payee: String = ""
    @State private var notes: String = ""
    @State private var receiptLink: String = ""
    @State private var isClaimable: Bool = true

    let policy: DogPolicy

    var body: some View {
        Form {
            Section("Expense") {
                DecimalField("Amount", value: $amount)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Payee", text: $payee)
                TextField("Notes", text: $notes, axis: .vertical)
                TextField("Receipt URL", text: $receiptLink)
                Toggle("Claimable", isOn: $isClaimable)
            }
        }
        .navigationTitle("Add Expense")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: dismiss.callAsFunction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: save)
                    .disabled(!isValid)
            }
        }
        .onAppear {
            date = Date()
        }
    }

    private var isValid: Bool {
        amount > 0 && !payee.isEmpty
    }

    private func save() {
        guard isValid else { return }
        let receiptURL = URL(string: receiptLink)
        let expense = Expense(
            amount: amount,
            date: date,
            payee: payee,
            notes: notes,
            receiptURL: receiptURL,
            isClaimable: isClaimable,
            amountClaimed: isClaimable ? amount : 0
        )
        store.addExpense(expense, to: policy)
        dismiss()
    }
}

private struct DecimalField: View {
    let title: String
    @Binding var value: Decimal

    init(_ title: String, value: Binding<Decimal>) {
        self.title = title
        _value = value
    }

    var body: some View {
        TextField(title, text: Binding(
            get: { value.currencyFormatted },
            set: { newValue in
                let cleaned = newValue.replacingOccurrences(of: "£", with: "")
                value = Decimal(string: cleaned) ?? 0
            }
        ))
        .keyboardType(.decimalPad)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        AddExpenseView(policy: SampleData.policies[0])
            .environmentObject(InsuranceStore())
    }
}
#endif
#endif
