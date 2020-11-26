//
//  HJUserDefault.h
//  YYW
//
//  Created by 张斌 on 2017/3/9.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJUserDefault : NSObject

/**
 *  存储数据到userdefault
 *
 *  @param anObject 数据
 *  @param aKey     标识
 */
+ (void)setValue:(id)anObject forKey:(NSString *)aKey;
/**
 *  从userdefault获取数据
 *
 *  @param aKey 标识
 *
 *  @return 数据
 */
+ (id)getValueForKey:(NSString *)aKey;

@end
