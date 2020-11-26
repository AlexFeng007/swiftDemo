//
//  UIWindow+Hierarchy.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/16.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIWindow+Hierarchy.h"

@implementation UIWindow (Hierarchy)

- (UIViewController *)topMostController
{
    UIViewController *topController = [self rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

- (UIViewController *)currentViewController;
{
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

+ (UIWindow *)getTopWindowForAddSubview
{
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for (UIWindow *window in [windows reverseObjectEnumerator]) {
//        if ([window isKindOfClass:[UIWindow class]] == YES &&
//            window.hidden == NO &&
//            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
//            return window;
//    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
