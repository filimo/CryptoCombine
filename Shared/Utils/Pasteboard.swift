//
//  Pasteboard.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//
#if os(macOS)
import AppKit

class Pasteboard {
    static var string: String {
        NSPasteboard.general.string(forType: .string) ?? ""
    }
}
#else
import UIKit

class Pasteboard {
    static var string: String {
        UIPasteboard.general.string ?? ""
    }
}
#endif


