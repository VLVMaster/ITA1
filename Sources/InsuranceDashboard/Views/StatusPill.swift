import SwiftUI

struct StatusPill: View {
    let status: Claim.Status

    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor, in: Capsule())
            .foregroundStyle(foregroundColor)
    }

    private var backgroundColor: Color {
        switch status {
        case .draft: Color.gray.opacity(0.2)
        case .submitted: Color.blue.opacity(0.2)
        case .approved: Color.green.opacity(0.2)
        case .paid: Color.teal.opacity(0.2)
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .draft: .gray
        case .submitted: .blue
        case .approved: .green
        case .paid: .teal
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(Claim.Status.allCases) { status in
            StatusPill(status: status)
        }
    }
    .padding()
}
