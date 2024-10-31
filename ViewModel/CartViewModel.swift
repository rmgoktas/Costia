import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var searchResults: [Product] = []
    
    func addItem(_ item: CartItem) {
        cartItems.append(item)
        print("Sepete yeni ürün eklendi: \(item)")
    }
    
    func removeItem(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
    }
    
    func searchProducts(with query: String) {
        DataManager.shared.searchProducts(with: query) { results in
            DispatchQueue.main.async {
                self.searchResults = results
            }
        }
    }
}

