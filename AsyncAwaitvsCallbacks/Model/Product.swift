//
//  Product.swift
//  AsyncAwaitvsCallbacks
//
//  Created by Fatih Durmaz on 23.07.2024.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title, category: String
    let price, rating: Double
    let thumbnail: String
}

struct ProductResponse: Codable {
    let products: [Product]
}
