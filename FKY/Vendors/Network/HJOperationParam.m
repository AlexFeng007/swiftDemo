//
//  HJOperationParam.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJOperationParam.h"
#import "HJNetworkManager.h"
#import <AFNetworking/AFNetworking.h>

// 正式环境
static NSString *defaultInterfaceUrlHost = @"https://gateway-b2b.fangkuaiyi.com";
// BI埋点
static NSString *biHost = @"http://nest.111.com.cn";


@interface HJOperationParam ()

#pragma mark - 拼装requestUrl相关
@property (nonatomic, copy) NSString *businessName; //业务名
@property (nonatomic, copy) NSString *methodName;   //方法名
@property (nonatomic, copy) NSString *versionNum;   //版本，如"v2.3"

#pragma mark - 接口调用相关
@property (nonatomic, copy) NSString *requestUrl;         //请求url
@property (nonatomic, assign) ERequestType requestType;   //请求类型，post还是get方式，默认为post方式
@property (nonatomic, strong) NSDictionary *requestParam; //参数

#pragma mark - 接口错误相关
@property (nonatomic, assign) BOOL rerunForTokenExpire;   //是否token过期自动登录后再次执行，默认为NO
@property (nonatomic, assign) BOOL rerunForSignKeyExpire; //是否重新调用获取密钥接口后再次执行，默认为NO
@property (nonatomic, assign) BOOL rerunForLaunchFail;    //是否重新调用启动接口后再次执行，默认为NO
@property (nonatomic, copy) NSString *usedToken;          //记录当前请求使用的token

#pragma mark - 接口日志相关
@property (nonatomic, assign) NSTimeInterval startTimeStamp; //接口调用开始时间，精确到ms
@property (nonatomic, assign) NSTimeInterval endTimeStamp;   //接口调用结束时间，精确到ms
@property (nonatomic, assign) NSInteger errorType;           //接口错误类型(0无错误，1接口超时，2接口出错，3rtn_code不为0)
@property (nonatomic, assign) NSString *errorCode;           //接口错误码

@end


@implementation HJOperationParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needSignature = YES;
        self.needEncoderToken = NO;
        self.retryTimes = 0;
        self.cacheTime = 0;
        self.timeoutTime = 30; // 设置超时...<adapter>

        self.rerunForTokenExpire = NO;
        self.rerunForLaunchFail = NO;
        self.alertError = NO;
        self.showErrorView = NO;
    }
    return self;
}

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithBusinessName:(NSString *)aBusinessName
                           methodName:(NSString *)aMethodName
                           versionNum:(NSString *)aVersionNum
                                 type:(ERequestType)aType
                                param:(NSDictionary *)aParam
                             callback:(HJCompletionBlock)aCallback
{
    HJOperationParam *param = [self new];
    param.businessName = aBusinessName;
    param.methodName = aMethodName;
    param.versionNum = aVersionNum;
    param.timeoutTime = 30; // adapter接口设置超时
    param.requestType = aType;
    param.requestParam = aParam ? aParam : [NSMutableDictionary dictionary];
    param.callbackBlock = aCallback;
    
    NSString *domain = param.currentDomain;
    if (aVersionNum.length > 0) {
        param.requestUrl = [NSString stringWithFormat:@"http://10.6.57.21:8085/%@/%@", aBusinessName, aMethodName];
    }
    else {
        param.requestUrl = [NSString stringWithFormat:@"%@/%@/%@", domain, aBusinessName, aMethodName];
    }
    
    // [App启动时 or 特殊接口]设置较短的超时时长
    if ([aBusinessName isEqualToString:@"mobile/home"] && [aMethodName isEqualToString:@"advertisement"]) {
        // 单独针对开屏广告的接口设置超时
        param.timeoutTime = 4;
    }
    if ([aBusinessName isEqualToString:@"ypassport"] && [aMethodName isEqualToString:@"app_check_up"]) {
        // 版本更新检查
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"ypassport"] && [aMethodName isEqualToString:@"refresh_token"]) {
        // 刷新token
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"api/cart"] && [aMethodName isEqualToString:@"productsCount"]) {
        // 购物车中商品数量
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"home/recommend"] && [aMethodName isEqualToString:@"mix"]) {
        // 常购清单
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"mobile"] && [aMethodName isEqualToString:@"getkey"]) {
        // 获取密钥
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"usermanage/enterpriseInfo"] && [aMethodName isEqualToString:@"getAuditStatus.json"]) {
        // 资质审核状态
        param.timeoutTime = 8;
    }
    if ([aBusinessName isEqualToString:@"mobile"] && [aMethodName isEqualToString:@"statpage"]) {
        // ??
        param.timeoutTime = 8;
    }
    else if ([aBusinessName isEqualToString:@"tms/address"] &&
             ([aMethodName isEqualToString:@"getAddressByParentCodeAndLevel"]
              || [aMethodName isEqualToString:@"getUpdatedAddress"])) {
        // 单独针对四级地址的接口设置超时
        param.timeoutTime = 8;
    }
    
    NSLog(@"requestUrl:%@", param.requestUrl);
    return param;
}

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithUrl:(NSString *)aUrl
                        type:(ERequestType)aType
                       param:(NSDictionary *)aParam
                    callback:(HJCompletionBlock)aCallback
{
    HJOperationParam *param = [self new];
    param.requestUrl = aUrl;
    param.requestType = aType;
    param.requestParam = aParam ? aParam : [NSMutableDictionary dictionary];
    param.callbackBlock = aCallback;

    //for print log
    param.methodName = aUrl;

    return param;
}

