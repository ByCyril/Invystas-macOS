//
//  IOPlatformExpertDeviceIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/6/20.
//

import Cocoa

struct IOPlatformExpertDeviceIdentifier: IdentifierSource {
    var type: String = "IOPlatformExpertDevice"
    
    func identifier() -> String? {
        let matchingDict = IOServiceMatching(type)
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, matchingDict)
        
        defer {
            IOObjectRelease(platformExpert)
        }
        
        guard platformExpert != 0 else { return nil }
        
        return IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String
    }
}

