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

        print(browserData?.see ?? "NA")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

