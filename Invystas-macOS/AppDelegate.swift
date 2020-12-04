//
//  AppDelegate.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?
    var vc: ViewController?
    
    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else { return }
        guard let browserData = process(url) else { return }

        if window == nil {
            launchViewController()
        }
        
        vc?.beginInvystaProcess(with: browserData)
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if window == nil {
            launchViewController()
        }
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
        
        return BrowserData(action: data["action"]!, oneTimeCode: data["otc"], encData: data["encData"]!, magic: data["magic"]!)
    }

    func launchViewController(_ browserData: BrowserData? = nil) {
        
        let storyboardId = "ViewController"
        let storyboardName = "Main"
        let storyboard = NSStoryboard(name: storyboardName, bundle: Bundle.main)
        vc = storyboard.instantiateController(withIdentifier: storyboardId) as? ViewController
        
        let windowSize = NSSize(width: 480, height: 480)
        let screenSize = NSScreen.main?.frame.size ?? .zero
        let rect = NSMakeRect(screenSize.width/2 - windowSize.width/2,
                              screenSize.height/2 - windowSize.height/2,
                              windowSize.width,
                              windowSize.height)

        window = NSWindow(contentRect: rect,
                          styleMask: [.miniaturizable, .closable, .titled],
                          backing: .buffered,
                          defer: false)
        
        window?.acceptsMouseMovedEvents = true
        window?.title = "Invysta Aware"
        window?.contentViewController = vc
        
        window?.makeKeyAndOrderFront(nil)

    }
    
    var preferencesController: NSWindowController?
    
    @IBAction func showPreferences(_ sender: Any) {
        
        if let preferencesController = preferencesController {
            preferencesController.showWindow(sender)
        } else {
            let name = NSStoryboard.Name("Preferences")
            let storyboard = NSStoryboard(name: name, bundle: nil)
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
