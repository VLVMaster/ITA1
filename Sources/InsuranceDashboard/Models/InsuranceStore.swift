#if canImport(Combine)
import Combine
import Foundation

@MainActor
final class InsuranceStore: ObservableObject {
    @Published var policies: [DogPolicy]
    @Published var policyYearFilter: Int

    init(policies: [DogPolicy] = SampleData.policies) {
        self.policies = policies
        self.policyYearFilter = Calendar.current.component(.year, from: Date())
    }

    func addExpense(_ expense: Expense, to policy: DogPolicy) {
        guard let index = policies.firstIndex(of: policy) else { return }
        policies[index].expenses.append(expense)
    }

    func addReimbursement(_ reimbursement: Claim.Reimbursement, to claim: Claim, policy: DogPolicy) {
        guard let policyIndex = policies.firstIndex(of: policy),
              let claimIndex = policies[policyIndex].claims.firstIndex(of: claim) else { return }
        policies[policyIndex].claims[claimIndex].reimbursements.append(reimbursement)
    }

    func updateClaim(_ claim: Claim, for policy: DogPolicy) {
        guard let policyIndex = policies.firstIndex(of: policy) else { return }
        if let claimIndex = policies[policyIndex].claims.firstIndex(where: { $0.id == claim.id }) {
            policies[policyIndex].claims[claimIndex] = claim
        } else {
            policies[policyIndex].claims.append(claim)
        }
    }
}
#endif
