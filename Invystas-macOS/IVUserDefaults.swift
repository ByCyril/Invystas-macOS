//
//  IVUserDefaults.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/28/21.
//

import Foundation
import InvystaCore

enum UserDefaultKey: String, CaseIterable {
    case isExistingUser = "existingUser"
    case DeviceSecurity = "DeviceSecurity"
    case providerKey = "Provider"
    case authenticationProvider = "AuthProvider"
    case registrationProvider = "RegProvider"
}

final class IVUserDefaults {
    static func set(_ val: Any,_ key: UserDefaultKey) {
        UserDefaults.standard.setValue(val, forKey: key.rawValue)
    }
    
    static func getString(_ key: UserDefaultKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getBool(_ key: UserDefaultKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func resetDefaults() {
        UserDefaultKey.allCases.forEach { (key) in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        
        LocalIdentifierManager.clearIdentifiers()
    }
}
