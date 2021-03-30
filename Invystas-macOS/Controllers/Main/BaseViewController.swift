//
//  BaseViewController.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 11/21/20.
//

import Cocoa
import InvystaCore

class BaseViewController: NSViewController {
    
    @IBOutlet var customView1: NSView!
    @IBOutlet var customView2: NSView!
    @IBOutlet var customView3: NSView!
    @IBOutlet var customView4: NSView!

    @IBOutlet weak var deviceSecurityToggle: NSButton!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    private var activity: [Activity] = []
    private let coreDataManager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initUI()
    }
    
    func initTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        reloadTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("ReloadTable"), object: nil)
    }
  
    func initUI() {
        
        title = "Invysta Aware"
        view.wantsLayer = true
        
        let isEnabled = IVUserDefaults.getBool(.DeviceSecurity)
        deviceSecurityToggle.state = (isEnabled) ? .on : .off
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.stringValue = appVersion ?? "NA"
        
        [customView1, customView2, customView3, customView4].forEach { (element) in
            element?.wantsLayer = true
            let backgroundColor = NSColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1).cgColor
            element?.layer?.backgroundColor = backgroundColor
            element?.layer?.cornerRadius = 5
        }
        
    }
    
    @objc
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activity = self.coreDataManager.fetch(Activity.self).reversed()
            self.tableView.reloadData()
        }
    }

    @IBAction func showPrivacyPolicy(_ sender: Any) {
        guard NSWorkspace.shared.open(URL(string: "https://invysta.com/privacy-policy/")!) else { return }
    }
    
    @IBAction func showHelpPage(_ sender: Any) {
        guard NSWorkspace.shared.open(URL(string: "https://invysta.com/support/faqs/")!) else { return }
    }
    
    @IBAction func clearRecentActivity(_ sender: Any) {
        PersistenceManager.shared.deleteAll()
        activity.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func toggleDeviceSecurity(_ sender: NSButton) {
        IVUserDefaults.set(sender.state == .on, .DeviceSecurity)
    }
    
}

extension BaseViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return activity.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let activityObj: Activity = activity[row]
            
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("activityData") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = activityObj.date?.timeIntervalSince1970.date(.fullDate) ?? "hi"
            return cellView
            
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("activityResults") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "resultCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = activityObj.message ?? "hello"
            return cellView
            
        } else  {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "statusCodeCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.integerValue = Int(activityObj.statusCode)
            return cellView
            
        }
        
    }
}

extension Double {
    public enum TimestampFormat: String {
        case halfDate = "E, MMM d"
        case fullDate = "MMMM d, yyyy, h:mm a"
        case time = "h:mm a"
        case hour = "h a"
        case day = "EEEE"
    }
    
    public func date(_ format: TimestampFormat, _ timezone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timezone ?? TimeZone.current
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
