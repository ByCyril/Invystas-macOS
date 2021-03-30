//
//  MacSerialNumberIdentifier.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Cocoa
import InvystaCore

struct MacSerialNumberIdentifier: IdentifierSource {
    var type: String = "SerialNumber"
    
    func identifier() -> String? {
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
        
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0);
        
        IOObjectRelease(platformExpert);

        return (serialNumberAsCFString?.takeUnretainedValue() as? String)
        
    }
}

