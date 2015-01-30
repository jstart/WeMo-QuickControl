//
//  WeMoDiscoveryManager.h
//  WeMo_Universal
//
//  Created by Manish Singhal on 06/12/12.
//
//

#import <Foundation/Foundation.h>
#import "WeMoConstants.h"
#import "WeMoControlDevice.h"


/**
 * SDK sends wemoBinaryStateNotification whenever there is a change in binary state of the WeMo device.
 *
 * @object dictionary : This notification is send with a dictionary object having 2 key-value pair.
 @"udn" -> udn of device who sent this message.
 @"Binary" -> Binary state of the device. Possible values either "0" or "1".
 */
extern NSString *const wemoBinaryStateNotification;

/**
 * SDK sends wemoPushNotification to application layer whenever SDK received push notification from WeMo device. Application layer should registered desired push notification into "Additional Push Notifications" key of "DeviceConfigData.plist" file. Application layer should also mention the service SDK should subscribe to receieve these push notifications in "Services Required Subscription" key of "DeviceConfigData.plist" file.
 
 * @object dictionary : This notification is send with a dictionary object having 3 key-value pair.
 @"Device UDN" -> udn of device who sent this message.
 @"Push Notification Name" -> Name of the push notification.
 @"Push Notification Value" -> Value of the notification.
 */
extern NSString *const wemoPushNotification;

@class WeMoDiscoveryManager;

/**
 @brief  WeMoDeviceDiscoveryDelegate - This protocol defines the required methods implemented by delegates of WeMoDiscoveryManager object.   */
@protocol WeMoDeviceDiscoveryDelegate <NSObject>
@required

/**
 * This is the required method needs to be implemented by the delegate. Delegate receives
 *      this message whenever discoveryManager founds a new device in the network.
 *
 * @param manager : Discovery Manager Instance sending the message
 *        device : Discovered device object.
 * @return None.
 */
-(void)discoveryManager:(WeMoDiscoveryManager*)manager didFoundDevice:(WeMoControlDevice*)device;

/**
 * This is the required method needs to be implemented by the delegate. Delegate receives
 *      this message whenever a device is removed from the network. Device may get
 *      removed from network due to restore to factory default, firmware upgrade or some other reason.
 *
 * @param manager : Discovery Manager Instance sending the message
 *        udn : udn of the removed device.
 * @return None.
 */
-(void)discoveryManager:(WeMoDiscoveryManager*)manager removeDeviceWithUdn:(NSString*)udn;

/**
 * This is the required method needs to be implemented by the delegate. Delegate receives
 *      this message when all devices are removed from the network.
 *
 * @param manager : Discovery Manager Instance sending the message
 * @return None.
 */
-(void)discoveryManagerRemovedAllDevices:(WeMoDiscoveryManager*)manager;


@end

/**
 @brief  WeMoDiscoveryManager - This is a singleton class which is used to discover WeMo devices in the network.
 */
@interface WeMoDiscoveryManager : NSObject

@property(nonatomic,assign)id<WeMoDeviceDiscoveryDelegate> deviceDiscoveryDelegate;

/**
 * WeMoDiscoveryManager is a singleton class and this method returns the shared instance of
 *      WeMoDiscoveryManager interface.
 *
 * @param None
 * @return a singleton instance of WeMoDiscoveryManager interface if success else nil.
 */
+(WeMoDiscoveryManager*)sharedWeMoDiscoveryManager;

/**
 * Releases the memory occupied by WeMoDiscoveryManager instance.
 *
 * @param None
 * @return None.
 */
+(void)releaseWeMoDiscoveryManager;

/**
 * This method is used to discover the devices in the current network based on the interface passed
 *      as an argument. This method returns immediately and application layer will be notified about
 *      the discovered devices through the delegate methods of WeMoDiscoveryDelegate.
 *
 * @param interface : Interface type used to discover devices in current network. Currently,
 *      WeMoCustomInterface is the only supported interface for discovery.
 * @returns the status of the discoverDevices API
 */
-(WeMoStatus)discoverDevices:(WeMoInterfaceList)_interface;

/**
 * This method is used to get discovered device count.
 *
 * @param None.
 * @returns the discovered device count.
 */

-(NSInteger)getDeviceCount;

/**
 * This method is used to subscribe services mentioned in the plist file.
 *
 * @param udn : udn of the device.
 * @returns None.
 */

- (void)subscribe:(NSString*)udn;


@end
