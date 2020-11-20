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
        
        launchViewController(browserData)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        launchViewController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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
        vc?.browserData = browserData
        
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
        window?.title = "InvystaSafe"
        window?.contentViewController = vc
        window?.makeKeyAndOrderFront(nil)

    }
    
}
