//
//  MTLModel+FKYSafeProperty.m
//  FKY
//
//  Created by yangyouyong on 15/11/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "MTLModel+FKYSafeProperty.h"
#import "NSError+MTLModelException.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation MTLModel (FKYSafeProperty)

static BOOL FKY_MTLValidateAndSetValue(id obj, NSString *key, id value, BOOL forceUpdate, NSError **error) {
    // Mark this as being autoreleased, because validateValue may return
    // a new object to be stored in this variable (and we don't want ARC to
    // double-free or leak the old or new values).
    __autoreleasing id validatedValue = value;
    
    @try {
        if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
        if (forceUpdate || value != validatedValue) {
            if (value) {
                [obj setValue:validatedValue forKey:key];
            }
        }
        
        return YES;
    } @catch (NSException *ex) {
        NSLog(@"*** Caught exception setting key \"%@\" : %@", key, ex);
        
        // Fail fast in Debug builds.
#if DEBUG
        @throw ex;
#else
        if (error != NULL) {
            *error = [NSError mtl_modelErrorWithException:ex];
        }
        return NO;
#endif
    }
}


+ (void)load {
//    SEL selectors[] = {
//        @selector(validate:),
//    };
    
//    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
//        SEL originalSelector = selectors[index];
//        SEL swizzledSelector = NSSelectorFromString([@"fky_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
//        
//        Method originalMethod = class_getInstanceMethod(self, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
//        
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
    
    SEL originalSelector = @selector(initWithDictionary:error:);
    SEL swizzledSelector = @selector(init_FKY_WithDictionary:error:);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (instancetype)init_FKY_WithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    self = [self init];
    if (self == nil) return nil;
    
    for (NSString *key in dictionary) {
        // Mark this as being autoreleased, because validateValue may return
        // a new object to be stored in this variable (and we don't want ARC to
        // double-free or leak the old or new values).
        __autoreleasing id value = [dictionary objectForKey:key];
        
        if ([value isEqual:NSNull.null]) value = nil;
        if ([value isKindOfClass:[NSNull class]]){
            value = nil;
        }
        
        BOOL success = FKY_MTLValidateAndSetValue(self, key, value, YES, error);
        if (!success) return nil;
    }
    
    return self;
}

#pragma mark Validation

- (BOOL)fky_validate:(NSError **)error {
    for (NSString *key in self.class.propertyKeys) {
        id value = [self valueForKey:key];
        
        BOOL success = FKY_MTLValidateAndSetValue(self, key, value, NO, error);
        if (!success) return NO;
    }
    
    return YES;
}


@end
