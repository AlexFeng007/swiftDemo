//
//  FKYBaseService.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"
#import "FKYBaseModel.h"
#import "FKYCore.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>
#import "NSDictionary+FKYKit.h"
#import "FKYNetworkManager.h"
#import "NSDictionary+URL.h"
#import "FKYLoginAPI.h"
#import "UIDevice+Hardware.h"
#import "FKYHOST.h"


@implementation FKYBaseService


#pragma mark - url

- (NSString *)mainAPI
{
    return FKY_NORMAL_API;
}

- (NSString *)manageAPI
{
    return MANAGE_HOST;
}

- (NSString *)mallAPI
{
    return MALL_HOST;
}

- (NSString *)passportAPI
{
    return PASSPORT_HOST;
}

- (NSString *)payAPI
{
    return  PAY_HOST;
}

- (NSString *)druggmpAPI
{
    return DRUGGMP_HOST;
}

- (NSString *)imageAPI
{
    return P8_HOST;
}

- (NSString *)imageCodeAPI
{
    return IMAGE_CODE_HOST;
}

- (NSString *)messageCodeAPI
{
    return MESSAGE_HOST;
}

- (NSString *)orderAPI
{
    return ORDER_HOST;
}

- (NSString *)MAPI
{
    return M_HOST;
}

- (NSString *)usermanageReleaseAPI
{
    return USERMANAGE_HOST;
}

- (NSString *)logisticsReleaseAPI
{
    return LOGICTICS_HOST;
}

- (NSString *)host:(NSString *)host appdengingAPI:(NSString *)apiUrl
{
    return [host stringByAppendingString:apiUrl];
}

- (NSString *)requestUrl:(NSString *)url
{
    NSString *request = [self host:[self orderAPI] appdengingAPI:url];
    return request;
}

- (NSString *)requestUserUrl:(NSString *)url
{
    // 此处用户相关域名切换， 上线前记得切换FKYHOST.h 文件
    NSString *request = [self host:[self usermanageReleaseAPI] appdengingAPI:url];
    return request;
}

- (NSString *)requestLogisticsUrl:(NSString *)url
{
    // 此处用户相关域名切换， 上线前记得切换FKYHOST.h 文件
    NSString *request = [self host:[self logisticsReleaseAPI] appdengingAPI:url];
    return request;
}

- (NSString *)requestPayUrl:(NSString *)url
{
    //NSString *request = [self host:[self payAPI] appdengingAPI:url];
    NSString *request = [self host:[self orderAPI] appdengingAPI:url];
    return request;
}


#pragma mark - 网路相关

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYFailureBlock)failure
{
    return [[FKYNetworkManager defaultManager] GET:URLString parameters:parameters decodeClass:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        NSLog(@"URLString:%@", URLString);
        //NSLog(@"response:%@", response.originalContent);
        [self p_vaildResponse:response requestUrl:URLString requestParam:parameters success:success failure:failure];
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        if ([error.localizedDescription hasPrefix:@"The operation couldn’t"]) {
            NSError *error = [self p_handleErrorWithMessage:@"网络不给力，请检查网络"];
            safeBlock(failure, error.domain);
        }
        else {
            safeBlock(failure, error.localizedDescription);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYFailureBlock)failure
{
    return [self POST:URLString body:parameters success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        NSLog(@"URLString:%@", URLString);
        NSLog(@"response:%@", response.originalContent);
        [self p_vaildResponse:response requestUrl:URLString requestParam:parameters success:success failure:failure];
    } failure:^(NSString *reason) {
        if ([reason containsString:@"data is nil"]) {
            safeBlock(failure, @"失败");
            return;
        }
        safeBlock(failure, reason);
    }];
}

// New
- (NSURLSessionDataTask *)PostRequst:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                             success:(FKYNetworkSuccessBlock)success
                             failure:(FKYRequestFailureBlock)failure
{
    return [self PostMethod:URLString body:parameters success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        NSLog(@"URLString:%@", URLString);
        NSLog(@"response:%@", response.originalContent);
        [self p_vaildResponseMethod:response requestUrl:URLString requestParam:parameters success:success failure:failure];
    } failure:^(NSString *reason, id data) {
        if ([reason containsString:@"data is nil"]) {
            safeBlock(failure, @"失败", data);
            return;
        }
        safeBlock(failure, reason, data);
    }];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYFailureBlock)failure
{
    return [[FKYNetworkManager defaultManager] PUT:URLString parameters:parameters success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        [self p_vaildResponse:response requestUrl:URLString requestParam:parameters success:success failure:failure];
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        safeBlock(failure, error.localizedDescription);
    }];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(FKYNetworkSuccessBlock)success
                         failure:(FKYFailureBlock)failure
{
    return [[FKYNetworkManager defaultManager] DELETE:URLString parameters:parameters success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        [self p_vaildResponse:response requestUrl:URLString requestParam:parameters success:success failure:failure];
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        safeBlock(failure, error.localizedDescription);
    }];
}


