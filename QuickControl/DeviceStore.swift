//
//  DeviceStore.swift
//  QuickControl
//
//  Created by Christopher Truman on 1/31/15.
//  Copyright (c) 2015 truman. All rights reserved.
//

import Foundation

class DeviceStore {
    var devices = NSMutableArray()
    let sharedDefaults = NSUserDefaults(suiteName:"group.truman.QuickControl")!
    
    func appendDevices(devicesToAppend: [AnyObject]){
        if (devices.count == 0){
            devices = NSMutableArray(arrayLiteral: devicesToAppend)
        } else {
            var devicesToRemove = [BasicUPnPDevice]()
            for device in devices {
                for otherDevice in devicesToAppend {
                    if (device.uuid == otherDevice.udn){
                        devicesToRemove.append(device as! BasicUPnPDevice)
                    }
                }
            }
            devices.removeObjectsInArray(devicesToRemove)
            devices.addObjectsFromArray(devicesToAppend)
        }
    }
    
    func getDevices() -> NSMutableArray? {
        if let archivedDevices = sharedDefaults.objectForKey("Devices") as? NSArray {
            var unarchivedDevices = NSMutableArray()
            for object in archivedDevices{
                let data = object as! NSData
                if let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? BasicUPnPDevice {
                    unarchivedDevices.addObject(unarchivedObject)
                }
            }
            return unarchivedDevices
        }
        return nil
    }
    
    func saveDevices() {
        var archiveArray = NSMutableArray()
        devices.sortUsingComparator({(obj1, obj2) -> NSComparisonResult in
            let device1 = obj1 as! BasicUPnPDevice
            let device2 = obj2 as! BasicUPnPDevice
            let result = device1.friendlyName.compare(device2.friendlyName)
            return result
        })
        for deviceObject in devices {
            var deviceEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(deviceObject)
            archiveArray.addObject(deviceEncodedObject)
        }
        sharedDefaults.setObject(archiveArray, forKey: "Devices");
    }
    
    func filterNonBelkin() {
        devices.filterUsingPredicate(NSPredicate(format: "modelDescription CONTAINS[cd] %@", "Belkin"))
    }
}