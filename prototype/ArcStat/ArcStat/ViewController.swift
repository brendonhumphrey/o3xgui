//
//  ViewController.swift
//  ArcStat
//
//  Created by brendon on 1/01/2016.
//  Copyright © 2016 brendon. All rights reserved.
//

import Cocoa
import OpenZFSInterface

class ViewController: NSViewController, NSTableViewDataSource,NSTableViewDelegate {
    
    @IBOutlet weak var arcStatsTableScrollView: NSScrollView!
    @IBOutlet weak var arcStatsTable: NSTableView!
    @IBOutlet weak var arcStatArcCMax: NSTextField!
    @IBOutlet weak var arcStatArcCMin: NSTextField!
    @IBOutlet weak var arcStatArcCurrent: NSTextField!
    @IBOutlet weak var arcStatMetaMax: NSTextField!
    @IBOutlet weak var arcStatMetaMin: NSTextField!
    @IBOutlet weak var arcStatMetaUsed: NSTextField!
    
    var arcStatsTableContent : NSMutableArray = NSMutableArray()
    var previousArcStatSample : ArcStatSample = ArcStatSample()
    var timeFormatter : NSDateFormatter = NSDateFormatter()
    var byteFormatter : NSByteCountFormatter = NSByteCountFormatter()
    var refreshTimer : NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeFormatter.dateFormat = "HH:mm:ss"

        // Initialise ARC sample collection
        previousArcStatSample = ArcStatSample()
        update()
        
        // Fetch new ARC stats every second
        refreshTimer = NSTimer.init(timeInterval: 1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(refreshTimer, forMode: NSRunLoopCommonModes)
    }

    @IBAction func clearButtonClicked(sender: AnyObject) {
        arcStatsTableContent.removeAllObjects()
        update()
        arcStatsTable.reloadData()
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func update() {
        let sample = ArcStatSample.readFromSysctl()
        let diff = sample.difference(previousArcStatSample)
        
        arcStatMetaMax.stringValue = byteFormatter.stringFromByteCount((Int64)(O3X.getArcMetaMax()))
        arcStatMetaMin.stringValue = byteFormatter.stringFromByteCount((Int64)(O3X.getArcMetaMin()))
        arcStatMetaUsed.stringValue = byteFormatter.stringFromByteCount((Int64)(O3X.getArcMetaUsed()))
        arcStatArcCMax.stringValue = byteFormatter.stringFromByteCount((Int64)(O3X.getArcCMax()))
        arcStatArcCMin.stringValue = byteFormatter.stringFromByteCount((Int64)(O3X.getArcCMin()))
        arcStatArcCurrent.stringValue = byteFormatter.stringFromByteCount((Int64)(sample.size))
        
        diff.calculatePercents()
        diff.date = sample.date
        diff.size = sample.size
        diff.tSize = sample.tSize
        
        arcStatsTableContent.addObject(diff)
        
        arcStatsTable.reloadData()
        
        previousArcStatSample = sample
        
        // Force the arc stats table to show the most recent sample
        // unless the vertical scrollbar has been moved from the bottom
        // of its range.
        if (arcStatsTableScrollView.verticalScroller!.floatValue > 0.9) {
            let numberOfRows = arcStatsTable.numberOfRows
            
            if (numberOfRows > 0) {
                arcStatsTable.scrollRowToVisible(numberOfRows - 1);
            }
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return arcStatsTableContent.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let kstat = arcStatsTableContent.objectAtIndex(row) as! ArcStatSample
        let identifier = tableColumn!.identifier
        let cv = arcStatsTable.makeViewWithIdentifier(identifier, owner: self) as! NSTableCellView;
        
        switch(identifier) {
        case "time":
            cv.textField?.stringValue = timeFormatter.stringFromDate(kstat.date)
            
        case "read":
            cv.textField?.stringValue = String(kstat.read)

        case "miss":
            cv.textField?.stringValue = String(kstat.misses)
            
        case "misspct":
            cv.textField?.stringValue = String(kstat.missPct)
            
        case "dmis":
            cv.textField?.stringValue = String(kstat.dMiss)
            
        case "dmpct":
            cv.textField?.stringValue = String(kstat.dMissPct)
            
        case "pmis":
            cv.textField?.stringValue = String(kstat.pMiss)
            
        case "pmpct":
            cv.textField?.stringValue = String(kstat.pMissPct)
            
        case "mmis":
            cv.textField?.stringValue = String(kstat.mMiss)
            
        case "mmpct":
            cv.textField?.stringValue = String(kstat.mMissPct)
            
        case "size":
            cv.textField?.stringValue = byteFormatter.stringFromByteCount(Int64(kstat.size))
            
        case "tsize":
            cv.textField?.stringValue = byteFormatter.stringFromByteCount(Int64(kstat.tSize))
            
        default:
            cv.textField?.stringValue = "?"
        }
        
        return cv
    }
    
   }