#pragma mark -

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          body:(id)body
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYFailureBlock)failure
{
    return [self p_requestURLString:URLString method:@"POST" body:body success:success failure:failure];
}

// New
- (NSURLSessionDataTask *)PostMethod:(NSString *)URLString
                                body:(id)body
                             success:(FKYNetworkSuccessBlock)success
                             failure:(FKYRequestFailureBlock)failure
{
    return [self p_requestUrl:URLString method:@"POST" body:body success:success failure:failure];
}


#pragma mark -

// New...<固定套餐开发时新增>
// 不再校验返回数据，而是交由各业务接口自行判断
- (NSURLSessionDataTask *)PostNew:(NSString *)URLString
                      requestBody:(id)body
                          success:(FKYNetworkSuccessBlock)success
                          failure:(FKYRequestFailureBlock)failure
{
    return [self p_requestWithUrl:URLString method:@"POST" body:body success:success failure:failure];
}


#pragma mark - Final Request

/**
 *  发出带有json body的请求...<Old>...<最初的方法>...<不便于扩展>
 *
 *  @param URLString
 *  @param method
 *  @param body
 *  @param success
 *  @param failure
 *
 *  @return
 */
- (NSURLSessionDataTask *)p_requestURLString:(NSString *)URLString
                                      method:(NSString *)method
                                        body:(NSDictionary *)body
                                     success:(FKYNetworkSuccessBlock)success
                                     failure:(FKYFailureBlock)failure
{
    NSMutableURLRequest *urlRequest = [self getUrlRequest:URLString method:method body:body];
    return [[FKYNetworkManager defaultManager] request:urlRequest decodeClass:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        // 请求成功
        // 每次接口请求成功，均需要检测返回数据的合法性~!@
        [self p_vaildResponse:response requestUrl:URLString requestParam:body success:success failure:failure];
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        // 请求失败
        if (error.code == -1004) {
          safeBlock(failure, [self p_handleErrorWithMessage:@"似乎已断开与互联网的连接"].domain);
          return;
        }
        safeBlock(failure, error.localizedDescription);
    }];
}

/**
 *  发出带有json body的请求...<New>...<后来增加的方法>...<(操作)失败后不仅仅要返回message,还需要返回对应的data>
 *
 *  @param URLString
 *  @param method
 *  @param body
 *  @param success
 *  @param failure
 *
 *  @return
 */
- (NSURLSessionDataTask *)p_requestUrl:(NSString *)URLString
                                method:(NSString *)method
                                  body:(NSDictionary *)body
                               success:(FKYNetworkSuccessBlock)success
                               failure:(FKYRequestFailureBlock)failure
{
    NSMutableURLRequest *urlRequest = [self getUrlRequest:URLString method:method body:body];
    return [[FKYNetworkManager defaultManager] request:urlRequest decodeClass:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        // 请求成功
        // 每次接口请求成功，均需要检测返回数据的合法性~!@
        [self p_vaildResponseMethod:response requestUrl:URLString requestParam:body success:success failure:failure];
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        // 请求失败
        if (error.code == -1004) {
            safeBlock(failure, [self p_handleErrorWithMessage:@"似乎已断开与互联网的连接"].domain, nil);
            return;
        }
        safeBlock(failure, error.localizedDescription, nil);
    }];
}

