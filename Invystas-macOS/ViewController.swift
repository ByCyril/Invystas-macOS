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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let browserData = BrowserData(action: "log", encData: "encData", magic: "magicVal")
        identifierManager = IdentifierManager(browserData)
   
        networkManager = NetworkManager()
        
        let requestURL = RequestURL(requestType: .post, browserData: browserData)
        networkManager?.call(requestURL, completion: { (data, response, error) in
            print("Error",error?.localizedDescription)
            guard let res = response as? HTTPURLResponse else { return }
            print("Res",res)
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
                print("X-ACID",xacid)
            } else {
                print("Cant get X-ACID")
            }
        })
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

