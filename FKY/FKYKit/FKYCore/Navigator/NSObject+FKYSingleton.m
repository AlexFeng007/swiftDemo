//
//  NSObject+FKYSingleton.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "NSObject+FKYSingleton.h"
#import "FKYTabBarController.h"


@implementation NSObject (FKYSingleton)

+ (BOOL)isAlreadyInStackForPop
{
    if ([self isSubclassOfClass:[FKYSearchViewController class]]) {
        return YES;
    }
    return NO;
}

@end