/**
 *  发出带有json body的请求...<New>...<固定套餐增加的方法>...<不再校验返回数据，而是交由各业务接口自行判断>...<接口请求成功不再仅仅用0/1来表示>
 *
 *  @param URLString
 *  @param method
 *  @param body
 *  @param success
 *  @param failure
 *
 *  @return
 */
- (NSURLSessionDataTask *)p_requestWithUrl:(NSString *)URLString
                                    method:(NSString *)method
                                      body:(NSDictionary *)body
                                   success:(FKYNetworkSuccessBlock)success
                                   failure:(FKYRequestFailureBlock)failure
{
    /*
     statusCode:
     200000000:"成功"; 200000001:"失败"; 200000002:"系统异常"; 200000003:"登陆超时"; 200000004:"非法参数"; 200140009:可以加车成功但套餐数量不能全部满足"; 200140015:最多只能添加200个品种，请先下单";
    */
    
    NSMutableURLRequest *urlRequest = [self getUrlRequest:URLString method:method body:body];
    return [[FKYNetworkManager defaultManager] request:urlRequest decodeClass:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        // 请求成功
        safeBlock(success, nil, response);
    } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
        // 请求失败
        if (error.code == -1004) {
            safeBlock(failure, [self p_handleErrorWithMessage:@"似乎已断开与互联网的连接"].domain, nil);
            return;
        }
        safeBlock(failure, error.localizedDescription, nil);
    }];
}


#pragma mark - Url

// 生成最终的urlrequest
- (NSMutableURLRequest *)getUrlRequest:(NSString *)url
                                method:(NSString *)method
                                  body:(NSDictionary *)body
{
    AFHTTPRequestSerializer *serializer = nil;
    // 不了解之前有多少接口，所以先把正常的作为特例对待，以后都是form-urlencoded格式
    if ([url containsString:@"getui/saveClientInfo"] ||
        [url containsString:@"cart/reBuyOrder"] ||
        [url containsString:@"fusonPay/confirmFosunPay"]) {
        serializer = [AFHTTPRequestSerializer serializer];
        [serializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    else {
        serializer = [AFJSONRequestSerializer serializer];
        if ([url containsString:@"getAppWechatPayParams"]) {
            [serializer setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        }
        else {
            [serializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
    //
    NSString *userAgent = [[FKYEnvironment defaultEnvironment] userAgent];
    NSString *userAgentForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] userAgentForHTTPHeaderField];
    if (userAgent && userAgentForHTTPHeaderField) {
        [serializer setValue:userAgent forHTTPHeaderField:userAgentForHTTPHeaderField];
    }
    
    // deviceid
    NSString *deviceId = [[FKYEnvironment defaultEnvironment] deviceId];
    NSString *deviceIdForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] deviceIdForHTTPHeaderField];
    if (deviceId && deviceIdForHTTPHeaderField) {
        [serializer setValue:deviceId forHTTPHeaderField:deviceIdForHTTPHeaderField];
    }
    
    // token
    NSString *userToken = [[FKYEnvironment defaultEnvironment] userToken];
    NSString *userTokenForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] userTokenForHTTPHeaderField];
    if (userToken && userTokenForHTTPHeaderField) {
        [serializer setValue:userToken forHTTPHeaderField:userTokenForHTTPHeaderField];
    }
    
    [serializer setValue:@"ios" forHTTPHeaderField:@"os"];
    [serializer setValue:[[FKYEnvironment defaultEnvironment] station] forHTTPHeaderField:@"station"];
    [serializer setValue:[[FKYEnvironment defaultEnvironment] version] forHTTPHeaderField:@"version"];
    [serializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forHTTPHeaderField:@"versionNum"];
    [serializer setValue:[[FKYEnvironment defaultEnvironment] userToken] forHTTPHeaderField:@"token"];
    
    // 新增deviceCode
    //NSString *deviceid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *deviceid = [UIDevice readIdfvForDeviceId];
    if (deviceid && deviceid.length > 0) {
        [serializer setValue:deviceid forHTTPHeaderField:@"deviceCode"];
    }
    
    NSMutableURLRequest *urlRequest = [serializer requestWithMethod:method URLString:url parameters:body error:nil];
//    if (urlRequest.HTTPBody != nil) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody options:NSJSONReadingMutableContainers error:nil];
//        NSArray *pairs = [NSMutableArray arrayWithArray:[dict FKYKeyValueStringFormattedPair]];
//        NSString *jsonFormattedString = [pairs componentsJoinedByString:@"&"];
//        NSData *data = [dict.URLQueryString dataUsingEncoding:NSUTF8StringEncoding];
//        [urlRequest setHTTPBody:data];
//    }
    return urlRequest;
}

