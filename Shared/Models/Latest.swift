//
//  Coin.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import Foundation

struct Latest: Decodable {
    struct Status: Decodable {
        let total_count: Int
    }
    
    let status: Status
}
