//
//  RegisterViewController.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/28/21.
//

import Cocoa
import InvystaCore

class RegisterViewController: NSViewController, NSAlertDelegate, LocalAuthenticationManagerDelegate {

    @IBOutlet var emailField: NSTextField!
    @IBOutlet var passwordField: NSSecureTextField!
    @IBOutlet var providerField: NSTextField!
    @IBOutlet var otcField: NSTextField!
    
    @IBOutlet var registerButton: NSButton!
    @IBOutlet var cancelButton: NSButton!
    
    private var process: InvystaProcess<RegistrationModel>?
    
    private let localAuth: LocalAuthenticationManager = LocalAuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localAuth.delegate = self
        cancelButton.isHidden = IVUserDefaults.getBool(.isExistingUser) == false
    }
    
    @IBAction func cancelButton(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func registerDevice(_ sender: NSButton) {
        localAuth.beginLocalAuthentication(beginRegistration)
    }
    
    func localAuthenticationDidFail(_ error: Error?) {
        showAlert("Authentication Failed", error?.localizedDescription ?? "No Error Description Available")
    }
    
    func beginRegistration() {
        guard !emailField.stringValue.isEmpty,
              !passwordField.stringValue.isEmpty,
              !otcField.stringValue.isEmpty,
              !providerField.stringValue.isEmpty
        else {
            showAlert("Error", "One or more fields are left blank")
            return
        }
        
        LocalIdentifierManager.resetIdentifiers()
        
        let registrationObject = RegistrationModel(email: emailField.stringValue,
                                                    password: passwordField.stringValue,
                                                    otc: otcField.stringValue)
        
        print("")
        print("#################################")
        print("Registration")
        print("CAID",registrationObject.caid)
        print("identifiers",registrationObject.identifiers)
        print("#################################")
        print("")
        
        IVUserDefaults.set(providerField.stringValue, .providerKey)
        
        process = InvystaProcess(registrationObject, providerField.stringValue)
        
        process?.start { [weak self] results in
            switch results {
            case .success(let statusCode):
                IVUserDefaults.set(true, .isExistingUser)
                self?.saveActivity(message: "Registered Device", statusCode: statusCode)
                self?.showAlert("Done!", "Device is now Invysta Aware!", true)
            case .failure(let message, let statusCode):
                self?.saveActivity(message: message, statusCode: statusCode)
                self?.showAlert("Error", message)
            }
        }
    }
    
    private func showAlert(_ title: String,_ message: String,_ closeToDismiss: Bool = false) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.delegate = self

            
            alert.beginSheetModal(for: self.view.window!) { [weak self] response in
                if closeToDismiss {
                    if response == .cancel {
                        self?.dismiss(self)
                    }
                }
            }
        }
    }
    
    private let coreDataManager: PersistenceManager = PersistenceManager.shared
    
    func saveActivity(message: String, statusCode: Int) {
        let activityManager = ActivityManager(coreDataManager)
        let activity = Activity(context: coreDataManager.context)
        activity.date = Date()
        activity.message = message
        activity.statusCode = Int16(statusCode)
        activityManager.saveResults(activity: activity)
        NotificationCenter.default.post(name: Notification.Name("ReloadTable"), object: nil)
    }
 
}
