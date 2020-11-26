//
//  GLBridgeResponse.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridgeResponse.h"
#import "GLJSON.h"

static NSArray *glBridgeRespMsgs;

@implementation GLBridgeResponse

@synthesize errcode = _errcode;
@synthesize data = _data;

#pragma mark - life cycle

+ (void)initialize
{
    glBridgeRespMsgs = @[ @"ok", @"fail", @"unlogin" ];
}

- (instancetype)init
{
    return [self initWithErrorCode:GLBridgeRespCode_WRONG_PARAM errmsg:nil data:nil];
}

- (instancetype)initWithErrorCode:(GLBridgeRespCode)errcode errmsg:(NSString *)errmsg data:(id)data
{
    self = [super init];
    if (self) {
        _errcode = [NSNumber numberWithInt:errcode];
        _errmsg = errmsg.length ? errmsg : [glBridgeRespMsgs objectAtIndex:errcode];
        _data = data;
    }
    return self;
}

+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode
{
    return [[self alloc] initWithErrorCode:errcode errmsg:nil data:nil];
}

+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode data:(id)data
{
    return [[self alloc] initWithErrorCode:errcode errmsg:nil data:data];
}

+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg
{
    return [[self alloc] initWithErrorCode:errcode errmsg:errmsg data:nil];
}

+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg data:(id)data
{
    return [[self alloc] initWithErrorCode:errcode errmsg:errmsg data:data];
}

#pragma mark - public

- (NSString *)callBackParamAsJSONWithId:(NSString *)callbackId
{
    NSDictionary *callbackParam;
    if (_data) {
        callbackParam = @{ @"callid" : @(callbackId.integerValue),
                           @"errcode" : _errcode,
                           @"errmsg" : _errmsg,
                           @"data" : _data };
    }
    else {
        callbackParam = @{ @"callid" : @(callbackId.integerValue),
                           @"errcode" : _errcode,
                           @"errmsg" : _errmsg };
    }

    NSString *parameterJSON = [callbackParam gl_JSONString];
    return parameterJSON;
}

@end
