import SwiftUI

class AddProductViewModel: ObservableObject {
    @Published var inputImage: UIImage?
    @Published var quantity: Int = 1
    @Published var unitPrice: String = ""
    
    func addItem(to cartItems: inout [CartItem]) {
        if let image = inputImage, let unitPriceValue = Double(unitPrice), !unitPrice.isEmpty {
            let newItem = CartItem(image: image, quantity: quantity, unitPrice: unitPriceValue)
            cartItems.append(newItem)
            print("Yeni ürün eklendi: \(newItem)")
        } else {
            print("Ürün eklenemedi: Fotoğraf ve geçerli bir birim fiyat girin.")
        }
    }

}
