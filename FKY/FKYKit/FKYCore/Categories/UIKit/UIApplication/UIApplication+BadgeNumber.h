//
//  UIApplication+badgeNumber.h
//  YYW
//
//  Created by Rabe on 31/10/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BadgeNumber)

/**
 设置角标前先判断权限问题(解决iOS8之后一些闪退问题)

 @param badgeNumber 角标数值
 */
- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber;

@end
