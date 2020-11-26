//
//  NSObject+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/12/8.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "NSObject+FKYKit.h"

@implementation NSObject (FKYKit)

- (id)fky_safeString
{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self;
}

@end
