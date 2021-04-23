//
//  CustomError.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import Foundation

enum CustomError: Equatable {
    case empty
    case fileNotFound(_ name: String)
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return ""
        case .fileNotFound(let name):
            return "File \(name) not found"
        }
    }
}
