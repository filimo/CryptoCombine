//
//  CoinsToBtcInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//

struct CoinsInfo: Codable {
    let status: Status
    var data: [CoinInfo] = []
}

extension CoinsInfo {
    struct Status: Codable {
        let total_count: Int
        let error_code: Int
        let error_message: String?
    }
}

extension CoinsInfo {
    mutating func sortedByName() {
        data = data.sorted { a, b in
            a.name < b.name
        }
    }
}

typealias CoinsToBtcInfoResult = Result<CoinsInfo, Error>
