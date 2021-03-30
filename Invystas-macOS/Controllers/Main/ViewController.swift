//
//  ViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa
import InvystaCore

final class ViewController: BaseViewController {
            
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if IVUserDefaults.getBool(.isExistingUser) == false {
            beginRegistration()
        }
    }
 
    func beginRegistration() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Invysta"), bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "RegisterViewController") as! RegisterViewController
        presentAsSheet(vc)
    }
  
    func beginAuthentication(_ browserData: InvystaBrowserDataModel) {
       
        let authenticationObject = AuthenticationObject(uid: browserData.uid, nonce: browserData.nonce)
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Invysta"), bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        vc.beginAuthentication(authenticationObject)
        presentAsSheet(vc)
    }
 
    
    @IBAction func reregisterDevice(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Invysta"), bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "RegisterViewController") as! RegisterViewController
        presentAsSheet(vc)
    }
    
}
