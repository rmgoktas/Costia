import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    
    func addItem(_ item: CartItem) {
        cartItems.append(item)
    }
    
    func removeItem(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
    }
}
