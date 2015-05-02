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

    let deviceStore = DeviceStore()
    var deviceState = NSMutableDictionary()
    let db = UPnPManager.GetInstance().DB
    var storedCompletionHandler = { (result:NCUpdateResult) -> Void in
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var savedDevices = deviceStore.getDevices()
        if let savedDevicesArray = savedDevices as NSMutableArray! {
            deviceStore.devices = savedDevicesArray
            tableView.reloadData()
        } else {
            deviceStore.devices = db.rootDevices //BasicUPnPDevice
        }
        db.addObserver(self)
        UPnPManager.GetInstance().SSDP.searchSSDP
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        storedCompletionHandler = completionHandler
        var savedDevices = deviceStore.getDevices()
        
        if let savedDevicesArray = savedDevices as NSMutableArray! {
            deviceStore.devices = savedDevicesArray
            tableView.reloadData()
        } else {
            deviceStore.devices = db.rootDevices //BasicUPnPDevice
        }
        db.addObserver(self)
        UPnPManager.GetInstance().SSDP.searchSSDP
    }
    
    func UPnPDBUpdated(sender: UPnPDB!) {
        var db = UPnPManager.GetInstance().DB
        if (db.rootDevices.count > 0){
            deviceStore.devices = db.rootDevices
        }
        
        deviceStore.saveDevices()
        for object in deviceStore.devices  {
            let device = object as! BasicUPnPDevice
            device.loadDeviceDescriptionFromXML
            NSLog("device name: %@", device.friendlyName);
            NSLog("device name: %@", device.baseURL!);
        }

        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.preferredContentSize = CGSizeMake(CGFloat(0), CGFloat(self.tableView(self.tableView, numberOfRowsInSection: 0)) * CGFloat(self.tableView.rowHeight))
            self.storedCompletionHandler(NCUpdateResult.NewData)
        })
    }
    
    @IBAction func turnOn(sender: AnyObject) {
        var cell = sender.superview!!.superview! as! UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        let device = deviceStore.devices[indexPath.row] as! BasicUPnPDevice
        device.changeState(1, callback: {(state) in
            self.deviceState.setObject(NSNumber(bool: state), forKey: device.uuid)
        })

        device.getState({(state) in
            self.deviceState.setObject(NSNumber(bool: state), forKey: device.uuid)
        })
        device.getNetworkStatus({(state) in

        })
    }

    @IBAction func turnOff(sender: AnyObject) {
        var cell = sender.superview!!.superview! as! UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        let device = deviceStore.devices[indexPath.row] as! BasicUPnPDevice
        device.changeState(0, callback: {(state) in
            self.deviceState.setObject(NSNumber(bool: state), forKey: device.uuid)
        })

        device.getState({(state) in
            self.deviceState.setObject(NSNumber(bool: state), forKey: device.uuid)
        })
        device.getNetworkStatus({(state) in
            
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceStore.devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let device = deviceStore.devices[indexPath.row] as! BasicUPnPDevice
        
        cell.textLabel!.text = device.friendlyName
        cell.detailTextLabel!.text = device.modelDescription
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let device = deviceStore.devices[indexPath.row] as BasicUPnPDevice
//        device.changeState(1)
    }
    
}
