//
//  AppDelegate.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa
import Invysta_Framework

struct Mock: IdentifierSource {
    var type: String
    
    init(_ type: String) {
        self.type = type
    }
    
    func identifier() -> String? {
        return type
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var invystaController: NSWindowController?
    
    var window: NSWindow?
    var vc: ViewController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
//        IVUserDefaults.resetDefaults()
        
        if vc == nil {
            launchViewController()
        }
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        
        guard let url = urls.first else { return }
        
        print("Passed URL",url.absoluteString)
        
        guard let browserData = process(url) else { return }
        
        if vc == nil {
            launchViewController()
        }
        
        vc?.beginAuthentication(browserData)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func process(_ url: URL) -> InvystaBrowserDataModel? {
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return nil }
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        return InvystaBrowserDataModel(action: data["action"]!,
                                       uid: data["uid"]!,
                                       nonce: data["nonce"]!)
    }
    
    func launchViewController() {
        
        IdentifierManager.configure([
            AccessibilityIdentifier(),
            CustomIdentifier(),
            DeviceModelIdentifier(),
            FirstTimeInstallationIdentifier(),
            HostIdentifier(),
            IOPlatformExpertDeviceIdentifier(),
            MacSerialNumberIdentifier()
        ])
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Invysta"), bundle: nil)
        invystaController = storyboard.instantiateController(withIdentifier: "InvystaWindow") as? NSWindowController
        
        vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController
        
        invystaController?.window?.styleMask.remove(.resizable)
        invystaController?.contentViewController = vc
        invystaController?.showWindow(self)
    }

}
