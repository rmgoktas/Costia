import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @State private var showingAddItemView = false
    @State private var selectedItem: CartItem? = nil
    @State private var isItemExpanded = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
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
                                        Text("Adet: \(item.quantity)")
                                        Text("Toplam Fiyat: ₺\(item.unitPrice * Double(item.quantity), specifier: "%.2f")")
                                    }
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedItem = item
                                    isItemExpanded = true
                                }
                            }
                            .onDelete(perform: viewModel.removeItem)
                        }
                        
                        HStack {
                            Spacer()
                            Text("Toplam: ₺\(viewModel.totalPrice, specifier: "%.2f")")
                                .font(.headline)
                                .padding()
                        }

                    }

                    Button("Ürün Ekle") {
                        showingAddItemView = true
                    }
                    .padding()
                    .fullScreenCover(isPresented: $showingAddItemView) {
                        
                    }
                }
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                })
                .navigationTitle("Sepetim")
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

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
