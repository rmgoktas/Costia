import SwiftUI
import VisionKit

struct ScannerView: View {
    
    @EnvironmentObject var vm: ScannerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = []
    
    var body: some View {
        NavigationView {
            VStack {
                switch vm.dataScannerAccessStatus {
                case .scannerAvailable:
                    mainView
                case .cameraNotAvailable:
                    Text("Cihazınız kameraya sahip değil.")
                case .scannerNotAvailable:
                    Text("Cihazınız bu uygulama ile barkod taramaya uygun değil.")
                case .cameraAccessNotGranted:
                    Text("Lütfen Ayarlar'dan kamera erişimi veriniz.")
                case .notDetermined:
                    Text("Kamera erişimi isteniyor...")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tara")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .onAppear {
                Task {
                    await vm.requestDataScannerAccessStatus()
                }
            }
        }
    }
    
    private var mainView: some View {
        VStack {
            DataScannerView(
                recognizedItems: $vm.recognizedItems,
                recognizedDataType: vm.recognizedDataType,
                recognizesMultipleItems: vm.recognizesMultipleItems,
                viewModel: vm
            )
            .background(Color.gray.opacity(0.3))
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            
            bottomContainerView
        }
        .onChange(of: vm.scanType) { _ in
            vm.recognizedItems.removeAll()
        }
        .onChange(of: vm.recognizesMultipleItems) { _ in
            vm.recognizedItems.removeAll()
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Tarama Türü", selection: $vm.scanType) {
                    Text("Barkod").tag(ScanType.barcode)
                    Text("Metin").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Çoklu tarama", isOn: $vm.recognizesMultipleItems)
            }.padding(.top)
            
            Text(vm.headerText).padding(.top)
        }.padding(.horizontal)
    }
    
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        NavigationLink(destination: ProductSearchView(searchText: itemText(for: item))) {
                            switch item {
                            case .barcode(let barcode):
                                Text(barcode.payloadStringValue ?? "Barkod bulunamadı.")
                                
                            case .text(let text):
                                Text(text.transcript)
                                
                            @unknown default:
                                Text("Bulunamadı")
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
    
    private func itemText(for item: RecognizedItem) -> String {
        switch item {
        case .barcode(let barcode):
            return barcode.payloadStringValue ?? "Bilinmeyen barkod"
        case .text(let text):
            return text.transcript
        @unknown default:
            return "Bilinmeyen ürün"
        }
    }
}

