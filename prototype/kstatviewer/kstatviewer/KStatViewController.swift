//
//  ViewController.swift
//  kstatviewer
//
//  Created by brendon on 1/01/2016.
//  Copyright © 2016 brendon. All rights reserved.
//

import Cocoa
import OpenZFSInterface

class KStatViewController: NSViewController, NSTableViewDataSource,NSTableViewDelegate, NSSearchFieldDelegate {

    @IBOutlet weak var kstatTable: NSTableView!
    @IBOutlet weak var kstatFilter: NSSearchField!

    var filteredKStats : NSArray = NSArray()
    var kstats : NSMutableArray = NSMutableArray()
    var refreshTimer : NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get list of all kstats, establish initial filter and fetch values
        let sysctlNames = Sysctl.getAllNames() as NSMutableArray
        
        for obj in sysctlNames {
            if let sysctlName = obj as? NSString
            {
                if (sysctlName.containsString("kstat")) {
                    kstats.addObject(TmpKStat(name: sysctlName as String))
                }
            }

        }
        
        applyFilterWithString("")
        update()
        
        // Fetch new kstats every 5 seconds
        refreshTimer = NSTimer(timeInterval: 5.0, target: self, selector: "update", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(refreshTimer, forMode: NSRunLoopCommonModes)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func refreshClicked(sender: AnyObject) {
        // Get list of all kstats, establish initial filter and fetch values
        let sysctlNames = Sysctl.getAllNames() as NSMutableArray
        
        for obj in sysctlNames {
            if let sysctlName = obj as? NSString
            {
                if (sysctlName.containsString("kstat")) {
                    kstats.addObject(TmpKStat(name: sysctlName as String))
                }
            }
            
        }
        
        applyFilterWithString("")
        update()
    }
    
    func update() {
        for kstat in filteredKStats {
            kstat.update()
        }
        
        kstatTable.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return filteredKStats.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let kstat = filteredKStats.objectAtIndex(row) as! TmpKStat
        let identifier = tableColumn!.identifier
        let cv = kstatTable.makeViewWithIdentifier(identifier, owner: self) as! NSTableCellView;

        switch (identifier) {
        case "kstat":
            cv.textField!.stringValue = kstat.name;
        
        case "kstatvalue":
            cv.textField!.stringValue = kstat.valueAsString();
            
        default:
            cv.textField!.stringValue = "?"
            
        }
        
        return cv
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        applyFilterWithString(kstatFilter.stringValue)
    }
    
    func applyFilterWithString(filter : NSString) {
        if(filter.length > 0) {
            filteredKStats = kstats.filter({ $0.name.containsString(filter as String) })
        } else {
            filteredKStats = kstats.copy() as! NSArray
        }
        
        kstatTable.reloadData()
    }
    
    
}

