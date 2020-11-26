//
//  FKYRequest.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYRequest.h"
#import "FKYEnvironment.h"

#import <AFNetworking/AFURLRequestSerialization.h>

@implementation FKYRequest

- (id)initWithURL:(NSURL *)URL
{
    // 默认15秒超时
    return [self initWithURL:URL timeoutInterval:15];
}

- (id)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    if (self) {
        [self setParameterEncoding:FKYJSONParameterEncoding];
        
        // 配置默认的HTTPHeader
        {
            NSString *userAgent = [[FKYEnvironment defaultEnvironment] userAgent];
            NSString *userAgentForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] userAgentForHTTPHeaderField];
            if (userAgent && userAgentForHTTPHeaderField) {
                [self addValue:userAgent forHTTPHeaderField:userAgentForHTTPHeaderField];
            }
            
            NSString *deviceId = [[FKYEnvironment defaultEnvironment] deviceId];
            NSString *deviceIdForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] deviceIdForHTTPHeaderField];
            if (deviceId && deviceIdForHTTPHeaderField) {
                [self addValue:deviceId forHTTPHeaderField:deviceIdForHTTPHeaderField];
            }
            
            NSString *userToken = [[FKYEnvironment defaultEnvironment] userToken];
            NSString *userTokenForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] userTokenForHTTPHeaderField];
            if (userToken && userTokenForHTTPHeaderField) {
                [self addValue:userToken forHTTPHeaderField:userTokenForHTTPHeaderField];
            }
        }
    }
    return self;
}

- (void)setParameterEncoding:(FKYNetworkParameterEncoding)parameterEncoding
{
    _parameterEncoding = parameterEncoding;
    switch (parameterEncoding) {
        case FKYFormURLParameterEncoding:
            [self setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            break;
        case FKYJSONParameterEncoding:
            [self setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            break;
        case FKYPropertyListParameterEncoding:
            [self setValue:@"application/x-plist; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            break;
        default:
            break;
    }
}

- (void)setParameters:(NSDictionary *)parameters
{
    NSString *urlStr = [self.URL absoluteString];
    
    NSMutableURLRequest *urlRequest =
    [[AFHTTPRequestSerializer serializer] requestWithMethod:self.HTTPMethod
                                                  URLString:urlStr
                                                 parameters:parameters
                                                      error:nil];
    
    if ([self.HTTPMethod isEqualToString:@"GET"] || [self.HTTPMethod isEqualToString:@"HEAD"] || [self.HTTPMethod isEqualToString:@"DELETE"]) {
        
        [self setURL:urlRequest.URL];
    } else {
        switch (self.parameterEncoding) {
            case FKYFormURLParameterEncoding:
                //                [self setHTTPBody:urlRequest.HTTPBody]; //TODO
                break;
            case FKYJSONParameterEncoding:
                [self setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:(NSJSONWritingOptions)0 error:nil]];
                break;
            case FKYPropertyListParameterEncoding:
                [self setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:nil]];
                break;
            default:
                break;
        }
    }
}

@end


@implementation FKYGetRequest

- (id)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithURL:URL timeoutInterval:timeoutInterval];;
    if (self) {
        [self setHTTPMethod:@"GET"];
    }
    return self;
}

@end

@implementation FKYPostRequest

- (id)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithURL:URL timeoutInterval:timeoutInterval];;
    if (self) {
        [self setHTTPMethod:@"POST"];
    }
    return self;
}


@end
