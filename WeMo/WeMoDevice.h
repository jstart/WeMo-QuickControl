//
//  WeMoDevice.h
//  BelkinFrameworks
//
//  Created by Manish on 2/5/13.
//  Copyright (c) 2013 Belkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeMoConstants.h"

/**
 * result codes for change icon API
 */
enum {
    WeMoChangeIconStatusSuccess = 0,
    WeMoChangeIconStatusFailed,
    WeMoInvalidIcon,
};

typedef NSInteger WeMoChangeIconStatus;

/**
 * result codes for change friendly name API
 */
enum {
    WeMoFriendlyNameStatusSuccess = 0,
    WeMoFriendlyNameStatusFailed,
    WeMoInvalidFriendlyName,
};

typedef NSInteger WeMoFriendlyNameStatus;

@class WeMoDevice;

/**
 @brief  WeMoRestoreIconDelegate - This protocol defines the required methods implemented by delegates of WeMoDevice object.   */
@protocol WeMoRestoreIconDelegate <NSObject>

@required

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for restorDeviceIcon API to inform the application layer that WeMo device icon has restored successfully.
 *
 * @param device : WeMoDevice Instance sending the message
 * @return None.
 */
- (void) didRestoreIconSuccessfully:(WeMoDevice*)wemoDevice;

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for restorDeviceIcon API to inform the application layer that restoreDeviceIcon API has failed.
 *
 * @param device : WeMoDevice Instance sending the message
 * @return None.
 */
- (void) didFailedToRestoreIcon:(WeMoDevice*)wemoDevice;

@end

/**
 @brief  WeMoChangedIconDelegate - This protocol defines the required methods implemented by delegates of WeMoDevice object.   */
@protocol WeMoChangedIconDelegate <NSObject>

@required
/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for changeDeviceIcon API to inform the application layer that WeMo device icon has changed successfully.
 *
 * @param device : WeMoDevice Instance sending the message
 * @return None.
 */
- (void) didChangedIconSuccessfully:(WeMoDevice*)wemoDevice;

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for changeDeviceIcon API to inform the application layer that some failure occured while changing device icon.
 *
 * @param device : WeMoDevice Instance sending the message
 *        error : An error object. Please refer enum WeMoChangeIconStatus for more details
 * @return None.
 */
- (void) didFailedToChangeIcon:(WeMoDevice*)wemoDevice withError:(NSError*)error;

@end


/**
 @brief  WeMoChangeFriendlyNameDelegate - This protocol defines the required methods implemented by delegates of WeMoDevice object.   */
@protocol WeMoChangeFriendlyNameDelegate <NSObject>
@required

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for changeFriendlyNameAsynchronously API to inform the application layer that WeMo device frendly name changed successfully.
 *
 * @param device : WeMoDevice Instance sending the message
 * @return None.
 */
- (void) didChangedNameSuccessfully:(WeMoDevice*)wemoDevice;

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for changeFriendlyNameAsynchronously API to inform the application layer that some error occured while changing device
 *      friendlyname.
 *
 * @param error : An error object. Please refer enum WeMoFriendlyNameStatus for more details
 * @return None.
 */
- (void) didFailedToChangeName:(NSError*)error;

@end

/**
 @brief  WeMoSignalStrengthDelegate - This protocol defines the required methods implemented by delegates of WeMoDevice object.   */
@protocol WeMoSignalStrengthDelegate <NSObject>

@required

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for getSignalStrengthAsynchronously API to provide device signal strength to the application layer.
 *
 * @param device : WeMoDevice Instance sending the message
 *        signalStrength : Signal strength of the WeMo device.
 * @return None.
 */
- (void) wemoDevice:(WeMoDevice*)wemoDevice withSignalStrength:(NSInteger)signalStrength;

/**
 * This is the required method needs to be implemented by the delegate. Application recieves this method as a callback method
 *      for getSignalStrengthAsynchronously API to inform the application layer that some failure occured while retrieving device
 *      signal strength.
 *
 * @param device : WeMoDevice Instance sending the message
 * @return None.
 */
- (void) didFailedToGetSignalStrength:(WeMoDevice*)wemoDevice;
@end

/**
 @brief  WeMoDevice - A WeMoDevice object provides basic information about the device. It gives information about the friendlyname, udn, icon and provides method to change those properties.   */
