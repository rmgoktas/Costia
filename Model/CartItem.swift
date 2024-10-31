import SwiftUI

struct CartItem: Identifiable {
    var id: UUID = UUID()
    var productName: String
    var marketName: String
    var quantity: Int
    var unitPrice: Double
    var image: UIImage
}


