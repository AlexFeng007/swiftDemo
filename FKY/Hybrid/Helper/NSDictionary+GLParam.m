//
//  NSDictionary+GLParam.m
//  YYW
//
//  Created by Rabe on 10/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "NSDictionary+GLParam.h"

@implementation NSDictionary (GLParam)

- (id)paramForKey:(NSString *)key defaultValue:(id)defaultValue
{
    return [self paramForKey:key defaultValue:defaultValue class:nil];
}

- (id)paramForKey:(NSString *)key defaultValue:(id)defaultValue class:(Class)classType
{
    if (!key.length || ![key isKindOfClass:NSString.class]) {
        return nil;
    }
    if (![self.allKeys containsObject:key]) {
        return nil;
    }
    
    id ret = [self objectForKey:key];
    if (ret == [NSNull null]) {
        ret = defaultValue;
    }
    if (classType != nil && ![ret isKindOfClass:classType]) {
        ret = defaultValue;
    }
    return ret;
}

- (NSUInteger) integerParamForKey : (NSString *) key defaultValue : (NSUInteger) defaultValue
{
    if (!key.length || ![key isKindOfClass:NSString.class]) {
        return defaultValue;
    }
    if (![self.allKeys containsObject:key]) {
        return defaultValue;
    }
    id ret = [self objectForKey:key];
    if (ret == [NSNull null]) {
        return defaultValue;
    }
    if ([ret isKindOfClass:NSNumber.class]) {
        return [ret integerValue];
    }
    return defaultValue;
}

- (BOOL)boolParamForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    if (!key.length || ![key isKindOfClass:NSString.class]) {
        return defaultValue;
    }
    if (![self.allKeys containsObject:key]) {
        return defaultValue;
    }
    id ret = [self objectForKey:key];
    if (ret == [NSNull null]) {
        return defaultValue;
    }
    if ([ret isKindOfClass:NSNumber.class] || [ret isKindOfClass:NSString.class]) {
        return [ret boolValue];
    }
    return defaultValue;
}

- (float)floatParamForKey:(NSString *)key defaultValue:(float)defaultValue
{
    if (!key.length || ![key isKindOfClass:NSString.class]) {
        return defaultValue;
    }
    if (![self.allKeys containsObject:key]) {
        return defaultValue;
    }
    id ret = [self objectForKey:key];
    if (ret == [NSNull null]) {
        return defaultValue;
    }
    if ([ret isKindOfClass:NSNumber.class]) {
        return [ret floatValue];
    }
    return defaultValue;
}

@end
