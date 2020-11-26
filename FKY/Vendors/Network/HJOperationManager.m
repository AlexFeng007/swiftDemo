//
//  HJOperationManager.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJOperationManager.h"
#import "NSString+MD5.h"
#import "HJGlobalValue.h"
#import "HJNetworkCommonError.h"
#import "HJLaunchFailError.h"
#import "HJNetworkManager.h"
#import "NSString+AESSecurity.h"
#import "HJNetworkQuery.h"
#import "HJURLCache.h"
#import <AFNetworking/AFNetworking.h>
#import "NSObject+PerformBlock.h"


NSString *const HJInterfaceReturnErrorDomain = @"InterfaceReturnError";
NSString *const HJHttpErrorDomain = @"HttpError";
NSString *const HJErrorCodeKey = @"hj.error.code";
NSString *const CommonErrorMsg = @"服务器正在打盹，请稍后再试~";
NSString *const HJErrorTipKey = @"rtn_tip";
NSString *const HJTrader = @"iphone";


@interface HJGlobalValue ()

@property (nonatomic, copy) NSString *signatureKey;     //解密后的签名密钥
@property (nonatomic, copy) NSString *clientInfoString; //clientinfo字符串

@end


@interface HJOperationParam ()

#pragma mark - 拼装requestUrl相关
@property (nonatomic, copy) NSString *methodName; //方法名

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

@end


/************************************************************************************/


@interface HJOperationManager ()

@property (nonatomic, strong) NSMutableArray *operationParams; //这里记录operation param，防止其释放，token过期处理会用到operation param
@property (nonatomic, strong) NSMutableArray *batchOperationParams;

@property (nonatomic, strong) NSMutableArray *cachedParamsForTokenExpire;   //token过期时缓存的所有operation param
@property (nonatomic, strong) NSMutableArray *cachedParamsForSignKeyExpire; //密钥过期时缓存的所有operation param
@property (nonatomic, strong) NSMutableArray *cachedParamsForLaunchFail;    //launch接口调用失败时缓存的所有operation param
@property (nonatomic, strong) NSMutableArray *cachedParamsForShowErrorView; //为错误界面缓存的所有operation param

@property (nonatomic, copy) NSString *hostClassName;

@end


@implementation HJOperationManager

+ (instancetype)manager
{
    return [self managerWithOwner:nil];
}

+ (instancetype)managerWithOwner:(id)owner
{
    HJOperationManager *operationManager = [super manager];
    operationManager.operationQueue.maxConcurrentOperationCount = 2;
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"application/javascript", @"text/plain", @"text/json", @"application/x-javascript", nil];
    operationManager.hostClassName = NSStringFromClass([owner class]);

    //缓存策略
    operationManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;

    //query格式
    [operationManager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
      return [HJNetworkQuery queryStringFromParameters:parameters encoding:NSUTF8StringEncoding];
    }];
    
    //忽略证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    operationManager.securityPolicy = securityPolicy;

    return operationManager;
}

- (void)dealloc
{
//    HJLogW(@"[%@ call %@ --> %@]", [self class], NSStringFromSelector(_cmd), _hostClassName);
}

#pragma mark - Property
- (NSMutableArray *)operationParams
{
    if (_operationParams == nil) {
        _operationParams = @[].mutableCopy;
    }
    return _operationParams;
}

- (NSMutableArray *)batchOperationParams
{
    if (_batchOperationParams == nil) {
        _batchOperationParams = @[].mutableCopy;
    }
    return _batchOperationParams;
}

- (NSMutableArray *)cachedParamsForTokenExpire
{
    if (_cachedParamsForTokenExpire == nil) {
        _cachedParamsForTokenExpire = @[].mutableCopy;
    }
    return _cachedParamsForTokenExpire;
}

- (NSMutableArray *)cachedParamsForSignKeyExpire
{
    if (_cachedParamsForSignKeyExpire == nil) {
        _cachedParamsForSignKeyExpire = @[].mutableCopy;
    }
    return _cachedParamsForSignKeyExpire;
}

- (NSMutableArray *)cachedParamsForLaunchFail
{
    if (_cachedParamsForLaunchFail == nil) {
        _cachedParamsForLaunchFail = @[].mutableCopy;
    }
    return _cachedParamsForLaunchFail;
}

