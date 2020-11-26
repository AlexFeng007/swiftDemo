//
//  HJLaunch.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJLaunch : NSObject

AS_SINGLETON(HJLaunch)

/**
 *  功能:window显示之前调用
 */
- (void)launchBeforeShowWindowWithOptions:(NSDictionary *)launchOptions;

/**
 *  功能:window显示之后调用
 */
- (void)launchAfterShowWindowWithOptions:(NSDictionary *)launchOptions;

/**
 *  功能:从后台到前台
 */
- (void)launchAfterEnterForeground;

@end
