//
//  Mock.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//
import Foundation

extension Coins {
    static var btcMock: Data = {
        let url = Bundle.main.url(forResource: "btc", withExtension: "json")
        
        return try! Data(contentsOf: url!)
    }()

    static var usdMock: Data = {
        let url = Bundle.main.url(forResource: "usd", withExtension: "json")
        
        return try! Data(contentsOf: url!)
    }()
}
