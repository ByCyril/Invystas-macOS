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
    
    @IBOutlet weak var indicatorLabel: NSTextField!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet weak var cancelButton: NSButton!
    
    private var error: NSError?
    let laContext: LAContext = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimation(self)
        cancelButton.isHidden = true
    }
    
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
            if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                authenticateWithDeviceSecurity(.deviceOwnerAuthenticationWithBiometricsOrWatch)
            } else {
                authenticateWithDeviceSecurity(.deviceOwnerAuthentication)
            }
        } else {
            authenticateWithDeviceSecurity(.deviceOwnerAuthentication)
        }
        
    }
    
    private func authenticateWithDeviceSecurity(_ policy: LAPolicy) {
        laContext.evaluatePolicy(policy, localizedReason: "Authenticate to begin the Invysta Process") {  [weak self] (success, error) in
            if success {
                self?.authenticationProcess()
            } else {
                self?.showAlert(error?.localizedDescription ?? "Failed to Authenticate")
                self?.showCancelButton()
            }
        }
    }
    
    private func delayAuthenticationProcess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.authenticationProcess()
        }
    }
    
    private func showCancelButton() {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = false
        }
    }
    
    private func authenticationProcess() {
        
        authenticate?.start { [weak self] results in
            switch results {
            case .success(let statusCode):
                self?.showAlert("Login Successful!")
                self?.saveActivity(message: "Login Successful", statusCode: statusCode)
                self?.dismissAuth()
            case .failure(let message, let statusCode):
                self?.showAlert(message)
                self?.saveActivity(message: message, statusCode: statusCode)
                DispatchQueue.main.async {
                    self?.cancelButton.isHidden = false
                }
            }
        }
    }
    
    @IBAction func cancelView(_ sender: NSButton) {
        dismiss(self)
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
    
    private let coreDataManager: PersistenceManager = PersistenceManager.shared
    
    private func saveActivity(message: String, statusCode: Int) {
        let activityManager = ActivityManager(coreDataManager)
        let activity = Activity(context: coreDataManager.context)
        activity.date = Date()
        activity.message = message
        activity.statusCode = Int16(statusCode)
        activityManager.saveResults(activity: activity)
        NotificationCenter.default.post(name: Notification.Name("ReloadTable"), object: nil)
    }
    
}
