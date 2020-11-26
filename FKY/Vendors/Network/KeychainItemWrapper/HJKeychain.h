//
//  HJKeychain.h
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJKeychain : NSObject
/**
 *  只能set基本数据类型,NSNumber,NSString,NSData,NSDate等,不能set继承的Class
 *
 *  @param value
 *  @param type
 */
+ (void)setKeychainValue:(id<NSCopying, NSObject>)value forType:(NSString *)type;
+ (id)getKeychainValueForType:(NSString *)type;
+ (void)reset;

@end
