#if os(Linux)
@main
struct InsuranceDashboardCLI {
    static func main() {
        print("Insurance Dashboard SwiftUI app is available when built for Apple platforms.")
    }
}
#else
import SwiftUI

@main
struct InsuranceDashboardApp: App {
    @StateObject private var store = InsuranceStore()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(store)
        }
    }
}
#endif
