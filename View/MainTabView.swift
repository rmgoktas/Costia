import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Ev", systemImage: "house")
                }
                .tag(0)

            ScanView()
                .tabItem {
                    Label("Tara", systemImage: "magnifyingglass")
                }
                .tag(1)
        }
    }
}



