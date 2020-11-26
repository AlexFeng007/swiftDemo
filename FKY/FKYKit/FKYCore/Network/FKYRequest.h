//
//  FKYRequest.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义请求参数编码类型
typedef NS_ENUM(NSInteger, FKYNetworkParameterEncoding) {
    FKYFormURLParameterEncoding,
    FKYJSONParameterEncoding,
    FKYPropertyListParameterEncoding,
};

@interface FKYRequest : NSMutableURLRequest

@property (nonatomic, assign) FKYNetworkParameterEncoding parameterEncoding;
@property (nonatomic, strong) NSDictionary *parameters;

- (id)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval;
@end


/**
 *  GET
 */
@interface FKYGetRequest : FKYRequest

@end


/**
 *  POST
 */
@interface FKYPostRequest : FKYRequest


@end
