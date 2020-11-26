//
//  FKYNetworkResponse.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYNetworkResponse : NSObject

// 状态码
@property (nonatomic, strong, readonly) NSNumber *statusCode;

// 解析后的对象
@property (nonatomic, strong, readonly) id modelObject;

// 返回的原始数据，已经过JSON解析
@property (nonatomic, strong, readonly) id originalContent;

// HTTP 's Response
@property (nonatomic, strong, readonly) NSURLResponse *response;

// 错误信息，支持配置statusDict，根据状态码自定义消息
@property (nonatomic, strong, readonly) NSString *errorMessage;

// 是否来自缓存
@property (nonatomic) BOOL isCache;

/**
 *  构造对象
 *
 *  @param code    状态码
 *  @param message 信息
 *
 *  @return FKYNetworkResponse
 */
+ (instancetype)responseWithStatusCode:(NSNumber *)code errorMessage:(NSString *)message;

/**
 *  初始化
 *
 *  @param content    原始内容
 *  @param response   HTTP 's Response
 *  @param modelClass 解码class
 *
 *  @return FKYNetworkResponse
 */
- (instancetype)initWithContent:(id)content
                       response:(NSURLResponse *)response
                     modelClass:(Class)modelClass;

/**
 *  获取Http包头信息中的日期
 *
 *  @return NSDate
 */
- (NSDate *)httpResponseDate;

@end
