import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let quantity: Int
    let unitPrice: Double
}

