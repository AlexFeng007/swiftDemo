//
//  FKYKeyboardManager.h
//  FKY
//
//  Created by yangyouyong on 15/10/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYKeyboardManager : NSObject

/**
 *  单例对象
 *
 *  @return 
 */
+ (FKYKeyboardManager *)defaultManager;

@property (nonatomic, assign, readonly) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic, assign, readonly) CGFloat keyboardHeight;

- (BOOL)fky_keyboardDidAppear;

@end
