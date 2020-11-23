//
//  FeatureFlag+BrowserData.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/20/20.
//

import Foundation

final class FeatureFlagBrowserData: FeatureFlagType {
    
    var trigger: Bool = false
    
    func hookbin() -> String? {
        return trigger ? "https://hookb.in/YVmNrzzaYjSo77ym3QNd" : nil
    }
    
    func check() -> Any? {
        if trigger {
            return BrowserData(action: "reg",
                               encData: "encData",
                               magic: "magicVal")
        }
        return nil
    }
}
