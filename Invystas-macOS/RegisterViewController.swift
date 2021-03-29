//
//  RegisterViewController.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/28/21.
//

import Cocoa
import Invysta_Framework

class RegisterViewController: NSViewController, NSAlertDelegate {

    @IBOutlet var emailField: NSTextField!
    @IBOutlet var passwordField: NSSecureTextField!
    @IBOutlet var providerField: NSTextField!
    @IBOutlet var otcField: NSTextField!
    
    @IBOutlet var registerButton: NSButton!
    @IBOutlet var cancelButton: NSButton!
    
    private var register: Registration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.isHidden = IVUserDefaults.getBool(.isExistingUser) == false
    }
    
    @IBAction func cancelButton(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func registerDevice(_ sender: NSButton) {
        
        guard !emailField.stringValue.isEmpty,
              !passwordField.stringValue.isEmpty,
              !otcField.stringValue.isEmpty,
              !providerField.stringValue.isEmpty
        else {
            showAlert("Error", "One or more fields are left blank")
            return
        }
        
        let registrationObject = RegistrationObject(email: emailField.stringValue,
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
        
        register = Registration(registrationObject, providerField.stringValue)
        
        register?.start { [weak self] results in
            switch results {
            case .success(_):
                IVUserDefaults.set(true, .isExistingUser)
                self?.showAlert("Done!", "Device is now Invysta Aware!")
            case .failure(let message, _):
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
                if response == .cancel {
                    self?.dismiss(self)
                }
            }
        }
    }
 
}
