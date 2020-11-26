//
//  NSDictionary+FKYKit.h
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FKYKit)

- (NSArray *)FKYKeyValueDictionaryPair;

/**
 *  将dict key value 转换成 @"key=value"的字符串数组
 *
 *  @return 转换成功的字符串数组
 */
- (NSArray *)FKYKeyValueStringFormattedPair;

/**
 *  key value pair json string
 *
 *  @return key value pair json string
 */
- (NSString *)jsonString;


@end