- (NSMutableArray *)cachedParamsForShowErrorView
{
    if (_cachedParamsForShowErrorView == nil) {
        _cachedParamsForShowErrorView = @[].mutableCopy;
    }
    return _cachedParamsForShowErrorView;
}

#pragma mark - API
/**
 *  功能:发送请求
 */
- (NSURLSessionDataTask *)requestWithParam:(HJOperationParam *)aParam
{
    if (aParam == nil) {
        return nil;
    }

    //启动接口调用失败
    if (aParam.needSignature && [HJGlobalValue sharedInstance].signatureKey == nil) {
        BOOL runCallBack = [[HJLaunchFailError sharedInstance] dealWithManager:self param:aParam operation:nil responseObject:nil error:nil];
        if (runCallBack) {
//            HJLogV(@"{method name}: %@\n\nerror:\nlaunch fail\n", aParam.methodName);
            [self performInMainThreadBlock:^{
              if (aParam.callbackBlock) {
                  NSError *error = [NSError errorWithDomain:@"launch fail" code:kLaunchFail userInfo:nil];
                  aParam.callbackBlock(nil, error);
              }
            }];
        }
        return nil;
    }

    //将operation param加入数组，便于管理
    [self.operationParams addObject:aParam];
    
    //requestSerializer处理，包括缓存时间、超时时间、http header
    [self.requestSerializer setValue:[NSString stringWithFormat:@"max-age=%.0f", aParam.cacheTime] forHTTPHeaderField:@"Cache-control"];
    self.requestSerializer.timeoutInterval = aParam.timeoutTime; // 超时
    
    @try {
        NSString *clientInfo = [HJGlobalValue sharedInstance].clientInfoString; // 包含deviceCode
        if (clientInfo && [clientInfo isKindOfClass:[NSString class]] && clientInfo.length > 0) {
            [self.requestSerializer setValue:clientInfo forHTTPHeaderField:@"clientInfo"];
        }
    } @catch (NSException *exception) {
        //
        NSLog(@"clientInfo获取失败");
    } @finally {
        //
    }
    
    NSString *token = aParam.needEncoderToken ? [self getAesEncodedToken] : [HJGlobalValue sharedInstance].token;
    [self.requestSerializer setValue:(token ?: @"") forHTTPHeaderField:@"userToken"];
    if (UD_OB(@"user_token")) {
         [self.requestSerializer setValue:(token ?: @"") forHTTPHeaderField:@"ycToken"];
    }
    
    [self.requestSerializer setValue:[FKYEnvironmentation new].station forHTTPHeaderField:@"provinceId"];
//    NSString *provinceId = [NSString stringWithFormat:@"%@", [HJGlobalValue sharedInstance].provinceId];
//    [self.requestSerializer setValue:provinceId forHTTPHeaderField:@"provinceId"];

    //业务参数组装
    NSMutableDictionary *params = aParam.requestParam.mutableCopy;
    if (aParam.needSignature) {
        // 需要签名
        NSString *timeStamp = [self getServerTimeStamp];
        NSString *signature = [self getSignature:aParam.requestParam timeStamp:timeStamp];
//        if([FKYLoginAPI currentUser].userId.length>0){
//            [params setValue:[FKYLoginAPI currentUser].userId forKey:@"userid"];
//        }
        [params setObject:@"md5" forKey:@"signature_method"];
        [params setObject:timeStamp forKey:@"timestamp"];
        [params setObject:signature forKey:@"signature"];
 
//        [params setObject:[FKYLoginAPI currentUser].userId ? [FKYLoginAPI currentUser].userId : @"" forKey:@"userid"];
//        [params setObject:[FKYLoginAPI currentUser].ycenterpriseId ? [FKYLoginAPI currentUser].ycenterpriseId : @"" forKey:@"enterpriseid"];
//        if(UD_OB(@"user_token")){
//            [params setObject: UD_OB(@"user_token") forKey:@"ycToken"];
//        }
//        [params setObject: @"yaoex_app" forKey:@"traderName"];
//        [params setObject: @"000000" forKey:@"siteCode"];
    }
    // 平台-iphone
    [params setValue:HJTrader forKey:@"trader"];
    // cid
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [userDef objectForKey:@"push_clientId"];
    if (clientId && clientId.length > 0) {
        [params setValue:clientId forKey:@"clientId"];
    }
    //临时绕过验证
    //[params setValue:@"yes" forKey:@"closesignature"];

    //接口请求
    NSURLSessionDataTask *requestOperation = nil;
    @weakify(self);
    if (aParam.requestType == kRequestPost) {
        // POST方式
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        requestOperation = [self POST:aParam.requestUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self successWithParam:aParam operation:task responseObject:responseObject error:nil];
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self failureWithParam:aParam operation:task responseObject:nil error:error];
        }];
    }
    else {
        // GET
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        requestOperation = [self GET:aParam.requestUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self successWithParam:aParam operation:task responseObject:responseObject error:nil];
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self failureWithParam:aParam operation:task responseObject:nil error:error];
        }];
    }

    //记录当前使用的token，便于token过期的判断处理
    aParam.usedToken = [HJGlobalValue sharedInstance].token;

    //记录接口开始调用时间，便于统计接口耗时
    aParam.startTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;

