//
//  CoinInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation

struct CoinInfo: Codable, Identifiable {
    let id: Int
    let name: String
    let symbol: String
//    let quote: [String: String]
}
