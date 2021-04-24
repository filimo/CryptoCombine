//
//  NumberFormatter.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 24.04.21.
//

import Foundation

extension NumberFormatter {
    static let fraction2Format: NumberFormatter = {
        let numberFormatter = NumberFormatter()

        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        return numberFormatter
    }()

    static let fraction10Format: NumberFormatter = {
        let numberFormatter = NumberFormatter()

        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 10
        numberFormatter.maximumFractionDigits = 10

        return numberFormatter
    }()
}
