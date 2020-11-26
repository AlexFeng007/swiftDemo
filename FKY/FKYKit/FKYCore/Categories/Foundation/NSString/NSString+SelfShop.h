//
//  NSString+SelfShop.h
//  FKY
//
//  Created by Andy on 2018/8/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SelfShop)

/**
 自营判断接口

 @param shopStr 店铺id
 @return BOOL
 */
+ (BOOL)isSelfShop:(NSString *)shopStr;

@end
