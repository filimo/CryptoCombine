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

    @Published private(set) var coinToBTCInfo = Output.failure(CustomError.empty)

    func refreshCoinsInfoToBTC() {
        let fileName = "CoinMarketCap-btc-latest"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            coinToBTCInfo = Output.failure(CustomError.fileNotFound(fileName))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$coinToBTCInfo)
    }
}
