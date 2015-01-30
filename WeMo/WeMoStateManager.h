//
//  WeMoStateManager.h
//  WeMo_Universal
//
//  Created by Mrigank Gupta on 31/05/12.
//  Copyright (c) 2012 Agnity Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 @brief  WeMoStateManager - This is a singleton class provides methods which should be called whenever there is a change in application state.   */
@interface WeMoStateManager : NSObject

/**
 * WeMoStateManager is a singleton class and this method returns the shared instance of
 *      WeMoStateManager interface.
 *
 * @param None
 * @return a singleton instance of WeMoStateManager interface if success else nil.
 */
+(WeMoStateManager*) sharedWeMoStateManager;

@property(assign)BOOL isEnteredIntoForeground;


/**
 * Application layer should call this method whenever application becomes active.
 *
 * @param application : UIApplication instance.
 * @return None.
 */
- (void)applicationWillResignActive:(UIApplication *)application;


/**
 * Application layer should call this method whenever application goes into background.
 *
 * @param application : UIApplication instance.
 * @return None.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application;


/**
 * Application layer should call this method whenever application enters into foreground.
 *
 * @param application : UIApplication instance.
 * @return None.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application;


/**
 * Application layer should call this method whenever application becomes active.
 *
 * @param application : UIApplication instance.
 * @return None.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application;

@end
