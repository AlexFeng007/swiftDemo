//
//  HJNetworkQuery.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJQueryPair : NSObject

@property (readwrite, nonatomic, strong) id key;
@property (readwrite, nonatomic, strong) id value;

/**
 *  功能:初始化方法
 */
- (id)initWithKey:(id)aKey value:(id)aValue;

/**
 *  功能:将键值对转化为用"="连接的拼装字符串，并且进行url编码
 */
- (NSString *)URLEncodedStringWithEncoding:(NSStringEncoding)aStringEncoding;

/**
 *  功能:将键值对转化为用"="连接的拼装字符串，不进行url编码
 */
- (NSString *)queryString;

/**
 *  功能:比较方法，根据key进行比较
 */
- (NSComparisonResult)caseInsensitiveCompare:(HJQueryPair *)aQueryPair;

@end

@interface HJNetworkQuery : NSObject

/**
 *  功能:将接口参数dictionary转化为用"&"连接的拼装字符串，并进行url编码
 */
+ (NSString *)queryStringFromParameters:(NSDictionary *)aParameters
                               encoding:(NSStringEncoding)aStringEncoding;

+ (NSArray *)queryPairsFromDictionary:(NSDictionary *)dictionary;

@end
