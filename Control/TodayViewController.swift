//
//  TodayViewController.swift
//  Control
//
//  Created by Christopher Truman on 11/5/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, UPnPDBObserver, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let groupName = "group.truman.QuickControl"
    let sharedDefaults = NSUserDefaults(suiteName:"group.truman.QuickControl")!

    var devices:NSMutableArray = NSMutableArray()
    let db = UPnPManager.GetInstance().DB
    var storedCompletionHandler = { (result:NCUpdateResult) -> Void in
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        devices = db.rootDevices //BasicUPnPDevice
        db.addObserver(self)
        UPnPManager.GetInstance().SSDP.searchSSDP
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        storedCompletionHandler = completionHandler
//        var savedDevices: AnyObject? = sharedDefaults.objectForKey("Devices")
        var savedDevices = devicesFromDisk()
        if let savedDevicesArray = savedDevices as NSMutableArray! {
            devices = savedDevicesArray
            tableView.reloadData()
        }
        UPnPManager.GetInstance().SSDP.searchSSDP
    }
    
    func UPnPDBUpdated(sender: UPnPDB!) {
        var db = UPnPManager.GetInstance().DB
        if (db.rootDevices.count > 0){
            devices = db.rootDevices
        }
        var containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupName)
        var fileURL = containerURL!.URLByAppendingPathComponent("Library/Caches/Devices")
//        var bool = devices.writeToFile(fileURL.absoluteString!, atomically: true)
//        sharedDefaults.setObject(devices, forKey: "Devices");
        for object in devices  {
            let device = object as BasicUPnPDevice
            device.loadDeviceDescriptionFromXML
            NSLog("device name: %@", device.friendlyName);
            NSLog("device name: %@", device.baseURL!);
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.preferredContentSize = CGSizeMake(CGFloat(0), CGFloat(self.tableView(self.tableView, numberOfRowsInSection: 0)) * CGFloat(self.tableView.rowHeight) + self.tableView.sectionFooterHeight)
            self.storedCompletionHandler(NCUpdateResult.NewData)
        })
    }
    
    func saveDevices(devices : NSMutableArray){
        var containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupName)
        var fileURL = containerURL!.URLByAppendingPathComponent("Library/Caches/Devices")
        devices.writeToFile(fileURL.absoluteString!, atomically: true)
    }
    
    func devicesFromDisk() ->  NSMutableArray? {
        var containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupName)
        var fileURL = containerURL!.URLByAppendingPathComponent("Library/Caches/Devices")
        var devicesArray = NSMutableArray(contentsOfURL: fileURL)
        return devicesArray
    }

    @IBAction func turnOn(sender: AnyObject) {
        var cell = sender.superview!!.superview! as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        let device = devices[indexPath.row] as BasicUPnPDevice
        device.changeState(1)
    }

    @IBAction func turnOff(sender: AnyObject) {
        var cell = sender.superview!!.superview! as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        let device = devices[indexPath.row] as BasicUPnPDevice
        device.changeState(0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let device = devices[indexPath.row] as BasicUPnPDevice
        
        cell.textLabel!.text = device.friendlyName
        cell.detailTextLabel!.text = device.modelDescription
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let device = devices[indexPath.row] as BasicUPnPDevice
        device.changeState(1)
    }
    
}