////打印log
//#ifdef DEBUG
//    NSURLRequest *request = [requestOperation currentRequest];
//    NSString *unEncodeUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    HJLogV(@"{method name}: %@\n\n{method params}:  %@\n\n{url before encode}:\n%@\n\n{signature key before encode}:\n%@\n\n{token before encode}:\n%@\n", aParam.methodName, params, unEncodeUrl, [HJGlobalValue sharedInstance].signatureKey, [HJGlobalValue sharedInstance].token);
//#endif

    return requestOperation;
}

/**
 *  功能:取消当前manager queue中所有网络请求
 */
- (void)cancelAllOperations
{
    NSArray *tasks = self.tasks.copy;
    for (NSURLSessionDataTask *task in tasks) {
        [task cancel];
    }

    //call back block置空
    for (HJOperationParam *operationParam in self.operationParams.copy) {
        operationParam.callbackBlock = nil;
        operationParam.retryTimes = 0;
    }
    [self.operationParams removeAllObjects];

//    for (HJBatchOperaionParam *batch in self.batchOperationParams.copy) {
//        batch.completeBlock = nil;
//    }
//    [self.batchOperationParams removeAllObjects];
}

/**
 *  功能:取消当前manager queue中所有网络请求，并从network manager中移除
 */
- (void)cancelOperationsAndRemoveFromNetworkManager
{
    [self cancelAllOperations];

    [self invalidateSessionCancelingTasks:YES];

    [[HJNetworkManager sharedInstance] removeOperationManger:self];
}

#pragma mark - Inner
/**
 *  功能:获取签名字符串
 */
- (NSString *)getSignature:(NSDictionary *)aDict timeStamp:(NSString *)aTimeStamp
{
    NSMutableDictionary *theDict = [aDict mutableCopy];
    //signature_method
    [theDict setObject:@"md5" forKey:@"signature_method"];
    //timestamp
    [theDict setObject:aTimeStamp forKey:@"timestamp"];
    //trader
    [theDict setObject:HJTrader forKey:@"trader"];
    //cid
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [userDef objectForKey:@"push_clientId"];
    if (clientId && clientId.length > 0) {
        [theDict setObject:clientId forKey:@"clientId"];
    }

    //拼装
    NSMutableString *mString = [NSMutableString string];
    NSArray *queryPairs = [HJNetworkQuery queryPairsFromDictionary:theDict];
    NSArray *sortedQueryPairs = [queryPairs sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (HJQueryPair *queryPair in sortedQueryPairs) {
        [mString appendString:[queryPair queryString]];
    }

    //加上私钥
    NSString *signatureKey = [HJGlobalValue sharedInstance].signatureKey;
    [mString appendString:signatureKey];

    //md5运算
    NSString *signature = [mString stringFromMD5];
    signature = [signature uppercaseString];

    return signature;
}

/**
 *  功能:获取服务器时间戳
 */
- (NSString *)getServerTimeStamp
{
    NSTimeInterval dTime = [HJGlobalValue sharedInstance].deltaTime; //服务器时间-本地时间
    NSTimeInterval serverTimeStamp = [[NSDate date] timeIntervalSince1970] + dTime;
    NSString *serverTimeStampStr = [NSString stringWithFormat:@"%0.0lf", serverTimeStamp];

    return serverTimeStampStr;
}

/**
 *  功能:获取AES加密的token
 */
- (NSString *)getAesEncodedToken
{
    NSString *token = [HJGlobalValue sharedInstance].token;
//    if (token == nil) {
//        return nil;
//    }
//
//    // 接口要求毫秒数
//    long long time = [[self getServerTimeStamp] longLongValue];
//    NSString *totalStr = [NSString stringWithFormat:@"%@::%lld", token, time * 1000];
//    NSString *signatureKey = [HJGlobalValue sharedInstance].signatureKey;
//    NSError *error = nil;
//    NSString *encodedStr = [totalStr encryptByAESKey:signatureKey error:&error];

    return token;
}

//json字符串转换dic
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}

