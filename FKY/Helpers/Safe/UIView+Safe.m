//
//  UIView+Safe.m
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//

#import "UIView+Safe.h"
#import "NSObject+SafeRuntime.h"
#import "FKYCrashInfoHandler.h"

@implementation UIView (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplay) swizzledSel:@selector(safe_setNeedsDisplay)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplayInRect:) swizzledSel:@selector(safe_setNeedsDisplayInRect:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setNeedsLayout) swizzledSel:@selector(safe_setNeedsLayout)];
    });
}

- (void)safe_setNeedsDisplay {
    if ([NSThread isMainThread]) {
        [self safe_setNeedsDisplay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsDisplay];
        });
        [FKYCrashInfoHandler uploadCrashInfo:@"UIView-safe_setNeedsDisplay"];
    }
}

- (void)safe_setNeedsDisplayInRect:(CGRect)rect {
    if ([NSThread isMainThread]) {
        [self safe_setNeedsDisplayInRect:rect];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsDisplayInRect:rect];
        });
        [FKYCrashInfoHandler uploadCrashInfo:@"UIView-safe_setNeedsDisplayInRect"];
    }
}

- (void)safe_setNeedsLayout {
    if ([NSThread isMainThread]) {
        [self safe_setNeedsLayout];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsLayout];
        });
        [FKYCrashInfoHandler uploadCrashInfo:@"UIView-safe_setNeedsLayout"];
    }
}

@end
