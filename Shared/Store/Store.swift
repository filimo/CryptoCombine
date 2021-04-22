//
//  Store.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Foundation
import Combine

class Store: ObservableObject {
    typealias Output = Result<Latest, Error>

    @Published var latest = Output.success(Latest(status: Latest.Status(total_count: 0)))

    func refreshCoinsInfoToBTC() {
        if let url = Bundle.main.url(forResource: "CoinMarketCap-latest", withExtension: "json") {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Latest.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$latest)
        }
    }
}
