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
        if (modelDescription == "Belkin Insight 1.0"){
            var services = NSArray(array: self.getServices().allValues)
            for service in services {
                var serviceUpnp = service as BasicUPnPService
                service.process()
            }
            var basicService = services.objectAtIndex(0) as BasicUPnPService
            basicService.process();
            
            var parameters = OrderedDictionary(object: state, forKey: "BinaryState");
            var results = NSMutableDictionary()
            sleep(1);
            var ret = basicService.soap.action("SetBinaryState", parameters: parameters, returnValues: results);
        } else if (modelDescription == "Belkin WeMo Bridge for Zigbee bulbs"){
            var services = NSArray(array: self.getServices().allValues)
            for service in services {
                var serviceUpnp = service as BasicUPnPService
                service.process()
            }
            var basicService = services.objectAtIndex(8) as BasicUPnPService
            basicService.process();
            
            var body = NSString(format: "&amp;lt;?xml version=&amp;quot;1.0&amp;quot; encoding=&amp;quot;UTF-8&amp;quot;?&amp;gt;&amp;lt;DeviceStatus&amp;gt;&amp;lt;IsGroupAction&amp;gt;NO&amp;lt;/IsGroupAction&amp;gt;&amp;lt;DeviceID available=&amp;quot;YES&amp;quot;&amp;gt;B4750E1B957846E4&amp;lt;/DeviceID&amp;gt;&amp;lt;CapabilityID&amp;gt;10006&amp;lt;/CapabilityID&amp;gt;&amp;lt;CapabilityValue&amp;gt;%d&amp;lt;/CapabilityValue&amp;gt;&amp;lt;/DeviceStatus&amp;gt;", state, state)
            var parameters = OrderedDictionary(object: body, forKey: "DeviceStatusList");
            var results = NSMutableDictionary()
            sleep(1);
            var ret = basicService.soap.action("SetDeviceStatus", parameters: parameters, returnValues: results);
        }
    }
}