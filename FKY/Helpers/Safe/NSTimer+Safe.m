//
//  NSTimer+Safe.m
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//

#import "NSTimer+Safe.h"
#import "YWStubTarget.h"
#import "NSObject+SafeRuntime.h"

@implementation NSTimer (Safe)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 交换类方法
////        [self swizzleClassMethodWithOriginSel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSel:@selector(safe_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
//        // 交换实例方法
////        [self swizzleInstanceMethodWithOriginSel:@selector(initWithFireDate:interval:target:selector:userInfo:repeats:) swizzledSel:@selector(safe_initWithFireDate:interval:target:selector:userInfo:repeats:)];
//    });
//}

//+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
//    if (yesOrNo) {
//        YWStubTarget *stubTarget = [YWStubTarget new];
//        stubTarget.weakTarget = aTarget;
//        stubTarget.weakSelector = aSelector;
//        stubTarget.weakTimer = [self safe_scheduledTimerWithTimeInterval:ti target:stubTarget selector:@selector(fireProxyTimer:) userInfo:userInfo repeats:YES];
//        return stubTarget.weakTimer;
//    } else {
//        return [self safe_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
//    }
//}

//- (instancetype)safe_initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep {
//    if (rep) {
//        YWStubTarget *stubTarget = [YWStubTarget new];
//        stubTarget.weakTarget = t;
//        stubTarget.weakSelector = s;
//        stubTarget.weakTimer = [self safe_initWithFireDate:date interval:ti target:stubTarget selector:@selector(fireProxyTimer:) userInfo:ui repeats:rep];
//        return stubTarget.weakTimer;
//    } else {
//        return [self safe_initWithFireDate:date interval:ti target:t selector:s userInfo:ui repeats:rep];
//    }
//}

@end
