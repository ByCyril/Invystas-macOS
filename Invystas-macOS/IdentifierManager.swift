//
//  IdentifierManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Cocoa
import CommonCrypto

protocol IdentifierSource {
    var type: String { get set }
    func identifier() -> String?
}

class Identifier {
    func SHA256(data: Data?) -> String {
        guard let data = data else { return "SHA-err" }
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        
        return Data(hash).map { String(format: "%02hhx", $0) }.joined()
    }
}

final class IdentifierManager: Identifier {
    
    private var sources: [IdentifierSource]
    private var browserData: BrowserData
    
    private(set) var compiledSources: String?
    
    init(_ browserData: BrowserData) {
        
        self.browserData = browserData
        
        sources = []
        super.init()
        compiledSources = compileSources()
    }
  
    private func compileSources() -> String {
        var param: String
        param = "caid=" + createClientAgentId()
        param += "&magic=" + browserData.magic ?? ""
        
        if let otc = browserData.oneTimeCode {
            param += "&otc=" + otc
        }
        
        for (i,source) in sources.enumerated() where source.identifier() != nil {
            param += "&id\(i + 1)=" + source.identifier()!
        }

        return param
    }
    
    private func createClientAgentId() -> String {
        var caid = ""
        
        if let firstIdentifier = sources.first?.identifier() {
            caid += firstIdentifier
        }
        
        if let lastIdentifier = sources.last?.identifier() {
            caid += lastIdentifier
        }
                
        return SHA256(data: caid.data(using: .ascii))
    }
 
}
