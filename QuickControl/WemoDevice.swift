//
//  WemoDevice.swift
//  QuickControl
//
//  Created by Christopher Truman on 1/30/15.
//  Copyright (c) 2015 truman. All rights reserved.
//

import Foundation

extension BasicUPnPDevice : BasicUPnPServiceObserver{
    
    func getNetworkStatus(callback: (Bool) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if (self.modelDescription == "Belkin Insight 1.0"){
                var basicService = self.services["urn:Belkin:service:deviceinfo:1"] as! BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    sleep(1);
                }
               
                basicService.soap.action("GetDeviceInformation", parameters: nil, callback: {(responseDictionary : [NSObject : AnyObject]!) in
                    
                });
            } else if (self.modelDescription == "Belkin WeMo Bridge for Zigbee bulbs"){
                var basicService = self.services["urn:Belkin:service:bridge:1"] as! BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    sleep(1);
                }
                basicService.soap.action("GetGroups", parameters: ["DevUDN":self.udn], callback: {(responseDictionary : [NSObject : AnyObject]!) in
//                    var deviceIDsString = responseDictionary!["DeviceIDs"] as NSString!
//                    var deviceIDs = deviceIDsString.componentsSeparatedByString(",")
                });
//                basicService.soap.action("RemoteAccess", parameters: ["dst":0, "DeviceName":self.friendlyName], callback: {(responseDictionary : [NSObject : AnyObject]!) in
//
//                });
            }
        });
    }
    
    func getState(callback: (Bool) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if (self.modelDescription == "Belkin Insight 1.0"){
                var basicService = self.services["urn:Belkin:service:basicevent:1"] as! BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    basicService.addObserver(self)
                    sleep(1);
                }
                
                basicService.soap.action("GetBinaryState", parameters: nil, callback: {(responseDictionary : [NSObject : AnyObject]!) in
                    var state = responseDictionary["BinaryState"] as? NSString
                    if let resolvedState = state{
                        callback(resolvedState.integerValue > 0)
                    }else {
                        callback(false)
                    }
                });
            } else if (self.modelDescription == "Belkin WeMo Bridge for Zigbee bulbs"){
                var basicService = self.services["urn:Belkin:service:basicevent:1"] as! BasicUPnPService

                if (!basicService.isProcessed) {
                    basicService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    basicService.addObserver(self)
                    sleep(1);
                }
                
                basicService.soap.action("GetBinaryState", parameters: nil, callback: {(responseDictionary : [NSObject : AnyObject]!) in
                    var state = responseDictionary["BinaryState"] as? NSString
                    if let resolvedState = state{
                        callback(resolvedState.integerValue > 0)
                    }else {
                        callback(false)
                    }
                });
            }
        });
    }
    
    func changeState(state: Int,callback: (Bool) -> Void){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if (self.modelDescription == "Belkin Insight 1.0"){
                var basicService = self.services["urn:Belkin:service:basicevent:1"] as! BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    basicService.addObserver(self)
                    sleep(1);
                }

                var parameters = OrderedDictionary(object: state, forKey: "BinaryState");
                var results = NSMutableDictionary()

                basicService.soap.action("SetBinaryState", parameters: parameters as [NSObject : AnyObject], callback: {(responseDictionary) in
                    var state = responseDictionary["BinaryState"] as? NSString
                    if let resolvedState = state{
                        callback(resolvedState.integerValue > 0)
                    }else {
                        callback(false)
                    }
                });
            } else if (self.modelDescription == "Belkin WeMo Wi-Fi to ZigBee Bridge"){
                var bridgeService = self.services["urn:Belkin:service:bridge:1"] as! BasicUPnPService
                bridgeService.addObserver(self)
                if (!bridgeService.isProcessed) {
                    bridgeService.process
                    //TODO: First call will fail because processing service makes the device busy
                    // Sleep is a hack to make sure the call succeeds.
                    bridgeService.addObserver(self)
                    sleep(1);
                }
                
                var body = NSString(format: "&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;DeviceStatus&gt;&lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;&lt;DeviceID available=&quot;YES&quot;&gt;B4750E1B957846E4&lt;/DeviceID&gt;&lt;CapabilityID&gt;10006&lt;/CapabilityID&gt;&lt;CapabilityValue&gt;%d&lt;/CapabilityValue&gt;&lt;/DeviceStatus&gt;&lt;DeviceStatus&gt;&lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;&lt;DeviceID available=&quot;YES&quot;&gt;B4750E1B95784683&lt;/DeviceID&gt;&lt;CapabilityID&gt;10006&lt;/CapabilityID&gt;&lt;CapabilityValue&gt;%d&lt;/CapabilityValue&gt;&lt;/DeviceStatus&gt;", state, state)
                var parameters = OrderedDictionary(object: body, forKey: "DeviceStatusList");
                var results = NSMutableDictionary()
                var ret: Void = bridgeService.soap.action("SetDeviceStatus", parameters: parameters as [NSObject : AnyObject], callback: {(responseDictionary : [NSObject : AnyObject]!) in
                    var state = responseDictionary["ErrorDeviceIDs"] as? NSString
                    if let resolvedState = state{
                        callback(resolvedState.isEqualToString(""))
                    }else {
                        callback(false)
                    }
                });
            }
        });
    }
    
    public func UPnPEvent(sender: BasicUPnPService!, events: [NSObject : AnyObject]!) {
        NSLog("%@ %@ %@", sender, events.keys.array, events.values.array)
    }
}
