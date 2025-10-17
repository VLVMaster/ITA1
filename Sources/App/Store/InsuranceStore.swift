#if !os(Linux)
import Foundation
import Combine

final class InsuranceStore: ObservableObject {
    @Published var policies: [DogPolicy]
    @Published var selectedYear: Int

    init(policies: [DogPolicy] = SampleData.policies()) {
        self.policies = policies
        self.selectedYear = Calendar.current.component(.year, from: Date())
    }

    func addExpense(_ expense: VetExpense, to policyID: DogPolicy.ID) {
        guard let index = policies.firstIndex(where: { $0.id == policyID }) else { return }
        policies[index].expenses.append(expense)
    }

    func addClaim(_ claim: Claim, to policyID: DogPolicy.ID) {
        guard let index = policies.firstIndex(where: { $0.id == policyID }) else { return }
        policies[index].claims.insert(claim, at: 0)
    }

    func updateClaim(_ claim: Claim, in policyID: DogPolicy.ID) {
        guard let policyIndex = policies.firstIndex(where: { $0.id == policyID }) else { return }
        guard let claimIndex = policies[policyIndex].claims.firstIndex(where: { $0.id == claim.id }) else { return }
        policies[policyIndex].claims[claimIndex] = claim
    }

    func addReimbursement(_ reimbursement: Reimbursement, to claimID: Claim.ID, policyID: DogPolicy.ID) {
        guard let policyIndex = policies.firstIndex(where: { $0.id == policyID }) else { return }
        guard let claimIndex = policies[policyIndex].claims.firstIndex(where: { $0.id == claimID }) else { return }
        policies[policyIndex].claims[claimIndex].reimbursements.append(reimbursement)
    }

    func totalOutOfPocket(for year: Int) -> Decimal {
        policiesMatching(year: year).reduce(into: 0) { partial, policy in
            partial += policy.outOfPocketYTD
        }
    }

    func totalReimbursed(for year: Int) -> Decimal {
        policiesMatching(year: year).reduce(into: 0) { partial, policy in
            let reimbursed = policy.claims.reduce(into: 0) { accum, claim in
                accum += claim.reimbursedToDate
            }
            partial += reimbursed
        }
    }

    func totalOutstanding(for year: Int) -> Decimal {
        policiesMatching(year: year).reduce(into: 0) { partial, policy in
            partial += policy.outstandingClaimsTotal
        }
    }

    private func policiesMatching(year: Int) -> [DogPolicy] {
        policies.filter { policy in
            let policyYear = Calendar.current.component(.year, from: policy.coverageStart)
            return policyYear == year
        }
    }
}
#endif
