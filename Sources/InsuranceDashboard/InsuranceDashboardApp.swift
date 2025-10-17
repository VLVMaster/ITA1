#if canImport(SwiftUI)
import SwiftUI

@main
struct InsuranceDashboardApp: App {
    @StateObject private var store = InsuranceStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    DashboardView()
                }
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2")
                }

                NavigationStack {
                    ReportsView()
                }
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.doc.horizontal")
                }
            }
            .environmentObject(store)
        }
    }
}
#endif
