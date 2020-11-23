//
//  ViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa
import LocalAuthentication

class ViewController: BaseViewController {
        
    var identifierManager: IdentifierManager?
    var networkManager: NetworkManager?
    var browserData: BrowserData?
    
    let context = LAContext()
    var error: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let browserData = self.browserData {
            networkManager = NetworkManager()
            identifierManager = IdentifierManager(browserData)
            beginInvystaProcess(with: browserData)
        }
    }
    
    //    MARK: Begin Invysta Process
    private func beginInvystaProcess(with browserData: BrowserData) {
        
        requestXACID(browserData)
    }
    
    //    MARK: Request XACID
    private func requestXACID(_ browserData: BrowserData) {
        let requestURL = RequestURL(requestType: .get, browserData: browserData)
        activityIndicator.startAnimation(nil)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            
            guard let xacid = res.allHeaderFields["X-ACID"] as? String else { return }
            
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
                self?.activityIndicator.stopAnimation(nil)
                return
            }
            self?.networkManagerResponse(with: res)
        })
    }
    
    //    MARK: Authenticate
    private func register(with xacid: String, and browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else {
                self?.activityIndicator.stopAnimation(nil)
                return
            }
            self?.networkManagerResponse(with: res)
        })
    }
    
    //    MARK: Network Response
    private func networkManagerResponse(with response: HTTPURLResponse) {
        print("Network Response",response)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimation(nil)
            if (200...299) ~= response.statusCode {
                print("Done!")
            }
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

