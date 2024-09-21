import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
    }
    
    func addItem(_ item: CartItem) {
        cartItems.append(item)
    }
    
    func removeItem(at indexSet: IndexSet) {
        cartItems.remove(atOffsets: indexSet)
    }
}
