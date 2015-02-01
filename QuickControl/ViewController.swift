//
//  ViewController.swift
//  QuickControl
//
//  Created by Christopher Truman on 10/27/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UPnPDBObserver {

    var devices = []
    let sharedDefaults = NSUserDefaults(suiteName:"group.truman.QuickControl")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Devices"
        var db = UPnPManager.GetInstance().DB
        devices = db.rootDevices //BasicUPnPDevice
        db.addObserver(self)
        UPnPManager.GetInstance().SSDP.searchSSDP
    }

    func UPnPDBUpdated(sender: UPnPDB!) {
        var db = UPnPManager.GetInstance().DB
        devices = db.rootDevices
//        sharedDefaults.setObject(devices, forKey: "Devices");
        for object in devices  {
            let device = object as BasicUPnPDevice
            device.loadDeviceDescriptionFromXML
            NSLog("device name: %@", device.friendlyName);
            NSLog("device name: %@", device.baseURL!);
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let device = devices[indexPath.row] as BasicUPnPDevice

        cell.textLabel!.text = device.friendlyName
        cell.detailTextLabel!.text = device.modelDescription
        return cell;
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let device = devices[indexPath.row] as BasicUPnPDevice

        return [UITableViewRowAction(style: .Normal, title: "On", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                device.changeState(1)
                tableView.setEditing(false, animated: true)
        }), UITableViewRowAction(style: .Default, title: "Off", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                device.changeState(0)
                tableView.setEditing(false, animated: true)
        })]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Need this method to get swipe actions
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let device = devices[indexPath.row] as BasicUPnPDevice
        device.changeState(1)
    }
    
}

