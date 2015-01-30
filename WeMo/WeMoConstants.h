//
//  Header.h
//  WeMo_Universal
//
//  Created by Manish on 22/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef WeMo_Universal_WeMoConstants_h
#define WeMo_Universal_WeMoConstants_h


/**
 * possible sensor device states
 */

enum {
    WeMoDeviceOff = 0,
    WeMoDeviceOn,
    WeMoDeviceUndefinedState
};

typedef NSInteger WeMoDeviceState;

/**
 * response codes for set plugin status API
 */
enum {
    WeMoSetDeviceStatusSuccess = 0,
    WeMoSetDeviceStatusFailed,
    WeMoSetDeviceStatusInvalidDeviceType,
    WeMoSetDeviceInvalidState,
};

typedef NSInteger WeMoSetStateStatus;


// Common for multiple modules
enum {
    WeMoUpnpInterface = 0,
    WeMoInterfaceMax
};

typedef NSInteger WeMoInterfaceList;

/**
 * Possible return values of API's
 */
enum {
    WeMoStatusSuccess = 0,
    WeMoStatusFailed,
    WeMoStatusInvalidAP,
    WeMoStatusInvalidInterfaceType
};

typedef NSInteger WeMoStatus;

/**
 * Network status values
 */
enum {
    WeMoNetworkStatusConnected = 0,
    WeMoNetworkStatusInternetNotConnected,
};
typedef NSInteger WeMoNetworkStatus;



#endif
