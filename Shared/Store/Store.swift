//
//  Store.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import Foundation

class Store: ObservableObject {
    private init() {}
    static let shared = Store()

    typealias Output = Result<CoinsInfo, Error>

    @Published private(set) var coinToBTCInfoPublisher = Output.failure(CustomError.empty)
    @Published private(set) var coinToUSDInfoPublisher = Output.failure(CustomError.empty)

    @Published var coinNameFilter = ""

    @Published var coinsInfo: CoinsInfo? = nil
    
    @Published(key: "extraCoinInfoList") var extraCoinInfoList: ExtraCoinInfoList = [:]

    @Published(key: "onlyFavoritedCoins") var onlyFavoritedCoins = false
    @Published(key: "CMC_PRO_API_KEY") var CMC_PRO_API_KEY = ""

    func refreshCoinsInfo(convert: String) {
        let urlString = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"

        var components = URLComponents(string: urlString)!

        components.queryItems = [
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "limit", value: "5000"),
            URLQueryItem(name: "convert", value: convert)
        ]

        var request = URLRequest(url: components.url!)

        request.setValue(CMC_PRO_API_KEY, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

//        guard let url = URL(string: urlString) else {
//            coinToBTCInfoPublisher = Output.failure(CustomError.fileNotFound(urlString))
//            return
//        }

        switch convert {
        case "USD":
            URLSession.shared.dataTaskPublisher(for: request)
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$coinToUSDInfoPublisher)
        default:
            URLSession.shared.dataTaskPublisher(for: request)
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$coinToBTCInfoPublisher)
        }
    }
}
