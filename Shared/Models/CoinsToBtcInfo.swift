//
//  CoinsToBtcInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//

struct CoinsToBtcInfo: Codable {
    let status: Status
    var data: [CoinInfo] = []
}

extension CoinsToBtcInfo {
    struct Status: Codable {
        let total_count: Int
        let error_code: Int
        let error_message: String?
    }
}

extension CoinsToBtcInfo {
    mutating func sortedByName() {
        data = data.sorted { a, b in
            a.name < b.name
        }
    }
}

typealias CoinsToBtcInfoResult = Result<CoinsToBtcInfo, Error>
