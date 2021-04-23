//
//  Store.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import Foundation

class Store: ObservableObject {
    typealias Output = Result<CoinsToBtcInfo, Error>

    @Published private(set) var coinToBTCInfoPublisher = Output.failure(CustomError.empty)
    @Published(key: "coinToBTCInfo") var coinToBTCInfo: CoinsToBtcInfo? = nil
    @Published(key: "onlyFavoritedCoins") var onlyFavoritedCoins = false

    func refreshCoinsInfoToBTC() {
        let fileName = "CoinMarketCap-btc-latest"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            coinToBTCInfoPublisher = Output.failure(CustomError.fileNotFound(fileName))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$coinToBTCInfoPublisher)
    }
}
