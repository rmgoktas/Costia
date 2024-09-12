import SwiftUI

@main
struct CostiaApp: App {
    @StateObject private var scannerViewModel = ScannerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scannerViewModel)
        }
    }
}

