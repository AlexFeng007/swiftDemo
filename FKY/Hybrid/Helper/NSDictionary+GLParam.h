//
//  NSDictionary+GLParam.h
//  YYW
//
//  Created by Rabe on 10/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GLParam)

/**
 根据类类型取字典值

 @param key 键
 @param class 类名
 @return 对应的值
 */
- (id)paramForKey:(NSString *)key defaultValue:(id)defaultValue;
- (id)paramForKey:(NSString *)key defaultValue:(id)defaultValue class:(Class)classType;

/**
 取一般类型的值

 @param key 键
 @param defaultValue 默认值
 @return 对应的值
 */
- (BOOL)boolParamForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (float)floatParamForKey:(NSString *)key defaultValue:(float)defaultValue;
- (NSUInteger)integerParamForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;

@end
