import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var cartViewModel = CartViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Ev", systemImage: "house")
                }
                .tag(0)

            ScannerView()
                .tabItem {
                    Label("Tara", systemImage: "magnifyingglass")
                }
                .tag(1)
            CartView()
                .tabItem {
                    Label("Sepetim", systemImage: "cart")
                }
                .tag(2)
        }
    }
}
