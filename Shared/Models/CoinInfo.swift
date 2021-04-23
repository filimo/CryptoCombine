//
//  CoinInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation

struct CoinInfo: Codable, Identifiable {
    var isFavorite: Bool? = false

    let id: Int
    let name: String
    let symbol: String
    let quote: [String: Quote]
}

extension CoinInfo {
    struct Quote: Codable {
        let price: Double
        let volume_24h: Double
        let percent_change_1h: Double
        let percent_change_24h: Double
        let percent_change_7d: Double
        let percent_change_30d: Double
        let percent_change_60d: Double
        let percent_change_90d: Double
        let market_cap: Double
    }
}

extension CoinInfo {
    var quoteBTC: Quote {
        quote["BTC"]!
    }
    
    static func toggleFavorite(coin: CoinInfo) {
        if let index = Store.shared.coinToBTCInfo?.data.firstIndex(where: { $0.id == coin.id }) {
            Store.shared.coinToBTCInfo?.data[index].isFavorite = !(Store.shared.coinToBTCInfo?.data[index].isFavorite ?? false)
        }
    }
}
