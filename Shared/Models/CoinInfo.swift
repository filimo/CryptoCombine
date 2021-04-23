//
//  CoinInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation


//fileprivate enum StringCoding: String, CodingKey {
//    case key = "price"
//}
//public protocol StringCodable: LosslessStringConvertible, Codable {}
//public extension StringCodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: StringCoding.self)
//        try container.encode("\(self)", forKey: .key)
//    }
//    init(from decoder: Decoder) throws {
//        let stringRep = try decoder.container(keyedBy: StringCoding.self).decode(String.self, forKey: .key)
//        self.init(stringRep)!
//    }
//}
//
//// Opt in.
//extension Float80: StringCodable {}

struct CoinInfo: Codable, Identifiable {
    var id: Int
    let name: String
    let symbol: String
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
}
