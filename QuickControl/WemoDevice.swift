//
//  WemoDevice.swift
//  QuickControl
//
//  Created by Christopher Truman on 1/30/15.
//  Copyright (c) 2015 truman. All rights reserved.
//

import Foundation

extension BasicUPnPDevice {
    func changeState(state: Int){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if (self.modelDescription == "Belkin Insight 1.0"){
                var services = NSArray(array: self.services.allValues)
                var basicService = services.objectAtIndex(0) as BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                }

                var parameters = OrderedDictionary(object: state, forKey: "BinaryState");
                var results = NSMutableDictionary()
                sleep(1);
                var ret = basicService.soap.action("SetBinaryState", parameters: parameters, returnValues: results);
            } else if (self.modelDescription == "Belkin WeMo Bridge for Zigbee bulbs"){
                var services = NSArray(array: self.services.allValues)
                var basicService = services.objectAtIndex(8) as BasicUPnPService
                if (!basicService.isProcessed) {
                    basicService.process
                }
                
                var body = NSString(format: "&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;DeviceStatus&gt;&lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;&lt;DeviceID available=&quot;YES&quot;&gt;B4750E1B957846E4&lt;/DeviceID&gt;&lt;CapabilityID&gt;10006&lt;/CapabilityID&gt;&lt;CapabilityValue&gt;%d&lt;/CapabilityValue&gt;&lt;/DeviceStatus&gt;&lt;DeviceStatus&gt;&lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;&lt;DeviceID available=&quot;YES&quot;&gt;B4750E1B95784683&lt;/DeviceID&gt;&lt;CapabilityID&gt;10006&lt;/CapabilityID&gt;&lt;CapabilityValue&gt;%d&lt;/CapabilityValue&gt;&lt;/DeviceStatus&gt;", state, state)
                var parameters = OrderedDictionary(object: body, forKey: "DeviceStatusList");
                var results = NSMutableDictionary()
                sleep(1);
                var ret = basicService.soap.action("SetDeviceStatus", parameters: parameters, returnValues: results);
            }
        });
    }
}