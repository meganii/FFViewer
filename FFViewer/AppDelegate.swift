//
//  AppDelegate.swift
//  FFViewer
//
//  Created by  Yuhei Tsubokawa on 2015/06/27.
//  Copyright (c) 2015年  Yuhei Tsubokawa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var postTable: NSTableView!
    @IBOutlet weak var postCounts: NSTextField!

    var data: [Post] = []
    var ffviewer: FFViewer = FFViewer()

    @IBAction func outputPushed(sender: AnyObject) {
        ffviewer.output(data)
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        data = ffviewer.load()
        postCounts.integerValue = data.count
        postTable.reloadData()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if let tc: NSTableColumn = tableColumn {
            return data[row].prop[tc.identifier]
        }
        return ""
    }
    
    func tableView(tableView: NSTableView,
        sortDescriptorsDidChange oldDescriptors: [AnyObject])  {
            for sortDescriptor in tableView.sortDescriptors.reverse() as! [NSSortDescriptor] {
                var key = sortDescriptor.key() as String!
                if sortDescriptor.ascending {
                    data.sort {(item1, item2) in return item1.prop[key] < item2.prop[key]}
                } else {
                    data.sort {(item1, item2) in return item1.prop[key] > item2.prop[key]}
                }
            }
        tableView.reloadData()
    }
    

    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        let tc: NSTableColumn = tableColumn!
        data[row].prop[tc.identifier] = object as? String
    }

}

