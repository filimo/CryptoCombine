//
//  Application.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 24.04.21.
//

import Foundation

#if os(iOS)
import UIKit

class Application {
    static func openBrowser(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
#endif

#if os(macOS)
import AppKit

class Application {
    static func openBrowser(url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
}
#endif
