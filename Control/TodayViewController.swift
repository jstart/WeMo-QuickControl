//
//  TodayViewController.swift
//  Control
//
//  Created by Christopher Truman on 11/5/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    let opManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://api.xbcs.net:8443"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opManager.responseSerializer = AFKissXMLResponseSerializer() as AFHTTPResponseSerializer
        opManager.securityPolicy.allowInvalidCertificates = false
        opManager.securityPolicy.validatesDomainName = false
        
        self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 37)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 37)
        var request = requestDevicesForHome("1660855")
        var httpRequest = opManager.HTTPRequestOperationWithRequest(request, success: {operation, responseObject in
            var xml = responseObject as DDXMLDocument
            println(xml.rootElement)
            
            }, failure: { operation, error in
                println(operation.responseObject)
                println(error)
        })
        httpRequest.shouldUseCredentialStorage = true
        opManager.operationQueue.addOperation(httpRequest)

        completionHandler(NCUpdateResult.NewData)
    }

    @IBAction func switchTriggered(sender: UISwitch) {
        switch sender.on {
        case true:
            turnOn()
        case false:
            turnOff()
        default:
            turnOn()
        }
    }
    
    func changeValueForGroupRequest(on: Bool) -> NSMutableURLRequest {
        var onInteger = on ? 1 : 0
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: "https://api.xbcs.net:8443/apis/http/device/groups/capabilityProfile?remoteSync=true")
        request.setValue("SDU cd5aef5215ce523a3ebe1fffa40b0baf89a6600b:kwQUFZUjLQsdCMYS7SGA1NS3J40=:1415412470", forHTTPHeaderField: "Authorization")
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "PUT"
        request.HTTPBody = "<groups><group><id>2609</id><referenceId>1415339274</referenceId><groupName>Lighting Group</groupName><iconVersion>9</iconVersion><devices><device><deviceId>3136773</deviceId></device><device><deviceId>3136771</deviceId></device></devices><capabilities><capability><capabilityId>10006</capabilityId><currentValue>\(onInteger)</currentValue></capability><capability><capabilityId>30008</capabilityId><currentValue>0:0</currentValue></capability></capabilities></group></groups>".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return request
    }
    
    func requestDevicesForHome(homeID: String) -> NSMutableURLRequest {
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: "https://api.xbcs.net:8443/apis/http/device/homeDevices/\(homeID)/remoteDataSynchronization")
        request.setValue("SDU cd5aef5215ce523a3ebe1fffa40b0baf89a6600b:kwQUFZUjLQsdCMYS7SGA1NS3J40=:1415412470", forHTTPHeaderField: "Authorization")
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        return request
    }
    
    func turnOn() {
        var request = changeValueForGroupRequest(true)
        var httpRequest = opManager.HTTPRequestOperationWithRequest(request, success: {operation, responseObject in
            var xml = responseObject as DDXMLDocument
            println(xml)
            
            }, failure: { operation, error in
                println(operation.responseObject)
                println(error)
        })
        httpRequest.shouldUseCredentialStorage = true
        opManager.operationQueue.addOperation(httpRequest)
    }
    
    func turnOff() {
        var request = changeValueForGroupRequest(false)
        var httpRequest = opManager.HTTPRequestOperationWithRequest(request, success: {operation, responseObject in
            var xml = responseObject as DDXMLDocument
            println(xml)
            }, failure: { operation, error in
                println(operation.responseObject)
                println(error)
        })
        httpRequest.shouldUseCredentialStorage = true
        opManager.operationQueue.addOperation(httpRequest)
    }
    
}
