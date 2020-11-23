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
    var browserData: BrowserData?
    
    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else { return }
        guard let browserData = process(url) else { return }
        self.browserData = browserData
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        launchViewController(browserData)
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
    
    func launchViewController(_ browserData: BrowserData?) {
        let storyboardId = "ViewController"
        let storyboardName = "Main"
        let storyboard = NSStoryboard(name: storyboardName, bundle: Bundle.main)
        vc = storyboard.instantiateController(withIdentifier: storyboardId) as? ViewController
        
        if let mockBrowserData = FeatureFlagBrowserData().check() as? BrowserData {
            vc?.browserData = mockBrowserData
        } else {
            vc?.browserData = browserData
        }
        
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
        
        window?.title = "InvystaSafe"
        window?.contentViewController = vc
        
        window?.makeKeyAndOrderFront(nil)

    }
    
}
