//
//  Product.swift
//  Costia
//
//  Created by R. Metehan GÖKTAŞ on 30.10.2024.
//
import SwiftUI

struct Product: Identifiable, Codable {
    let id = UUID()
    let barcode: String
    let name: String
    let imageURL: String
    let markets: [Market]
}
