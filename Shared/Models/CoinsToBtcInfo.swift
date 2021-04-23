//
//  CoinsToBtcInfo.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import Foundation

struct CoinsToBtcInfo: Decodable {
    let status: Status
}

extension CoinsToBtcInfo {
    struct Status: Decodable {
        let total_count: Int
        let error_code: Int
        let error_message: String?
    }
}
