//
//  FirstTimeInstallationIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Cocoa
import InvystaCore

struct FirstTimeInstallationIdentifier: IdentifierSource {
    var type: String = "FirstTimeInstallation"
    
    func identifier() -> String? {
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let currentTimestamp = String(Date().timeIntervalSinceNow)
            let encData = SHA256(data: currentTimestamp.data(using: .utf8))
            UserDefaults.standard.setValue(encData, forKey: type)
            return encData
        }
    }
    
}

