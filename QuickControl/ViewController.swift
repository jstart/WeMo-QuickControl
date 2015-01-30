//
//  ViewController.swift
//  QuickControl
//
//  Created by Christopher Truman on 10/27/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UPnPDBObserver {

    var devices = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var db = UPnPManager.GetInstance().DB
        
        var devices = db.rootDevices //BasicUPnPDevice

        db.addObserver(self)
        UPnPManager.GetInstance().SSDP.searchSSDP()
    }

    func UPnPDBUpdated(sender: UPnPDB!) {
        var db = UPnPManager.GetInstance().DB
        devices = db.rootDevices
        for object in devices  {
            let device = object as BasicUPnPDevice
            device.loadDeviceDescriptionFromXML()
            NSLog("device name: %@", device.friendlyName);
            NSLog("device name: %@", device.baseURL!);
            device.changeState(0)
        }
    }

}

