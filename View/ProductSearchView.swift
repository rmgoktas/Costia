import SwiftUI

struct ProductSearchView: View {
    @StateObject private var viewModel: ProductSearchViewModel
    @State private var showLoadingScreen: Bool = true
    @State private var showingAddItemView = false
    @State private var selectedMarket: Market?
    @State private var selectedQuantity: Int = 1
    
    init(searchText: String) {
        _viewModel = StateObject(wrappedValue: ProductSearchViewModel(searchText: searchText))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if showLoadingScreen {
                    loadingView
                } else {
                    productListView
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showLoadingScreen = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("En İyi Eşleşmeler")
                    
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddItemView) {
            addItemView
                .presentationDetents([.height(400)])
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
            Text("Sizin için en uygun fiyatları buluyoruz...")
                .font(.headline)
                .padding(.top, 40)
            Text("Lütfen bekleyin.")
                .font(.subheadline)
                .padding(.top, 10)
        }
    }
    
    private var productListView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Sonuçlar yükleniyor...")
                    .padding()
                    .scaleEffect(1.2)
            } else if viewModel.loadError {
                Text("Bir hata oluştu. Lütfen tekrar deneyin.")
                    .foregroundColor(.red)
            } else {
                List(viewModel.products) { product in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: product.imageURL)) { image in
                            image.resizable()
                                 .scaledToFit()
                                 .frame(height: 150)
                                 .cornerRadius(10)
                                 .padding(.horizontal)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(product.name)
                            .font(.title)
                            .padding(.bottom, 5)
                        
                        ForEach(product.markets, id: \.name) { market in
                            HStack {
                                Text(market.name)
                                Spacer()
                                Text("\(market.price, specifier: "%.2f")₺")
                                    .foregroundColor(market.price == viewModel.cheapestPrice ? .green : .gray)
                                    .font(market.price == viewModel.cheapestPrice ? .title2 : .body)
                                
                                Button(action: {
                                    selectedMarket = market
                                    showingAddItemView = true
                                }) {
                                    Image(systemName: "chevron.down")
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.leading)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var addItemView: some View {
        VStack {
            Text("Sepete Ekle")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Market: \(selectedMarket?.name ?? "")")
                    .padding()
                Spacer()
                Text("\(selectedMarket?.price ?? 0, specifier: "%.2f")₺")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Stepper("Adet: \(selectedQuantity)", value: $selectedQuantity, in: 1...99)
                .padding()

            HStack {
                Button("Kapat") {
                    showingAddItemView = false
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(10)
                
                Spacer()
                
                Button("Ekle") {
                    if let market = selectedMarket {
                        let item = CartItem(image: UIImage(named: "placeholder") ?? UIImage(), name: market.name, quantity: selectedQuantity, unitPrice: market.price)
                        CartViewModel().addItem(item)
                    }
                    showingAddItemView = false
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding(.horizontal)
    }
}


struct ProductSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSearchView(searchText: "123456789")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
