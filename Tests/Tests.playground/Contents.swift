import UIKit
import SwiftUI

// AddProductViewModel mock data
class AddProductViewModelTest {
    var quantity = 1
    var unitPrice = "10.49"
    var inputImage: UIImage? = nil

    func addItem(to cartItems: inout [CartItem]) {

        let newItem = CartItem(quantity: quantity, unitPrice: Double(unitPrice) ?? 0.0)
        cartItems.append(newItem)
        print("Ürün eklendi: \(newItem)")
    }

    func increaseQuantity() {
        quantity += 1
        print("Adet miktarı arttı: \(quantity)")
    }

    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            print("Adet miktarı azaldı: \(quantity)")
        }
    }
}


struct CartItem {
    var quantity: Int
    var unitPrice: Double
}

func runAddProductViewModelTests() {
    var cartItems = [CartItem]()
    let viewModel = AddProductViewModelTest()

    viewModel.increaseQuantity()

    viewModel.decreaseQuantity()

    viewModel.addItem(to: &cartItems)
    print("Sepete eklenen: \(cartItems)")
}


class ScannerViewModelTest {
    var recognizedItems = [RecognizedItemTest]()

    func addBarcodeItem(_ barcode: String) {
        recognizedItems.append(.barcode(barcode))
        print("Barkod eklendi: \(barcode)")
    }

    func addTextItem(_ text: String) {
        recognizedItems.append(.text(text))
        print("Metin eklendi: \(text)")
    }

    func printRecognizedItems() {
        for item in recognizedItems {
            switch item {
            case .barcode(let barcode):
                print("Barkod taranıyor: \(barcode)")
            case .text(let text):
                print("Metin taranıyor: \(text)")
            }
        }
    }
}

enum RecognizedItemTest {
    case barcode(String)
    case text(String)
}

func runScannerViewModelTests() {
    let viewModel = ScannerViewModelTest()

    viewModel.addBarcodeItem("1234567890")

    viewModel.addTextItem("Test metni")

    viewModel.printRecognizedItems()
}


func runAllTests() {
    print("AddProductViewModel testleri yürütülüyor...")
    runAddProductViewModelTests()

    print("\nScannerViewModel testleri yürütülüyor...")
    runScannerViewModelTests()
}

runAllTests()

