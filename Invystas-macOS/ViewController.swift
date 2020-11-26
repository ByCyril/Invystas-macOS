//
//  ViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa
import LocalAuthentication

final class ViewController: BaseViewController {
        
    var identifierManager: IdentifierManager?
    var networkManager: NetworkManager?
    var browserData: BrowserData?
    
    let context = LAContext()
    var error: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        if let browserData = browserData {
            beginInvystaProcess(with: browserData)
        }
    }
    
    //    MARK: Begin Invysta Process
    func beginInvystaProcess(with browserData: BrowserData) {
        print("Begin Invysta Process")
        #warning("Add local authentication")
        networkManager = NetworkManager()
        identifierManager = IdentifierManager(browserData)    
        requestXACID(browserData)
    }
    
    //    MARK: Request XACID
    private func requestXACID(_ browserData: BrowserData) {
        let requestURL = RequestURL(requestType: .get, browserData: browserData)
        activityIndicator.startAnimation(nil)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else {
                self?.response("Something went wrong. Please try again later.")
                return
            }
            
            guard let xacid = res.allHeaderFields["X-ACID"] as? String else {
                self?.response("Something went wrong. Please try again later.")
                return
            }
            
            switch browserData.callType {
            case .login:
                self?.authenticate(with: xacid, and: browserData)
            case .register:
                self?.register(with: xacid, and: browserData)
            default:
                self?.activityIndicator.stopAnimation(nil)
                return
            }
        })
    }
    
    //    MARK: Authenticate
    private func authenticate(with xacid: String, and browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else {
                self?.response("Something went wrong. Please try again later.")
                return
            }
            if (200...299) ~= res.statusCode {
                self?.response("Login Successful")
            } else if res.statusCode == 401 {
                self?.response("Login Failed. Please try again later.")
            }
        })
    }
    
    //    MARK: Register
    private func register(with xacid: String, and browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else {
                self?.response("Something went wrong. Please try again later.")
                return
            }
            if (200...299) ~= res.statusCode {
                self?.response("Successfully Registered")
            } else if res.statusCode == 401 {
                self?.response("Failed to Register")
            }
        })
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
