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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("Blank")
    }
    
    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        self.browserData = browserData
        print("Here")
        print("view",view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0,
                                         width: 480,
                                         height: 480))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print("BrowserData",browserData?.see ?? "na")
        print("ViewDidLoad")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

