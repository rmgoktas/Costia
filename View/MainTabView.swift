import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ev", systemImage: "house")
                }

            ScanView()
                .tabItem {
                    Label("Tara", systemImage: "magnifyingglass")
                }
        }
    }
}



