//
//  Market.swift
//  Costia
//
//  Created by R. Metehan GÖKTAŞ on 30.10.2024.
//
import SwiftUI

struct Market: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let price: Double
}
