//
//  DateFormatter.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import Foundation

extension DateFormatter {
    static let jsonDateFormater: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter
    }()
}
