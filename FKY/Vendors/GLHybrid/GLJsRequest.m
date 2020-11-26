//
//  GLJsRequest.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLJsRequest.h"
#import "GLJSON.h"

static NSString *const kGlHybridCallbackIdKey = @"callid";
static NSString *const kGlHybridParamKey = @"param";

@implementation GLJsRequest

@synthesize param = _param;
@synthesize callbackId = _callbackId;
@synthesize methodName = _methodName;

#pragma mark - life cycle

+ (GLJsRequest *)jsRequestFromURL:(NSURL *)url
{
    return [[GLJsRequest alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url
{
    NSString *urlQuery = [url query];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in [urlQuery componentsSeparatedByString:@"&"]) {
        NSArray *tmp = [param componentsSeparatedByString:@"="];
        if (tmp.count < 2) continue;
        [params setObject:tmp.lastObject forKey:tmp.firstObject];
    }
    NSString *callbackId = [params objectForKey:kGlHybridCallbackIdKey];
    NSString *paramStr = [params objectForKey:kGlHybridParamKey];
    NSDictionary *param = nil;
    if (paramStr.length) {
        paramStr = [paramStr stringByRemovingPercentEncoding];
        param = [paramStr gl_JSONObject];
    }
    return [[GLJsRequest alloc] initWithParam:param callbackId:callbackId methodName:url.host];
}

- (instancetype)initWithParam:(NSDictionary *)param
                   callbackId:(NSString *)callbackId
                   methodName:(NSString *)methodName
{
    if (self = [super init]) {
        _param = param;
        _callbackId = callbackId;
        _methodName = methodName;
    }
    return self;
}

#pragma mark - public

- (id)paramForKey:(NSString *)key
{
    if (!key.length || ![key isKindOfClass:NSString.class]) {
        return nil;
    }
    if (![_param.allKeys containsObject:key]) {
        return nil;
    }
    id ret = [_param objectForKey:key];
    if (ret == [NSNull null]) {
        return nil;
    }
    return ret;
}

@end
