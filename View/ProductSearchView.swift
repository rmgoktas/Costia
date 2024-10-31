import SwiftUI

struct ProductSearchView: View {
    @StateObject private var viewModel: ProductSearchViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @State private var showLoadingScreen: Bool = true
    @State private var showingAddItemView = false
    @State private var showingCartView = false
    @State private var selectedMarket: Market?
    @State private var selectedQuantity: Int = 1
    @State private var selectedProduct: Product?
    private var imageLoader = ImageLoader()

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
            .sheet(isPresented: $showingAddItemView) {
                addItemView
                    .presentationDetents([.height(400)])
            }
            .sheet(isPresented: $showingCartView) {
                CartView(viewModel: _cartViewModel)
            }
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
                                    selectedProduct = product
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
                   Text("Market: \(selectedMarket?.name ?? "Seçim yapılmadı")")
                       .padding()
                   Spacer()
                   if let price = selectedMarket?.price {
                       Text("\(price, specifier: "%.2f")₺")
                           .font(.title2)
                           .foregroundColor(.green)
                           .padding()
                   } else {
                       Text("Fiyat yok")
                           .foregroundColor(.red)
                           .padding()
                   }
               }

               Stepper("Adet: \(selectedQuantity)", value: $selectedQuantity, in: 1...99)
                   .padding()

               Text("Toplam Fiyat: ₺\((Double(selectedQuantity) * (selectedMarket?.price ?? 0)), specifier: "%.2f")")
                   .font(.headline)
                   .padding()

               HStack {
                   Button("Kapat") {
                       showingAddItemView = false
                   }
                   .padding()
                   .background(Color.gray.opacity(0.2))
                   .cornerRadius(10)

                   Spacer()

                   Button("Sepete Ekle") {
                       if let market = selectedMarket, let product = selectedProduct {
                           imageLoader.loadImage(from: product.imageURL) { image in
                               let item = CartItem(
                                   id: UUID(),
                                   productName: product.name,
                                   marketName: market.name,
                                   quantity: selectedQuantity,
                                   unitPrice: market.price,
                                   image: image ?? UIImage() 
                               )
                               cartViewModel.addItem(item)
                           }
                           showingAddItemView = false
                       }
                   }
                   .padding()
                   .background(Color.gray.opacity(0.2))
                   .cornerRadius(10)
               }
               .padding()
           }
           .frame(maxHeight: 350)
           .frame(maxWidth: .infinity)
           .background(Color(UIColor.systemGray5))
           .cornerRadius(12)
           .shadow(radius: 20)
           .padding(.horizontal)
       }

    struct ProductSearchView_Previews: PreviewProvider {
        static var previews: some View {
            ProductSearchView(searchText: "123456789")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
        }
    }
}