#pragma mark - Success or Failed
/**
 *  功能:接口调用成功
 */
- (void)successWithParam:(HJOperationParam *)aParam
               operation:(NSURLSessionDataTask *)aOperation
          responseObject:(id)aResponseObject
                   error:(NSError *)aError
{
//#ifdef DEBUG
//    NSString *description = [aResponseObject description];
//    if (description) {
//        description = [NSString unicodeToUtf8:description];
//    }
//
//    if (description && description.length > 0) {
////        HJLogV(@"{method name}: %@\n\n{response}:\n%@\n", aParam.methodName, description);
//    }
//    else {
////        HJLogV(@"{method name}: %@\n\n{response}:\n%@\n", aParam.methodName, aResponseObject);
//    }
//#endif

    //错误处理(错误提示、token过期、密钥过期、删除缓存)
    BOOL runCallBack = [[HJNetworkCommonError sharedInstance] dealWithManager:self param:aParam operation:aOperation responseObject:aResponseObject error:aError];

    //接口统计日志
    aParam.endTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
//    NSString *rtnCode = [aResponseObject objectForKey:@"rtn_code"];
//    if ([rtnCode isEqualToString:@"0"]) {
//        [[HJNetworkLog sharedInstance] saveLogWithParam:aParam];
//        [[HJNetworkLog sharedInstance] sendLog];
//    }

    //回调
    if (runCallBack && aParam.callbackBlock) {
        id data = [aResponseObject objectForKey:@"data"];
        //判断是否是json字符串
        if ([data isKindOfClass:[NSString class]]) {
            NSDictionary *dataDic = [self dictionaryWithJsonString:data];
            if (dataDic != nil) {
                data = dataDic;
            }
        }
        NSString *rtnCode = [aResponseObject objectForKey:@"rtn_code"];
        NSString *rtn_tip = [aResponseObject objectForKey:@"rtn_tip"];
        NSString *rtn_msg = [aResponseObject objectForKey:@"rtn_msg"];
        
        NSInteger httpCode = [(NSHTTPURLResponse *)[aOperation response] statusCode];
        NSError *error = nil;
        
        if (httpCode != 200) {
            error = [NSError errorWithDomain:HJHttpErrorDomain code:httpCode userInfo:@{NSLocalizedDescriptionKey: CommonErrorMsg, HJErrorCodeKey: [NSString stringWithFormat:@"%ld", (long)httpCode]}];
        }
        else {
            //rtn_code不为0时，将aResponseObject作为error的userInfo传过去
            if (rtnCode.length > 0 && ![rtnCode isEqualToString:@"0"]) {
                NSString *msg = rtn_tip;
                if (!msg || [msg isEqualToString:@""]) {
                    msg = rtn_msg;
                }
                msg = msg.length>0 ? msg : CommonErrorMsg;
                NSMutableDictionary *userInfo = [aResponseObject mutableCopy];
                // 说明：现在工程的接口调用中，msg大部分取HJErrorTipKey，小部分取NSLocalizedDescriptionKey，故两个key均需赋值
                userInfo[NSLocalizedDescriptionKey] = msg;
                userInfo[HJErrorTipKey] = msg;
                userInfo[HJErrorCodeKey] = rtnCode;
                if ([rtnCode isEqualToString:@"000000000002"]) {
                    // token过期
                    error = [NSError errorWithDomain:HJInterfaceReturnErrorDomain code:kTokenExpire userInfo:[userInfo copy]];
                    // 发送通知，弹出登录界面
                    NDC_POST_Notification(FKYTokenOverDateNotification, nil, nil);
                }
                else {
                    // 返回码非0
                    error = [NSError errorWithDomain:HJInterfaceReturnErrorDomain code:kReturnCodeNotEqualToZero userInfo:[userInfo copy]];
                }
            }
        }

        aParam.callbackBlock(data, error);
    }

    [self.operationParams removeObject:aParam];
}

