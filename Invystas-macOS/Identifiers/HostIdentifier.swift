//
//  HostIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Cocoa
import Invysta_Framework

struct HostIdentifier: IdentifierSource {
    var type: String = "HostIdentifier"
    
    let hostName: String = {
        return Host.current().localizedName ?? "HostName"
    }()
    
    let hostAddresses: String = {
        return Host.current().addresses.joined()
    }()
    
    let hostNames: String = {
        return Host.current().names.joined()
    }()
    
    func identifier() -> String? {
        
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let val = hostName + hostAddresses + hostNames
            let encData = SHA256(data: val.data(using: .utf8))
            UserDefaults.standard.setValue(encData, forKey: type)
            return encData
        }
        
    }
    
    
}