@interface WeMoDevice : NSObject{
@private
    NSString *_friendlyName;
    NSString *_udn;
    NSInteger _deviceType;
    NSString *_serialNumber;
    UIImage *_icon;
}

/**
 * udn of the device
 */
@property (readonly,copy) NSString *udn;
/**
 * friendly name of the WeMo device
 */
@property (readonly,copy) NSString *friendlyName;
/**
 * device type of the WeMo device
 */
@property (readonly,assign) NSInteger deviceType;
/**
 * serial number of the WeMo device
 */
@property (readonly,copy) NSString *serialNumber;
/**
 * image of the WeMo device.
 */
@property (readonly,nonatomic,copy) UIImage  *icon;

@property(nonatomic,assign)id<WeMoChangedIconDelegate> changeIconDelegate;
@property(nonatomic,assign)id<WeMoChangeFriendlyNameDelegate> changeFriendlyNameDelegate;
@property(nonatomic,assign)id<WeMoRestoreIconDelegate> restoreIconDelegate;
@property(nonatomic,assign)id<WeMoSignalStrengthDelegate> signalStrengthDelegate;

/**
 * This method can be used to change the friendly name of the WeMo device. This is a synchronous method for changing device friendly Name.
 *
 * @param newName : This parameter provides the new friendly name of the device to be set.
 * @returns the result code of the changeFriendlyName API. Please refer WeMoFriendlyNameStatus enum for possible values of result code
 */
-(WeMoFriendlyNameStatus)changeFriendlyNameSynchronously:(NSString*)name;

/**
 * This method can be used to change the friendly name of the WeMo device. This is an asynchronous method and result of this API is
 *      communicated to application through delegate methods of WeMoChangeFriendlyNameDelegate.
 *
 * @param newName : This parameter provides the new friendly name of the device to be set.
 * @returns the result code of the changeFriendlyName API. Please refer WeMoFriendlyNameStatus enum for possible values of result code
 */
-(WeMoFriendlyNameStatus)changeFriendlyNameAsynchronously:(NSString*)name;

/**
 * This method can be used to change the device icon of the WeMo device. This is an asynchronous method and result of this API is
 *      communicated to application through delegate methods of WeMoChangedIconDelegate.
 *
 * @param newName : This parameter provides the new friendly name of the device to be set.
 * @returns None
 */
-(void)changeDeviceIcon:(UIImage*)icon;

/**
 * This method can be used to restore the device icon of WeMo device. This is an asynchronous method and result of this API is
 *      communicated to application through delegate methods of WeMoRestoreIconDelegate.
 *
 * @param None.
 * @returns None
 */
-(void)restorDeviceIcon;

/**
 * This method can be used to get signal strength of WeMo device. This is a synchronous method.
 *
 * @param None.
 * @returns the signal strength of the WeMo device.
 */
-(NSInteger)getSignalStrengthSynchronously;

/**
 * This method can be used to get signal strength of WeMo device. This is an asynchronous method and result of this API is
 *      communicated to application through delegate methods of WeMoSignalStrengthDelegate.
 *
 * @param None.
 * @returns None.
 */
-(void)getSignalStrengthAsynchronously;

/**
 * This method can be used to get ssid of WeMo device. This is a synchronous method.
 *
 * @param None.
 * @returns ssid of the WeMo device.
 */
- (NSString *)getPluginSSID;

/**
 * This method can be used to send additional command to device. This is a synchronous method.
 *
 * @param serviceString : Name of the service containing the UPnP action.
 * @param actionString : UPnP action for communication with device.
 * @param argumentDict : additional argument list if any.
 * @param responseStateValue : This is an output parameter. Developer needs to add all the state variables as keys into this dictionary.
 *          and this methods fills their state result if recieved in response from the device else it fills it with "ERROR" string.
 * @param responseDict : This is an output parameter. This contains all the arguments as key-value pair recevieved as an out from
 *          WeMo device
 * @returns YES if action is post successfully else NO.
 */
- (BOOL)sendMessageToDeviceUsingService:(NSString*)serviceString action:(NSString*)actionString arguments:(NSDictionary*)argumentDict responseStateValue:(NSMutableDictionary*)stateVariableDict andResponseDict:(NSDictionary**)responseDict;

@end
