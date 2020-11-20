//
//  CustomIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Foundation

struct CustomIdentifier: IdentifierSource {
    
    var type: String = "CustomID"
    
    func identifier() -> String? {
        if let uuid = UserDefaults.standard.string(forKey: type) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.setValue(uuid, forKey: type)
            return uuid
        }
    }
}
