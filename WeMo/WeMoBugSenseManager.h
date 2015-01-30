//
//  WeMoBugSenseManager.h
//  BelkinFrameworks
//
//  Created by Manish on 7/5/13.
//  Copyright (c) 2013 Belkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeMoBugSenseManager;

/**
 @brief  WeMoBugSenseDelegate - This protocol defines the required methods implemented by delegates of WeMoBugSenseManager object.   */
@protocol WeMoBugSenseDelegate <NSObject>
@optional

/**
 * This is the required method needs to be implemented by the delegate. Delegate receives
 *      this message whenever some exception occured while excuting a SDK method. 
 *
 * @param manager : BugSense Manager Instance sending the message
 *        data : A dictionary object containing details of exception.
 * @return None.
 */
-(void)bugSenseManager:(WeMoBugSenseManager*)manager exceptionWithData:(NSDictionary*)data;

@end

/**
 @brief  WeMoBugSenseManager - This interface can be used by application developer to log  exception occurred in SDK methods.   */
@interface WeMoBugSenseManager : NSObject

@property(nonatomic,assign)id<WeMoBugSenseDelegate> bugSenseDelegate;

/**
 * WeMoBugSenseManager is a singleton class and this method returns the shared instance of WeMoBugSenseManager interface.
 *
 * @param None
 * @return a singleton instance of WeMoBugSenseManager interface if success else nil.
 */
+(WeMoBugSenseManager*)sharedWeMoBugSenseManager;

/**
 * Releases the memory occupied by WeMoBugSenseManager instance.
 *
 * @param None
 * @return None.
 */
+(void)releaseWeMoBugSenseManager;

@end
