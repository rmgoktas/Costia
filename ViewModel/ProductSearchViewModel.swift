//
//  ProductSearchViewModel.swift
//  Costia
//
//  Created by R. Metehan GÖKTAŞ on 30.10.2024.
//

import SwiftUI

class ProductSearchViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = true
    @Published var loadError = false
    @Published var cheapestPrice: Double?
    @Published var cheapestMarket: String?
    
    init(searchText: String) {
        fetchProducts(searchText: searchText)
    }

    func fetchProducts(searchText: String) {
        DataManager.shared.fetchProducts(withBarcode: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.findCheapestProduct()
                case .failure:
                    self?.loadError = true
                }
            }
        }
    }
    
    private func findCheapestProduct() {
        for product in products {
            if let minPriceMarket = product.markets.min(by: { $0.price < $1.price }) {
                cheapestPrice = minPriceMarket.price
                cheapestMarket = minPriceMarket.name
            }
        }
    }
}

