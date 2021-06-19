//
//  CoinInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation

struct CoinInfo: Codable, Identifiable {
    var id: Int
    let name: String
    let symbol: String
    let slug: String
    var quote: [String: Quote]
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

    var quoteUSD: Quote {
        quote["USD"]!
    }

    var count: Double {
        Store.shared.extraCoinInfoList[id]?.count ?? 0
    }
    
    var totalBTC: Double {
        quoteBTC.price * count
    }

    var totalUSD: Double {
        priceUSD * count
    }
        
    var priceUSD: Double {
        return quote["USD"]?.price ?? 0
    }
}
