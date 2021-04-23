//
//  ExtraCoinInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation

struct ExtraCoinInfo: Codable {
    var isFavorite: Bool = false
    var count: Double = 0
}

typealias ExtraCoinInfoList = [Int: ExtraCoinInfo]

extension ExtraCoinInfoList {
    static func initIfNeeded(coin: CoinInfo) {
        if Store.shared.extraCoinInfoList[coin.id] == nil {
            Store.shared.extraCoinInfoList[coin.id] = .init()
        }
    }
    
    static func toggleFavorite(coin: CoinInfo) {
        initIfNeeded(coin: coin)
        Store.shared.extraCoinInfoList[coin.id]?.isFavorite = !(Store.shared.extraCoinInfoList[coin.id]?.isFavorite ?? false)
    }

    static func setCount(coin: CoinInfo, count: Double) {
        initIfNeeded(coin: coin)
        Store.shared.extraCoinInfoList[coin.id]?.count = count
    }
}
