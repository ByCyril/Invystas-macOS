//
//  ViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/2/20.
//

import Cocoa

class ViewController: NSViewController {

    var identifierManager: IdentifierManager?
    var networkManager: NetworkManager?
    var browserData: BrowserData?

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
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            
            guard let xacid = res.allHeaderFields["X-ACID"] as? String else { return }
            
            switch browserData.callType {
            case .login:
                self.authenticate(with: xacid, and: browserData)
            case .register:
                self.register(with: xacid, and: browserData)
            default:
                return
            }
        })
    }
    
    private func authenticate(with xacid: String, and browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
    private func register(with xacid: String, and browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
    //    MARK: Network Response
        private func networkManagerResponse(with response: HTTPURLResponse) {
            DispatchQueue.main.async { [weak self] in
                if (200...299) ~= response.statusCode {
                    print("Working")
                }
            }
            
        }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

