//
//  Mock.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//
import Foundation

class Mock {
    static var results: Data {
        return """
        {
           "status":{
              "timestamp":"2021-04-22T06:54:55.562Z",
              "error_code":0,
              "error_message":null,
              "elapsed":17,
              "credit_count":1,
              "notice":null,
              "total_count":4804
           }
        }
        """.data(using: .utf8)!
    }
}
