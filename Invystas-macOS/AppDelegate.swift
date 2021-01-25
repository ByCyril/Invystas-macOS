//
//  AppDelegate.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var invystaController: NSWindowController?
    var preferencesController: NSWindowController?
    
    var window: NSWindow?
    var vc: ViewController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if vc == nil {
            launchViewController()
        }
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        
        guard let url = urls.first else { return }
        guard let browserData = process(url) else { return }
        
        if vc == nil {
            launchViewController()
        }
        vc?.beginInvystaProcess(with: browserData)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func process(_ url: URL) -> BrowserData? {
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return nil }
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        return BrowserData(action: data["action"]!,
                           oneTimeCode: data["otc"],
                           encData: data["encData"]!,
                           magic: data["magic"]!)
    }
    
    func launchViewController() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Invysta"), bundle: nil)
        invystaController = storyboard.instantiateController(withIdentifier: "InvystaWindow") as? NSWindowController
        
        vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController
        
        invystaController?.contentViewController = vc
        invystaController?.showWindow(self)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        if let preferencesController = preferencesController {
            preferencesController.showWindow(sender)
        } else {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Preferences"), bundle: nil)
            preferencesController = storyboard.instantiateInitialController() as? NSWindowController
            preferencesController?.showWindow(sender)
        }
    }
    
    @IBAction func showHelpPage(_ sender: Any) {
        let url = URL(string: "https://invysta.com/support/")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
}
