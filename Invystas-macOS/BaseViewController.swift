//
//  BaseViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/21/20.
//

import Cocoa

class BaseViewController: NSViewController {
    
    @IBOutlet var debuggingField: NSTextView!
    @IBOutlet var activityIndicator: NSProgressIndicator!
    @IBOutlet var resultsLabel: NSTextField!

    func response(_ message: String) {
        let seconds = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.resultsLabel.stringValue = message
            self?.activityIndicator.stopAnimation(self)
        }
    }
}
