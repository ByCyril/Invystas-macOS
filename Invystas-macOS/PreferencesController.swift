//
//  PreferencesController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 12/4/20.
//

import Cocoa

final class PreferencesController: NSViewController {
    
    @IBOutlet weak var deviceSecurityToggle: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isEnabled = UserDefaults.standard.bool(forKey: "DeviceSecurity")
        deviceSecurityToggle.state = (isEnabled) ? .on : .off
        
    }
    
    @IBAction func openPrivacyPolicy(_ sender: NSButton) {
        let url = URL(string: "https://invysta.com/privacy-policy/")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func toggleDeviceSecurity(_ sender: NSButton) {
        let isEnabled = sender.state == .on
        UserDefaults.standard.setValue(isEnabled, forKey: "DeviceSecurity")
    }
    
}
