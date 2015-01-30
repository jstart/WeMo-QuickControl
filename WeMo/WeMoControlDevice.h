//
//  WeMoControlDevice.h
//  WeMo_Universal
//
//  Created by Manish Singhal on 07/12/12.
//
//


#import "WeMoConstants.h"
#import "WeMoDevice.h"

/**
 * error codes for restore setting API
 */
enum {
    WeMoRestoreIconFailed = 0,
    WeMoRestoreNameFailed,
    WeMoRestoreNameAndIconFailed,
    WeMoRestoreSettingsFailed,
};

typedef NSInteger WeMoRestoreSettingsErrorCodes;

@class WeMoControlDevice;

/**
 @brief  WeMoRestoreSettingsDelegate - This protocol defines the required methods implemented by delegates of WeMoControlDevice object.   */
@protocol WeMoRestoreSettingsDelegate <NSObject>
@required

/**
 * This is the required method needs to be implemented by the delegate. Once the delegate receives
 *      this message, delegate will not receive any further message corresponding
 *      to restoreSettings method of this interface
 *
 * @param device : WeMoControlDevice Instance sending the message
 *        error : An error object giving more information of the failiure. Please refer enum WeMoRestoreSettingsErrorCodes for more details
 * @return None.
 */
-(void)restoreSettings:(WeMoControlDevice*)device didFailedToRestoreSettings:(NSError*)error;

/**
 * This is the required method needs to be implemented by the delegate. Once the delegate receives
 *      this message, delegate will not receive any further message corresponding
 *      to restoreSettings method of this interface
 *
 * @param device : WeMoControlDevice Instance sending the message
 * @return None.
 */
-(void)didRestoreSettingsSuccessfully:(WeMoControlDevice*)device;


@end

/**
 @brief  WeMoRestoreToFactoryDefaultDelegate - This protocol defines the required methods implemented by delegates of WeMoControlDevice object.   */
@protocol WeMoRestoreToFactoryDefaultDelegate <NSObject>
@required

/**
 * This is the required method needs to be implemented by the delegate. Once the delegate receives
 *      this message, delegate will not receive any further message corresponding
 *      to resetToFactoryDefaultAsynchronously method of this interface.This method informs the resetToFactoryDefaultAsynchronously fails.
 *
 * @param device : WeMoControlDevice Instance sending the message
 * @return None.
 */
-(void)didFailedToFactoryDefaultSettings:(WeMoControlDevice*)device;

/**
 * This is the required method needs to be implemented by the delegate. Once the delegate receives
 *      this message, delegate will not receive any further message corresponding
 *      to resetToFactoryDefaultAsynchronously method of this interface. This method informs the resetToFactoryDefaultAsynchronously executed successfully.
 *
 * @param device : WeMoControlDevice Instance sending the message
 * @return None.
 */
-(void)didRestoreToFactoryDefaultSuccessfully:(NSString*)deviceUdn;


@end

/**
 @brief  WeMoControlDevice - A WeMoControlDevice object provides information about the wemo devices. It gives information regarding firmware version, mac address, state, etc..   */
@interface WeMoControlDevice : WeMoDevice {
@private
    WeMoDeviceState _state;
}

@property(nonatomic,assign)id<WeMoRestoreSettingsDelegate> restoreSettingsDelegate;
@property(nonatomic,assign)id<WeMoRestoreToFactoryDefaultDelegate> restoreToFactoryDefaultDelegate;

/**
 * firmware version of the device
 */
@property (readonly,copy) NSString *firmwareVersion;
/**
 * state of the device
 */
@property (nonatomic, assign) WeMoDeviceState state;
/**
 * mac address of the device
 */
@property (readonly,copy) NSString *macAddr;

/**
 * This method is change the state of the WeMo device. User can switch on/off the switch by using
 *      this API..
 *
 * @param newState : This parameter provides the new state of the device to be set. Please refer
 *      WeMoDeviceState enum for further information about the possible states..
 * @returns the result code of the setPluginStatus API. Please refer WeMoSetStateStatus enum for
 *      possible values of result code
 */
- (WeMoSetStateStatus)setPluginStatus:(WeMoDeviceState)newState;

/**
 * This method is used  to factory restore the WeMo device. This is an asynchronous method and
 *      result of this API is communicated to application through delegate methods of restoreToFactoryDefaultDelegate..
 *
 * @param None.
 * @returns None.
 */
- (void)resetToFactoryDefaultAsynchronously;

/**
 * This method is used  to factory restore the WeMo device. This is an synchronous method.
 *
 * @param None.
 * @returns None.
 */
- (BOOL)resetToFactoryDefaultSynchronously;

/**
 * This method is used  to restore settings of the WeMo device. This method clears the friendlyname, icon and rule information
 *      from the device. This is an asynchronous method and result of this API is communicated to application through
 *      delegate methods of restoreSettingsDelegate..
 *
 * @param None.
 * @returns None.
 */
- (void)restoreSettings; //async method

@end

