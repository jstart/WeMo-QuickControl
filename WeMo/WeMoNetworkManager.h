//
//  WeMoNetworkManager.h
//  WeMo_Universal
//
//  Created by Manish on 14/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Network connection status values
 */

enum {
    WeMoWiFiNetwork = 0,
    WeMo3GNetwork,
    WeMoNoNetwork
};

typedef NSInteger WeMoNetworkConnectionType;

/**
 * SDK sends wemoNetworkChangeNotification whenever there is a change in network state.
 *
 *  @object an instance of WeMoNetworkManager interface. This can be used further to determine the
 *      the connected Wi-Fi access point.
 */
extern NSString *const wemoNetworkChangeNotification;

/**
 @brief  WeMoNetworkManager - This interface gives information about the network settings. This interface can be used to get the ssid of the connected Wi-Fi router or track any change in the network settings.   */
@interface WeMoNetworkManager : NSObject

/**
 * WeMoNetworkManager is a singleton class and this method returns the shared instance of WeMoNetworkManager interface.
 *
 * @param None
 * @return a singleton instance of WeMoNetworkManager interface if success else nil.
 */
+(WeMoNetworkManager*)sharedWeMoNetworkManager;

/**
 * Releases the memory occupied by WeMoNetworkManager instance.
 *
 * @param None
 * @return None.
 */
+(void)releaseWeMoNetworkManager;

/**
 * accessPoint method can be used to get the ssid of the connected access point. On the basis of
 *      access point, application layer may decide whether to start discovery or start the setup
 *      or may do some other required actions. .
 *
 * @param None.
 * @return the ssid of connected Wi-Fi access point.
 */
-(NSString*)accessPoint;


/**
 * networkConnection method can be used to rertrieve iOS device connection
 *      status(WiFi,3G, No Network etc.)
 *
 * @param None.
 * @return Check WeMoNetworkConnectionType enum for possible return values.
 */
-(WeMoNetworkConnectionType)networkConnection;

@end
