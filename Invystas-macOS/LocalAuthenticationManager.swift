//
//  LocalAuthenticationManager.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 5/25/21.
//

import Foundation
import LocalAuthentication

protocol LocalAuthenticationManagerDelegate: AnyObject {
    func localAuthenticationDidFail(_ error: Error?)
}

final class LocalAuthenticationManager {
    
    weak var delegate: LocalAuthenticationManagerDelegate?
    
    private var error: NSError?
    private let laContext: LAContext = LAContext()
    
    private var queue: DispatchQueue
    
    init(_ queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }
    
    func beginLocalAuthentication(_ process: @escaping () -> Void) {
        
        guard IVUserDefaults.getBool(.DeviceSecurity) else {
            process()
            return
        }
        
        if #available(OSX 10.15, *) {
            if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                beginProcessWithDeviceSecurity(.deviceOwnerAuthenticationWithBiometricsOrWatch, process)
            } else {
                beginProcessWithDeviceSecurity(.deviceOwnerAuthentication, process)
            }
        } else {
            beginProcessWithDeviceSecurity(.deviceOwnerAuthentication, process)
        }
    }
    
    func beginProcessWithDeviceSecurity(_ policy: LAPolicy,_ process: @escaping () -> Void) {
        laContext.evaluatePolicy(policy, localizedReason: "Authenticate to begin the Invysta Process") {  [weak self] (success, error) in
            
            self?.queue.async {
                if success {
                    process()
                } else {
                    self?.delegate?.localAuthenticationDidFail(error)
                }
            }
            
        }
    }
    
}
