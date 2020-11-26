//
//  NSObject+Safe.m
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//

#import "NSObject+Safe.h"
#import "NSObject+SafeRuntime.h"
#import "FKYCrashInfoHandler.h"

@implementation NSObject (Safe)

+ (void)load {
#if DEBUG
#else
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(forwardingTargetForSelector:) swizzledSel:@selector(safe_forwardingTargetForSelector:)];
    });
#endif
}

- (id)safe_forwardingTargetForSelector:(SEL)aSelector {
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if (aBool || signatrue) {
        return [self safe_forwardingTargetForSelector:aSelector];
    }
    
    NSLog(@"Crash...[Class:%@, Selector:%@]", [self class], NSStringFromSelector(aSelector));
    //[kAppDelegate showToast:@"应用出现了一些小问题，可能会影响您的正常使用，请结束应用后重新启动"];
    
    // 上报crash信息
    [FKYCrashInfoHandler uploadCrashInfo:STRING_FORMAT(@"catch unrecognize selector crash:[Class:%@-%@]-[Selector:%@]-[pagecode:%@]",[self class],self, NSStringFromSelector(aSelector),[[UIApplication sharedApplication].keyWindow.currentViewController ViewControllerPageCode])];
    
    Class safeProtector = [NSObject addMethodToStubClass:aSelector];
    if (!self.safe) {
        self.safe = [safeProtector new];
    }
    return self.safe;
}

- (void)setSafe:(id)safe {
    objc_setAssociatedObject(self, @selector(safe), safe, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)safe {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidRegisteredNotificationCenter:(BOOL)didRegisteredNotificationCenter {
    objc_setAssociatedObject(self, @selector(didRegisteredNotificationCenter), @(didRegisteredNotificationCenter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)didRegisteredNotificationCenter {
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    return result.boolValue;
}

@end
