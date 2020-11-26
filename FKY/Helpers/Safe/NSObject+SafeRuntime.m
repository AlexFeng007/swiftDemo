//
//  NSObject+SafeRuntime.m
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//

#import "NSObject+SafeRuntime.h"

char * const kSafeProtectorName = "kSafeProtector";

id safeProtected(id self, SEL sel) {
    return nil;
}

@implementation NSObject (SafeRuntime)

+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

+ (Class)addMethodToStubClass:(SEL)aSelector {
    Class safeProtector = objc_getClass(kSafeProtectorName);
    
    if (!safeProtector) {
        safeProtector = objc_allocateClassPair([NSObject class], kSafeProtectorName, sizeof([NSObject class]));
        objc_registerClassPair(safeProtector);
    }
    
    class_addMethod(safeProtector, aSelector, (IMP)safeProtected, "@@:");
    return safeProtector;
}

@end
