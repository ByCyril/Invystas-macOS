//
//  BaseViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/21/20.
//

import Cocoa
import Invysta_Framework
import LocalAuthentication

class BaseViewController: NSViewController {
    
    @IBOutlet var customView1: NSView!
    @IBOutlet var customView2: NSView!
    @IBOutlet var customView3: NSView!

    @IBOutlet weak var deviceSecurityToggle: NSButton!
    @IBOutlet weak var versionLabel: NSTextField!

    private var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        
        title = "Invysta Aware"
        view.wantsLayer = true
        
        if #available(OSX 10.15, *) {

            let laContext: LAContext = LAContext()
            if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                customView3.isHidden = false
            } else {
                customView3.isHidden = true
            }
            
            InvystaService.log(.error, "Error Local Authentication", error?.localizedDescription)

        } else {
            customView3.isHidden = true
        }
        
        let isEnabled = IVUserDefaults.getBool(.DeviceSecurity)
        deviceSecurityToggle.state = (isEnabled) ? .on : .off
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.stringValue = appVersion ?? "NA"
        
        [customView1, customView2, customView3].forEach { (element) in
            element?.wantsLayer = true
            let backgroundColor = NSColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1).cgColor
            element?.layer?.backgroundColor = backgroundColor
            element?.layer?.cornerRadius = 5
        }
        
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        guard NSWorkspace.shared.open(URL(string: "https://invysta.com/privacy-policy/")!) else { return }
    }
    
    @IBAction func toggleDeviceSecurity(_ sender: NSButton) {
        IVUserDefaults.set(sender.state == .on, .DeviceSecurity)
    }
    
}