/**
 *  功能:接口调用失败，根据重试次数进行重试
 */
- (void)failureWithParam:(HJOperationParam *)aParam
               operation:(NSURLSessionDataTask *)aOperation
          responseObject:(id)aResponseObject
                   error:(NSError *)aError
{
//#ifdef DEBUG
//    NSString *description = [aResponseObject description];
//    if (description) {
//        description = [NSString unicodeToUtf8:description];
//    }
//    NSString *errorMessage = [aError description];
//    if (errorMessage) {
//        errorMessage = [NSString unicodeToUtf8:errorMessage];
//    }
//
//    if (description && description.length > 0 && errorMessage && errorMessage.length > 0) {
////        HJLogV(@"{method name}: %@\n\n{response}:\n%@\n\nerror:\n%@\n", aParam.methodName, description, errorMessage);
//    }
//    else {
////        HJLogV(@"{method name}: %@\n\n{response}:\n%@\n\nerror:\n%@\n", aParam.methodName, aResponseObject, aError);
//    }
//#endif

    //错误处理(错误提示、token过期、密钥过期、删除缓存)
    BOOL runCallBack = [[HJNetworkCommonError sharedInstance] dealWithManager:self param:aParam operation:aOperation responseObject:aResponseObject error:aError];
//    BOOL runCallBack = YES;

    //回调
    if (runCallBack && aParam.callbackBlock) {
        NSError *error = aError;
        NSMutableDictionary *info = [aError.userInfo mutableCopy];
        if (aOperation.response != nil) {
            NSInteger code = [(NSHTTPURLResponse *)[aOperation response] statusCode];
            info[HJErrorCodeKey] = [NSString stringWithFormat:@"%ld", code];
        } else {
            info[HJErrorCodeKey] = [NSString stringWithFormat:@"%ld", aError.code];
        }
        error = [NSError errorWithDomain:HJHttpErrorDomain code:aError.code userInfo:info];
        
        aParam.callbackBlock(nil, error);
    }

    if (aParam.retryTimes <= 0) {
        [self.operationParams removeObject:aParam];
    }
    else {
        //接口重试
        aParam.retryTimes--;
        [self requestWithParam:aParam];
    }
    
    [WUMonitorInstance saveApiError:aParam.methodName error:aError];
}

#pragma mark - Token Expire
/**
 *  功能:token过期时将operation暂存
 */
- (void)cacheOperationForTokenExpire:(HJOperationParam *)aParam
{
    if (!aParam.rerunForTokenExpire) {
        [self.cachedParamsForTokenExpire addObject:aParam];
    }
}

/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForTokenExpire
{
    NSArray *copyArray = self.cachedParamsForTokenExpire.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForTokenExpire) {
            param.rerunForTokenExpire = YES;
            [self requestWithParam:param];
        }
    }
    [self.cachedParamsForTokenExpire removeAllObjects];
}

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForTokenExpire
{
    //清除之前先执行call back
    NSArray *copyArray = self.cachedParamsForTokenExpire.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForTokenExpire) {
            param.rerunForTokenExpire = YES;
            //回调
            if (param.callbackBlock) {
                NSError *error = [NSError errorWithDomain:@"login fail when token expire" code:kLoginFailWhenTokenExpire userInfo:nil];
                param.callbackBlock(nil, error);
            }
        }

        //发通知显示错误界面
        [self notifyShowErrorWithParam:param];
    }

    [self.cachedParamsForTokenExpire removeAllObjects];
}