//
- (NSError *)p_handleErrorWithMessage:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:message code:0 userInfo:nil];
    return error;
}


#pragma mark - 数据合法性检测

/**
 *  返回数据合法性检测...<失败时不带data>
 *
 *  @param response     response
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)p_vaildResponse:(FKYNetworkResponse *)response
             requestUrl:(NSString *)url
           requestParam:(NSDictionary *)dic
                success:(FKYNetworkSuccessBlock)success
                failure:(FKYFailureBlock)failure
{
    if (!(response.statusCode.intValue == 0 || response.statusCode.intValue == 1)) {
        if (response.statusCode.intValue == -2) {
            // -2
            if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
                // 记录退出登录时的相关信息，并上传服务器
//                NSString *userid = [FKYLoginAPI currentUserId];
//                if (userid && userid.length > 0) {
//                    //
//                } else {
//                    userid = @"";
//                }
                NSString *gltoken = [HJGlobalValue sharedInstance].token;
                if (gltoken && gltoken.length > 0) {
                    //
                }
                else {
                    gltoken = @"";
                }
                NSString *yctoken = UD_OB(@"user_token");
                if (yctoken && yctoken.length > 0) {
                    //
                }
                else {
                    yctoken = @"";
                }
                NSString *params = dic ? [dic jsonString] : @"";
                NSString *method = url && url.length > 0 ? url : @"";
//                NSString *note = @"请求非atapter接口数据时token超时退出登录";
                NSDictionary *dicInfo = @{@"gltoken":gltoken, @"yctoken":yctoken, @"params":params, @"url":method, @"system":@"ios"};
                NDC_POST_Notification(FKYLogoutForRequestFail, nil, dicInfo);
                
                // token过期...<已登录>
                safeBlock(failure, @"身份认证失效,请重新登录");
                NDC_POST_Notification(FKYTokenOverDateNotification, nil, nil);
                
                // 加Alert来定位自动退出登录的bug
//                NSString *infoString = [NSString stringWithFormat:@"[请求接口(%@)时返回token过期，从而强制退出登录。]", url];
//                NSString *dataString = [(dic ? dic : @{}) jsonString];
//                NSString *finalString = [NSString stringWithFormat:@"%@\n接口名：%@\n入参：%@", infoString, url, dataString];
//                NDC_POST_Notification(FKYLogoutForRequestFail, nil, (@{@"msg": finalString}));
            }
            else {
                // 未登录
                safeBlock(success,nil,nil);
            }
            return;
        }
        // 提交订单，1药贷查询额度异常或额度不足
        // 003101009006 普通订单查询1药贷余额异常
        // 003201009006 一起购订单查询1药贷余额异常
        // 003101009005 普通订单1药贷额度不足
        // 003201009005 一起购订单1药贷额度不足
        NSString * statusCode = [NSString stringWithFormat:@"%@", response.statusCode];
        if ([statusCode isEqualToString:@"003101009006"] ||
            [statusCode isEqualToString:@"003201009006"] ||
            [statusCode isEqualToString:@"003101009005"] ||
            [statusCode isEqualToString:@"003201009005"]) {
            safeBlock(success,nil,response);
            return;
        }

        // eg: -3
        safeBlock(failure, [self p_handleErrorWithMessage:response.originalContent[@"message"]].domain);
        return;
    }
    
    // 以下为状态码等于0或1的情况...<请求成功>
    
    if ([response.originalContent isKindOfClass:[NSData class]]) {
        safeBlock(success,nil,response);
        return;
    }
    
    if ([response.originalContent[@"data"] isKindOfClass:[NSNull class]]) {
        // data为空
        NSError *error = [self p_handleErrorWithMessage:@"data is nil"];
        // TODO: 此处需后台更改 成功后data为空
        if ([response.originalContent[@"message"] isEqual:@"成功"] || [response.originalContent[@"message"] isEqual:@"success"]) {
            safeBlock(success,nil,response);
            return;
        }
        safeBlock(failure, error.domain);
        return;
    }
    
    // 默认成功
    safeBlock(success,nil,response);
}

/**
 *  返回数据合法性检测...<New>...<失败时带data>
 *
 *  @param response     response
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)p_vaildResponseMethod:(FKYNetworkResponse *)response
                   requestUrl:(NSString *)url
                 requestParam:(NSDictionary *)dic
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYRequestFailureBlock)failure
{
    if (!(response.statusCode.intValue == 0 || response.statusCode.intValue == 1)) {
        // 操作失败~!@
        
        if (response.statusCode.intValue == -2) {
            // -2:
            
            if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
                // 记录退出登录时的相关信息，并上传服务器
//                NSString *userid = [FKYLoginAPI currentUserId];
//                if (userid && userid.length > 0) {
//                    //
//                } else {
//                    userid = @"";
//                }
                NSString *gltoken = [HJGlobalValue sharedInstance].token;
                if (gltoken && gltoken.length > 0) {
                    //
                }
                else {
                    gltoken = @"";
                }
                NSString *yctoken = UD_OB(@"user_token");
                if (yctoken && yctoken.length > 0) {
                    //
                }
                else {
                    yctoken = @"";
                }
                NSString *params = dic ? [dic jsonString] : @"";
                NSString *method = url && url.length > 0 ? url : @"";
//                NSString *note = @"请求非atapter接口数据时token超时退出登录";
                NSDictionary *dicInfo = @{@"gltoken":gltoken, @"yctoken":yctoken, @"params":params,  @"url":method, @"system":@"ios"};
                NDC_POST_Notification(FKYLogoutForRequestFail, nil, dicInfo);
                
                // token过期...<已登录>
                safeBlock(failure, @"身份认证失效,请重新登录", nil);
                NDC_POST_Notification(FKYTokenOverDateNotification, nil, nil);
                
                // 加Alert来定位自动退出登录的bug
//                NSString *infoString = [NSString stringWithFormat:@"[请求接口(%@)时返回token过期，从而强制退出登录。]", url];
//                NSString *dataString = [(dic ? dic : @{}) jsonString];
//                NSString *finalString = [NSString stringWithFormat:@"%@\n接口名：%@\n入参：%@", infoString, url, dataString];
//                NDC_POST_Notification(FKYLogoutForRequestFail, nil, (@{@"msg": finalString}));
            }
            else {
                // 未登录
                safeBlock(success,nil,nil);
            }
            
            return;
        }
        
        // 提交订单，1药贷查询额度异常或额度不足
        NSString * statusCode = [NSString stringWithFormat:@"%@", response.statusCode];
        if ([statusCode isEqualToString:@"003101009006"] ||
            [statusCode isEqualToString:@"003201009006"] ||
            [statusCode isEqualToString:@"003101009005"] ||
            [statusCode isEqualToString:@"003201009005"]) {
            safeBlock(success,nil,response);
            return;
        }
        
        // -3 or 其它
        NSDictionary *dic = response.originalContent[@"data"];
        safeBlock(failure, [self p_handleErrorWithMessage:response.originalContent[@"message"]].domain, dic);
        return;
    }
    
    // 以下为状态码等于0或1的情况...<请求成功>
    
    if ([response.originalContent isKindOfClass:[NSData class]]) {
        safeBlock(success, nil, response);
        return;
    }
    
    if ([response.originalContent[@"data"] isKindOfClass:[NSNull class]]) {
        NSError *error = [self p_handleErrorWithMessage:@"data is nil"];
        
        // TODO: 此处需后台更改 成功后data为空
        if ([response.originalContent[@"message"] isEqual:@"成功"] || [response.originalContent[@"message"] isEqual:@"success"]) {
            safeBlock(success, nil, response);
            return;
        }
        
        safeBlock(failure, error.domain, nil);
        return;
    }
    
    safeBlock(success, nil, response);
}


@end
