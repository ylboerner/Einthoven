//
//  UserDefaultsProvider.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation

class UserDefaultsProvider {
    private static let defaults = UserDefaults(suiteName: "com.ylb.Einthoven.userdefaults")!

    public static func setValueInUserDefaults(key: String, value: String) {
        self.defaults.set(value as String, forKey: key)
    }

    public static func getValueFromUserDefaults(key: String) -> String? {
        let value = defaults.string(forKey: key)
        return value
    }
}
