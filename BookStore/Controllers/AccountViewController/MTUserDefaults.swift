//
//  MTUserDefaults.swift
//  BookStore
//
//  Created by Anton Godunov on 14.12.2023.
//

import Foundation

struct MTUserDefaults {
    static var shared = MTUserDefaults()
    var theme : Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
