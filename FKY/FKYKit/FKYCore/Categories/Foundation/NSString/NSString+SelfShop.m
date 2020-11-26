//
//  NSString+SelfShop.m
//  FKY
//
//  Created by Andy on 2018/8/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "NSString+SelfShop.h"

@implementation NSString (SelfShop)

+(BOOL)isSelfShop:(NSString *)shopStr{
    NSArray *shopArr = SELF_SHOP_ARRAY;
    for (NSString *shopId in shopArr) {
        if ([shopStr isEqualToString:shopId]) {
            return YES;
        }
    }
    return NO;
}

@end
