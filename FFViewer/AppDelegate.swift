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

    var data: [Post] = []
    var ffviewer: FFViewer = FFViewer()

    @IBAction func outputPushed(sender: AnyObject) {
        ffviewer.output(data)
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        data = ffviewer.load()
        for dat in data {
            println(dat.prop)
        }
        postTable.reloadData()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int {
        return data.count
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
        if let tc: NSTableColumn = tableColumn {
            return data[row].prop[tc.identifier]
        }
        return ""
    }
}