#pragma mark - Sign Key Expire
/**
 *  功能:密钥过期时将operation暂存
 */
- (void)cacheOperationForSignKeyExpire:(HJOperationParam *)aParam
{
    if (!aParam.rerunForSignKeyExpire) {
        [self.cachedParamsForSignKeyExpire addObject:aParam];
    }
}

/**
 *  功能:获取密钥接口成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForSignKeyExpire
{
    NSArray *copyArray = self.cachedParamsForSignKeyExpire.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForSignKeyExpire) {
            param.rerunForSignKeyExpire = YES;
            [self requestWithParam:param];
        }
    }
    [self.cachedParamsForSignKeyExpire removeAllObjects];
}

/**
 *  功能:获取密钥接口失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForSignKeyExpire
{
    //清除之前先执行call back
    NSArray *copyArray = self.cachedParamsForSignKeyExpire.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForSignKeyExpire) {
            param.rerunForSignKeyExpire = YES;
            //回调
            if (param.callbackBlock) {
                NSError *error = [NSError errorWithDomain:@"get sign key fail when sign key expire" code:kGetSignKeyFailWhenSignKeyExpire userInfo:nil];
                param.callbackBlock(nil, error);
            }
        }

        //发通知显示错误界面
        [self notifyShowErrorWithParam:param];
    }

    [self.cachedParamsForSignKeyExpire removeAllObjects];
}

#pragma mark - Launch Fail
/**
 *  功能:launch接口调用失败时将operation暂存
 */
- (void)cacheOperationForLaunchFail:(HJOperationParam *)aParam
{
    if (!aParam.rerunForLaunchFail) {
        [self.cachedParamsForLaunchFail addObject:aParam];
    }
}

/**
 *  功能:relaunch成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForLaunchFail
{
    NSArray *copyArray = self.cachedParamsForLaunchFail.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForLaunchFail) {
            param.rerunForLaunchFail = YES;
            [self requestWithParam:param];
        }
    }
    [self.cachedParamsForLaunchFail removeAllObjects];
}

/**
 *  功能:relaunch失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForLaunchFail
{
    //清除之前先执行call back
    NSArray *copyArray = self.cachedParamsForLaunchFail.copy;
    for (HJOperationParam *param in copyArray) {
        if (!param.rerunForLaunchFail) {
            param.rerunForLaunchFail = YES;
            //回调
            if (param.callbackBlock) {
                NSError *error = [NSError errorWithDomain:@"launch fail" code:kLaunchFail userInfo:nil];
                param.callbackBlock(nil, error);
            }
        }

        //发通知显示错误界面
        [self notifyShowErrorWithParam:param];
    }

    [self.cachedParamsForLaunchFail removeAllObjects];
}

#pragma mark - Show Error View
/**
 *  功能:发notification，显示错误界面
 */
- (void)notifyShowErrorWithParam:(HJOperationParam *)aParam
{
    if (aParam.showErrorView) { //显示错误界面

        [self performInMainThreadBlock:^{
          //缓存所有出错接口
          [self.cachedParamsForShowErrorView addObject:aParam];

          @try {
//              [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowErrorView object:self userInfo:nil];
          }
          @catch (NSException *exception) {
          }
          @finally {
          }
        }];
    }
}

/**
 *  功能:发notification，隐藏无网络错误界面
 */
- (void)notifyHideNoConnectError
{
//    //有网络，则隐藏无网络错误界面
//    if (![HJReachability sharedInstance].currentNetStatus == kConnectToNull) {
//        [self performInMainThreadBlock:^{
//          @try {
//              [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideNoConnectErrorView object:self userInfo:nil];
//          }
//          @catch (NSException *exception) {
//          }
//          @finally {
//          }
//        }];
//    }
}

/**
 *  功能:执行错误界面缓存的operation
 */
- (void)performCachedOperationForShowErrorView
{
    NSArray *copyArray = self.cachedParamsForShowErrorView.copy;
    for (HJOperationParam *param in copyArray) {
        [self requestWithParam:param];
    }

    [self.cachedParamsForShowErrorView removeAllObjects];
}

@end
