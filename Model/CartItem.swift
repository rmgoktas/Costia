import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let name: String
    let quantity: Int
    let unitPrice: Double
}

