import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ScanView: View {
    var body: some View {
        VStack {
            Text("Scan View")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

struct MyListView: View {
    var body: some View {
        VStack {
            Text("My List View")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}

