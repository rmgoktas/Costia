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
            .navigationBarTitle("Tara", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
            .onAppear {
                Task {
                    await vm.requestDataScannerAccessStatus()
                }
            }
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems,
            viewModel: vm
        )
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId)
        .sheet(isPresented: .constant(true)) {
            bottomContainerView
                .background(.ultraThinMaterial)
                .presentationDetents([.medium, .fraction(0.25)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .onAppear {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                        return
                    }
                    controller.view.backgroundColor = .clear
                }
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
                        Button(action: {
                            navigateToProductSearchView(item: item)
                        }) {
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
    
    private func navigateToProductSearchView(item: RecognizedItem) {
        var searchText = ""
        
        switch item {
        case .barcode(let barcode):
            searchText = barcode.payloadStringValue ?? "Bilinmeyen barkod"
        case .text(let text):
            searchText = text.transcript
        @unknown default:
            searchText = "Bilinmeyen ürün"
        }
        
        
        let productSearchView = ProductSearchView(searchText: searchText)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: productSearchView)
        }
    }
}

