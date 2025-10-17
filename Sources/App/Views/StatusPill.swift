#if canImport(SwiftUI) && !os(Linux)
import SwiftUI

struct StatusPill: View {
    let status: ClaimStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(status.tint.opacity(0.15))
            .foregroundStyle(status.tint)
            .clipShape(Capsule())
    }
}

struct StatusPill_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            ForEach(ClaimStatus.allCases) { status in
                StatusPill(status: status)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