/**
 *  功能:获取当前请求url
 */
+ (NSString *)getRequestUrl:(NSString *)aBusinessName
                 methodName:(NSString *)aMethodName
                 versionNum:(NSString *)aVersionNum
{
    NSString *url = nil;
    if (aVersionNum && aVersionNum.length > 0) {
        url = [NSString stringWithFormat:@"%@/%@/%@/%@", defaultInterfaceUrlHost, aBusinessName, aMethodName, aVersionNum];
    }
    else {
        url = [NSString stringWithFormat:@"%@/%@/%@", defaultInterfaceUrlHost, aBusinessName, aMethodName];
    }
    return url;
}

/**
 *  功能:当前域名
 */
- (NSString *)currentDomain
{
    return defaultInterfaceUrlHost;
}


#pragma mark - Optimize

/**
 *  功能:初始化方法<简化版>
 */
+ (instancetype)paramWithApiName:(NSString *)api
                            type:(ERequestType)type
                           param:(NSDictionary *)param
                        callback:(HJCompletionBlock)callback
{
    // 超时...<默认30s> 
    NSTimeInterval timeout = 30;
    // 接口过滤
    if ([api isEqualToString:@"mobile/home/advertisement"]) {
        // 单独针对开屏广告的接口设置超时
        timeout = 4;
    }
    else if ([api isEqualToString:API_REGISTER_ADDRESS_GET_PROVINCE] ||
             [api isEqualToString:API_REGISTER_ADDRESS_GET_CITY] ||
             [api isEqualToString:API_REGISTER_ADDRESS_GET_DISTRICT] ||
             [api isEqualToString:API_REGISTER_ADDRESS_QUERY_NAME_CODE]) {
        // (三级)注册地址
        timeout = 8;
    }
    else if ([api isEqualToString:API_NO_READ_COUNT]) {
        // [IM相关]获取未读消息数
        timeout = 8;
    }
    else if ([api isEqualToString:API_RED_PACKET_SHOW]) {
        // [红包相关]检查是否显示红包
        timeout = 8;
    }
    
    // 请求相关对象
    HJOperationParam *oParam = [self new];
    oParam.requestUrl = [NSString stringWithFormat:@"%@/%@", oParam.currentDomain, api];
    oParam.requestType = type;
    oParam.requestParam = param ? param : [NSMutableDictionary dictionary];
    oParam.callbackBlock = callback;
    oParam.timeoutTime = timeout;
    return oParam;
}

+ (NSString *)gerRequestUrl:(NSString *)api
{
    if (api && api.length > 0) {
        return [NSString stringWithFormat:@"%@/%@", defaultInterfaceUrlHost, api];
    }
    else {
        return defaultInterfaceUrlHost;
    }
}
    
/**
 *  功能: BI埋点初始化方法<简化版>
 */
+ (instancetype)paramWithBiUrl:(NSString *)url
                          type:(ERequestType)type
                         param:(NSDictionary *)param
                      callback:(HJCompletionBlock)callback
{
    // 请求相关对象
    HJOperationParam *oParam = [self new];
    oParam.requestUrl = url; // biHost
    oParam.requestType = type;
    oParam.requestParam = param ? param : [NSMutableDictionary dictionary];
    oParam.callbackBlock = callback;
    oParam.timeoutTime = 10;
    return oParam;
}

    
@end
