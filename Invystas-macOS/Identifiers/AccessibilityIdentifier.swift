//
//  AccessibilityIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Cocoa
import InvystaCore

struct AccessibilityIdentifier: IdentifierSource {
    var type: String = "AccessibilityIdentifier"
    
    let fontAttributes: String = {
        let fontFamily = NSAccessibility.FontAttributeKey.fontFamily.rawValue
        let fontName = NSAccessibility.FontAttributeKey.fontName.rawValue
        let fontSize = NSAccessibility.FontAttributeKey.fontSize.rawValue
        let visibleName = NSAccessibility.FontAttributeKey.visibleName.rawValue
//        return fontFamily + fontName + fontSize + visibleName
        InvystaService.log(.alert, "AccessibilityIdentifier",fontFamily + fontName + fontSize + visibleName)
        return UUID().uuidString
    }()
    
    func identifier() -> String? {
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let encData = SHA256(data: fontAttributes.data(using: .utf8))
            UserDefaults.standard.setValue(encData, forKey: type)
            return encData
        }
    }
    
}
