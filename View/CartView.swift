import SwiftUI

struct CartView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: CartViewModel
    @State private var showingAddItemView = false
    @State private var selectedItem: CartItem? = nil
    @State private var isItemExpanded = false
    @State private var searchText: String = ""
    @State private var searchResults: [Product] = []
    @State private var selectedMarket: Market? = nil
    @State private var selectedProduct: Product? = nil
    @State private var imageCache: [String: UIImage] = [:]
    @State private var showingSearchResults = false
    @State private var selectedQuantity: Int = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Ürün ara...", text: $searchText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        Button(action: {
                            if !searchText.isEmpty {
                                searchProducts(with: searchText)
                                showingSearchResults = true
                            } else {
                                searchResults.removeAll()
                            }
                        }) {
                            Text("Ara")
                                .padding(.trailing, 30)
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                    
                    if viewModel.cartItems.isEmpty {
                        Text("Henüz ürün eklemediniz.")
                            .font(.headline)
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.cartItems) { item in
                                HStack {
                                    Image(uiImage: item.image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.productName)
                                            .font(.headline)
                                        Text(item.marketName)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Adet: \(item.quantity)")
                                        Text("Toplam Fiyat: ₺\(item.unitPrice * Double(item.quantity), specifier: "%.2f")")
                                    }
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Task {
                                        try? await Task.sleep(nanoseconds: 500_000_000)
                                        selectedItem = item
                                        isItemExpanded = true
                                    }
                                }
                            }
                            .onDelete(perform: viewModel.removeItem)
                            
                            HStack {
                                Spacer()
                                Text("Toplam: ₺\(viewModel.totalPrice, specifier: "%.2f")")
                                    .font(.headline)
                                    .padding()
                            }
                        }
                    }
                }
                .navigationTitle("Sepetim")
                .sheet(isPresented: $showingSearchResults) {
                    searchResultsView
                }
                
                if isItemExpanded, let item = selectedItem {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isItemExpanded = false
                        }
                    
                    VStack {
                        Image(uiImage: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                        
                        Text("Birim Fiyat: ₺\(item.unitPrice, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Adet: \(item.quantity)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        Text("Toplam Fiyat: ₺\(item.unitPrice * Double(item.quantity), specifier: "%.2f")")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                        
                        Button(action: {
                            isItemExpanded = false
                        }) {
                            Text("Kapat")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                                .padding()
                        }
                    }
                    .frame(width: 350)
                    .background(Color.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    .transition(.scale)
                }
            }
            .animation(.easeInOut, value: isItemExpanded)
        }
    }
    
    func searchProducts(with query: String) {
        DataManager.shared.searchProducts(with: query) { results in
            DispatchQueue.main.async {
                self.searchResults = results
            }
        }
    }
    
    private var searchResultsView: some View {
        VStack {
            Text("Arama Sonuçları")
                .font(.headline)
                .padding()
            
            List {
                ForEach(searchResults) { product in
                    HStack {
                        AsyncImage(url: URL(string: product.imageURL)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(product.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("₺\(product.markets.min(by: { $0.price < $1.price })?.price ?? 0, specifier: "%.2f")")
                            .font(.subheadline)
                        
                        Button(action: {
                            selectedProduct = product
                            showingAddItemView = true
                        }) {
                            Image(systemName: "plus")
                                .padding(5)
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
            }
            .listStyle(PlainListStyle())
        }
        .sheet(isPresented: $showingAddItemView) {
            addItemView
        }
    }
}

extension CartView {
    private var addItemView: some View {
        VStack {
            Text("Market ve Fiyat Bilgileri")
                .font(.headline)
                .padding()
            
            if let product = selectedProduct {
                List {
                    ForEach(product.markets) { market in
                        HStack {
                            Text(market.name)
                            Spacer()
                            Text("₺\(market.price, specifier: "%.2f")")
                                .foregroundColor(.green)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if selectedMarket == market {
                                        selectedMarket = nil
                                    } else {
                                        selectedMarket = market
                                    }
                                }
                            
                            if selectedMarket == market {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                }
                HStack {
                    Button(action: {
                        if selectedQuantity > 1 {
                            selectedQuantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                            .foregroundColor(selectedQuantity > 1 ? .blue : .gray)
                    }

                    Text("\(selectedQuantity)")
                        .font(.title)
                        .frame(minWidth: 50)

                    Button(action: {
                        selectedQuantity += 1
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                if let selectedMarket = selectedMarket {
                    Text("Toplam Fiyat: ₺\(selectedMarket.price * Double(selectedQuantity), specifier: "%.2f")")
                        .font(.headline)
                        .padding()
                }

                Button(action: {
                    guard let selectedMarket = selectedMarket else { return }
                    
                    let newItem = CartItem(
                        id: UUID(),
                        productName: product.name,
                        marketName: selectedMarket.name,
                        quantity: selectedQuantity,
                        unitPrice: selectedMarket.price,
                        image: imageCache[product.imageURL] ?? UIImage()
                    )
                    
                    viewModel.addItem(newItem)
                    showingAddItemView = false
                }) {
                    Text("Sepete Ekle") 
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button("Kapat") {
                    showingAddItemView = false
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
    }
}
