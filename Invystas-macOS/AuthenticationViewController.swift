//
//  AuthenticationViewController.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/28/21.
//

import Cocoa
import Invysta_Framework
import LocalAuthentication

final class AuthenticationViewController: NSViewController {
    
    private var authenticate: Authenticate?
    
    @IBOutlet var indicatorLabel: NSTextField!
    @IBOutlet var activityIndicator: NSProgressIndicator!
    
    private var error: NSError?
    
    func beginAuthentication(_ authObject: AuthenticationObject) {
        
        print("")
        print("#################################")
        print("AuthObject")
        print("UID",authObject.uid)
        print("NONCE",authObject.nonce)
        print("CAID",authObject.caid)
        print("identifiers",authObject.identifiers)
        print("#################################")
        print("")
        
        authenticate = Authenticate(authObject, IVUserDefaults.getString(.providerKey)!)
        
        guard IVUserDefaults.getBool(.DeviceSecurity) else {
            delayAuthenticationProcess()
            return
        }
        
        if #available(OSX 10.15, *) {
            let laContext: LAContext = LAContext()
            
            if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, localizedReason: "Authenticate to begin the Invysta Authentication Process") { (success, error) in
                    
                    DispatchQueue.main.async { [weak self] in
                        if success {
                            self?.authenticationProcess()
                        } else {
                            self?.showAlert(error!.localizedDescription)
                        }
                    }
                }
            }
        } else {
            delayAuthenticationProcess()
        }
        
    }
    
    private func delayAuthenticationProcess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.authenticationProcess()
        }
    }
    
    private func authenticationProcess() {
        
        authenticate?.start { [weak self] results in
            switch results {
            case .success(_):
                self?.showAlert("Login Successful!")
                self?.dismissAuth()
            case .failure(let message, _):
                self?.showAlert(message)
                self?.dismissAuth()
            }
        }
    }
    
    private func showAlert(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.indicatorLabel.stringValue = message
            self?.activityIndicator.stopAnimation(self)
        }
    }
    
    private func dismissAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.dismiss(self)
        }
    }
    
}
