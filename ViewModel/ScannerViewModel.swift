import AVKit
import Foundation
import SwiftUI
import VisionKit


enum ScanType: String {
    case barcode, text
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class ScannerViewModel: ObservableObject {
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    public var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems: Bool = false
    @Published var selectedItem: RecognizedItem?
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recognizedItems.isEmpty {
            return "\(scanType.rawValue.capitalized) taranıyor."
        } else {
            return "\(recognizedItems.count) ürün bulundu."
        }
    }
    
    var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        
        default: break
        }
    }
    
    private var captureSession: AVCaptureSession?
    
    func stopCaptureSession() {
        captureSession?.stopRunning()
    }

    func startCaptureSession() {
        captureSession?.startRunning()
    }

    func changeScanType(to newScanType: ScanType) async {
        stopCaptureSession()

        scanType = newScanType

        startCaptureSession()
    }
    
    func selectItem(_ item: RecognizedItem) {
        selectedItem = item
    }
    
    func handleRecognizedItem(_ item: RecognizedItem) {
        if !recognizesMultipleItems {
            recognizedItems = [item]
        } else {
            recognizedItems.append(item)
        }
    }
    
    func printRecognizedItem(_ item: RecognizedItem) {
        switch item {
        case .barcode(let barcode):
            print("Taranan Barkod: \(barcode.payloadStringValue ?? "Barkod bulunamadı.")")
            
        case .text(let text):
            print("Taranan Metin: \(text.transcript)")
            
        @unknown default:
            print("Bilinmeyen tarama tipi")
        }
    }
}


