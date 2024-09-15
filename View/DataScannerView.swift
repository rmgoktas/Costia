import Foundation
import SwiftUI
import VisionKit
import AVKit

struct DataScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedItems: [RecognizedItem]
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    var viewModel: ScannerViewModel
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator

        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems, viewModel: viewModel)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Binding var recognizedItems: [RecognizedItem]
        var viewModel: ScannerViewModel
        
        init(recognizedItems: Binding<[RecognizedItem]>, viewModel: ScannerViewModel) {
            self._recognizedItems = recognizedItems
            self.viewModel = viewModel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                if let payload = barcode.payloadStringValue {
                    print("Taranan barkod: \(payload)")
                    DispatchQueue.main.async {
                        self.viewModel.selectedItem = item
                    }
                } else {
                    print("Barkod okunamadı.")
                }
                
            case .text(let text):
                let transcript = text.transcript
                print("Taranan metin: \(transcript)")
                DispatchQueue.main.async {
                    self.viewModel.selectedItem = item
                }
                
            @unknown default:
                print("Bilinmeyen tarama türü")
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: { $0.id == item.id })
            }
        }
    }
}



