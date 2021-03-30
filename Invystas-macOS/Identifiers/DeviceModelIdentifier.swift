//
//  DeviceModelIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import IOKit
import Cocoa
import InvystaCore

struct DeviceModelIdentifier: IdentifierSource {
    var type: String = "DeviceModel"
    
    func identifier() -> String? {
        if let model = getModelIdentifier() {
            return SHA256(data: model.data(using: .utf8))
        } else {
            return SHA256(data: type.data(using: .utf8))
        }
    }
    
    func getModelIdentifier() -> String? {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                  IOServiceMatching("IOPlatformExpertDevice"))
        var modelIdentifier: String?
        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
            modelIdentifier = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters)
        }

        IOObjectRelease(service)
        return modelIdentifier
    }
}
