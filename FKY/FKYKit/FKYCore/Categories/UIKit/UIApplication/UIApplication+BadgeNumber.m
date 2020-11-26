//
//  UIApplication+BadgeNumber.m
//  YYW
//
//  Created by Rabe on 31/10/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "UIApplication+BadgeNumber.h"

@implementation UIApplication (BadgeNumber)

#pragma mark - public

- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if (SYSTEM_VERSION_LT(@"8.0")) {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else {
        if ([self checkNotificationType:UIUserNotificationTypeBadge]) {
            NSLog(@"badge number changed to %ld", (long)badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else {
            NSLog(@"access denied for UIUserNotificationTypeBadge");
        }
    }
}

#pragma mark - private

- (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return (currentSettings.types & type);
}

@end
