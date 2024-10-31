import SwiftUI

@main
struct CostiaApp: App {
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var cartViewModel = CartViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scannerViewModel)
                .environmentObject(cartViewModel)
        }
    }
}

