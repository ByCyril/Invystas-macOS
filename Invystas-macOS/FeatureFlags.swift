//
//  FeatureFlags.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Foundation


protocol FeatureFlagType {
    var trigger: Bool { get }
    func check() -> Any?
}

final class FeatureFlag {
    static var showDebuggingTextField: Bool = true
    static var mockSuccessLabel: Bool = false
}
