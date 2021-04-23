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
    
    typealias Output = Result<CoinsToBtcInfo, Error>

    @Published private(set) var coinToBTCInfoPublisher = Output.failure(CustomError.empty) 
    
    
    @Published var coinNameFilter = ""
    
    @Published(key: "coinToBTCInfo") var coinToBTCInfo: CoinsToBtcInfo? = nil
    @Published(key: "onlyFavoritedCoins") var onlyFavoritedCoins = false
    @Published(key: "CMC_PRO_API_KEY") var CMC_PRO_API_KEY = ""
    

    func refreshCoinsInfoToBTC() {
        let urlString = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
        
        var components = URLComponents(string: urlString)!

        components.queryItems = [
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "limit", value: "5000"),
            URLQueryItem(name: "convert", value: "BTC")
        ]
        
        var request = URLRequest(url: components.url!)
        
        request.setValue(CMC_PRO_API_KEY, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

//        guard let url = URL(string: urlString) else {
//            coinToBTCInfoPublisher = Output.failure(CustomError.fileNotFound(urlString))
//            return
//        }

        URLSession.shared.dataTaskPublisher(for: request)
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$coinToBTCInfoPublisher)
    }
}
