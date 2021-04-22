//
//  Store.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Foundation
import Combine

class Store: ObservableObject {
    enum EmptyError: Error {
        case empty
    }
    
    typealias Output = Result<CoinsToBtcInfo, Error>

    @Published var coinToBTCInfo = Output.failure(EmptyError.empty)

    func refreshCoinsInfoToBTC() {
        if let url = Bundle.main.url(forResource: "CoinMarketCap-btc-latest", withExtension: "json") {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: CoinsToBtcInfo.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$coinToBTCInfo)
        }
    }
}
