//
//  AuthenticationViewController.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/28/21.
//

import Cocoa
import InvystaCore
import LocalAuthentication

final class AuthenticationViewController: NSViewController, LocalAuthenticationManagerDelegate {
    
    func localAuthenticationDidFail(_ error: Error?) {
        showAlert(error?.localizedDescription ?? "Failed to Authenticate")
        showCancelButton()
    }
    
    private var process: InvystaProcess<AuthenticationModel>?
    
    @IBOutlet weak var indicatorLabel: NSTextField!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet weak var cancelButton: NSButton!
    
    private let localAuth: LocalAuthenticationManager = LocalAuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localAuth.delegate = self
        activityIndicator.startAnimation(self)
        cancelButton.isHidden = true
    }
    
    func beginAuthentication(_ authObject: AuthenticationModel) {
        
        print("")
        print("#################################")
        print("AuthObject")
        print("UID",authObject.uid)
        print("NONCE",authObject.nonce)
        print("CAID",authObject.caid)
        print("identifiers",authObject.identifiers)
        print("#################################")
        print("")
        
        process = InvystaProcess(authObject, IVUserDefaults.getString(.providerKey)!)
        
        localAuth.delegate = self
        localAuth.beginLocalAuthentication(authenticationProcess)
        
    }
    
    private func showCancelButton() {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = false
        }
    }
    
    private func authenticationProcess() {
        
        process?.start { [weak self] results in
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
