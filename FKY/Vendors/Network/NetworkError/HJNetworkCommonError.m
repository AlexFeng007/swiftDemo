//
//  HJNetworkCommonError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJNetworkCommonError.h"
#import "HJURLCache.h"
#import "HJTokenExpireError.h"
#import "HJSignKeyExpireError.h"
#import "HJTimeOutError.h"
#import "HJOperationParam.h"
#import "HJOperationManager.h"

@interface HJOperationParam ()

@property (nonatomic, copy) NSString *methodName; //方法名
@property (nonatomic, copy) NSString *requestUrl; //请求url

@end
@interface HJTokenExpireError ()

/**
 *  功能:aRtnCode是否是token过期错误码
 */
- (BOOL)tokenExpiredForRtnCode:(NSString *)aRtnCode;

@end

@interface HJSignKeyExpireError ()

/**
 *  功能:aRtnCode是否是密钥过期错误码
 */
- (BOOL)signKeyExpiredForRtnCode:(NSString *)aRtnCode;

@end

@interface HJOperationManager ()

/**
 *  功能:发notification，显示错误界面
 */
- (void)notifyShowErrorWithParam:(HJOperationParam *)aParam;

/**
 *  功能:发notification，隐藏无网络错误界面
 */
- (void)notifyHideNoConnectError;

@end


@interface HJOperationParam ()

@property (nonatomic, assign) NSInteger errorType; //接口错误类型(0无错误，1接口超时，2接口出错，3rtn_code不为0)
@property (nonatomic, assign) NSString *errorCode; //接口错误码

@end

@implementation HJNetworkCommonError

DEF_SINGLETON(HJNetworkCommonError)

/**
 *  功能:错误处理(错误提示、token过期、密钥过期、删除缓存)
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    BOOL runCallBack = YES; //是否执行call back，默认执行
    if (aError != nil) {
        if (aParam.retryTimes > 0) {
            //出错时接口重试，不需要调用call back
            runCallBack = NO;
        }
        else {
            //发通知显示错误界面
            [aManager notifyShowErrorWithParam:aParam];
        }

        //接口调用失败时删除缓存
        [[HJURLCache standardURLCache] removeCachedResponseForRequest:[aOperation currentRequest]];

        //接口日志
        aParam.errorType = 2;
        aParam.errorCode = @"000000000001";
    }
    else {
        if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = aResponseObject;
            dic = dic.mutableCopy;
            NSString *rtnCode = [dic objectForKey:@"rtn_code"];
            NSString *rtnMsg = [dic objectForKey:@"rtn_msg"];
            NSString *rtnTip = [dic objectForKey:@"rtn_tip"];

            if (rtnCode == nil || rtnMsg == nil) {
                //接口返回错误数据
                if (aParam.alertError) {
//                    NSString *alertMsg = rtnTip.length > 0 ? rtnTip : @"数据错误";
//                    [[UIApplication sharedApplication].keyWindow showTipsWithMessage:alertMsg tipsPosition:TipsPositionCenter];
                }
            }
            else if ([[HJTokenExpireError sharedInstance] tokenExpiredForRtnCode:rtnCode]) {
                //token过期处理(同一个接口，第一次token过期，不需要调用call back，第二次token过期，需要调用call back)
                runCallBack = [[HJTokenExpireError sharedInstance] dealWithManager:aManager param:aParam operation:aOperation responseObject:aResponseObject error:aError];
            }
            else if ([[HJSignKeyExpireError sharedInstance] signKeyExpiredForRtnCode:rtnCode]) {
                //密钥过期处理(同一个接口，第一次密钥过期，不需要调用call back，第二次密钥过期，需要调用call back)
                runCallBack = [[HJSignKeyExpireError sharedInstance] dealWithManager:aManager param:aParam operation:aOperation responseObject:aResponseObject error:aError];
            }
            else if ([[HJTimeOutError sharedInstance] timeOutForRtnCode:rtnCode]) {
                //接口超时，发通知显示错误界面
                [aManager notifyShowErrorWithParam:aParam];
            }
            else {
                //其他情况返回数据处理
                [self dealWithRtnWithManager:aManager param:aParam responseObject:aResponseObject];
            }

            //rtn_code不为0时删除缓存
            if (![rtnCode isEqualToString:@"0"]) {
                [[HJURLCache standardURLCache] removeCachedResponseForRequest:[aOperation currentRequest]];
            }

            //接口日志
            if (rtnCode == nil) { //接口出错
                aParam.errorType = 2;
                aParam.errorCode = @"000000000001";
            }
            else if ([rtnCode isEqualToString:@"0"]) { //接口成功
                aParam.errorType = 0;
                aParam.errorCode = nil;
            }
            else if ([[HJTimeOutError sharedInstance] timeOutForRtnCode:rtnCode]) { //接口超时
                aParam.errorType = 1;
                aParam.errorCode = nil;
            }
            else { //非超时其他错误
                aParam.errorType = 3;
                aParam.errorCode = rtnCode;
            }
        }
        else {
            //接口返回错误数据
            if (aParam.alertError) {
//                [[UIApplication sharedApplication].keyWindow showTipsWithMessage:@"数据错误" tipsPosition:TipsPositionCenter];
            }

            //返回错误数据时删除缓存
            [[HJURLCache standardURLCache] removeCachedResponseForRequest:[aOperation currentRequest]];

            //接口日志
            aParam.errorType = 2;
            aParam.errorCode = @"000000000001";
        }
    }

    //有网络，则发通知隐藏无网络错误界面
    [aManager notifyHideNoConnectError];

    return runCallBack;
}

/**
 *  功能:其他情况返回数据处理
 */
- (void)dealWithRtnWithManager:(HJOperationManager *)aManager param:(HJOperationParam *)aParam responseObject:(NSMutableDictionary *)aResponseObject
{
//    NSString *rtnCode = [aResponseObject objectForKey:@"rtn_code"];
//    NSString *rtnMsg = [aResponseObject objectForKey:@"rtn_msg"];
//    NSString *rtnFType = [aResponseObject objectForKey:@"rtn_ftype"];
//    NSString *rtnTip = [aResponseObject objectForKey:@"rtn_tip"];
//    BOOL isVenus = [aParam.requestUrl hasPrefix:@"http://mapi.hj.com"];
//    BOOL alertError = aParam.alertError;
//
//    if ([rtnFType isEqualToString:@"0"] && [rtnCode isEqualToString:@"0"] && rtnMsg.length > 0 && isVenus) { //当rtn_ftype=0并且rtn_code=0时,如果rtn_msg有值, 客户端框架层需要给出层提示，显示3秒后消失（注：不走venus接口不接受此逻辑）
//
//        //显示2秒提示
//        [[UIApplication sharedApplication].keyWindow showTipsWithMessage:rtnMsg tipsPosition:TipsPositionCenter];
//    }
//    else if ([rtnFType isEqualToString:@"1"] && isVenus) { //rtn_ftype为1，显示3秒提示并且强制回到首页
//
//        //强制回到首页
//        [self performInMainThreadBlock:^{
//          NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//          [userInfo setObject:@"hj://home" forKey:@"route_url"];
//          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRouterToUrl object:nil userInfo:userInfo];
//        } afterSecond:.5f];
//
//        //显示2秒提示
//        NSString *castratedMsg = [[HJNetworkAlert sharedInstance] alertMsgForErrorCode:rtnCode]; //提示语优化
//        NSString *alertMsg;
//        if (rtnTip.length > 0) {
//            alertMsg = rtnTip;
//        }
//        else if (castratedMsg == nil) {
//            alertMsg = rtnMsg;
//        }
//        else {
//            alertMsg = castratedMsg;
//        }
//        if (alertMsg.length > 0) {
//            [[UIApplication sharedApplication].keyWindow showTipsWithMessage:alertMsg tipsPosition:TipsPositionCenter];
//        }
//    }
//    else if ([rtnFType isEqualToString:@"2"] && isVenus) { //rtn_ftype为2，弹出服务器端下发的提示(只有确认按钮)，用户确认后，跳到服务器端指定的url(Native，或内嵌页面中的h5)
//
//        //弹提示，点击去指定url
//        [[HJAlertView alertWithMessage:rtnTip
//                      andCompleteBlock:^(HJAlertView *alertView, NSInteger buttonIndex) {
//                        [self performInMainThreadBlock:^{
//                          NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                          [userInfo setObject:rtnMsg forKey:@"route_url"];
//                          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRouterToUrl object:nil userInfo:userInfo];
//                        } afterSecond:.5f];
//                      }] show];
//    }
//    else if ([rtnFType isEqualToString:@"3"] && isVenus) { //某个模块版本太低，需要强给出制更新的提示弹出服务器端下发的提示语(有确认和取消按钮)，用户确认后并通过外部浏览器跳到服务器下发的url，用户取消后，返回首页或者上个页面。（注：不弹框，显示空态页面。rtn_msg返回更新url，rtn_tip提示语）
//
//        //显示版本更新界面
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowVersionUpdate object:aManager userInfo:aResponseObject];
//    }
//    else if (![rtnCode isEqualToString:@"0"]) {
//        if (alertError) {
//            //显示2秒提示
//            NSString *castratedMsg = [[HJNetworkAlert sharedInstance] alertMsgForErrorCode:rtnCode]; //提示语优化
//            NSString *alertMsg;
//            if (rtnTip.length > 0) {
//                alertMsg = rtnTip;
//            }
//            else if (castratedMsg == nil) {
//                alertMsg = rtnMsg;
//            }
//            else {
//                alertMsg = castratedMsg;
//            }
//            if (alertMsg.length > 0) {
//                [[UIApplication sharedApplication].keyWindow showTipsWithMessage:alertMsg tipsPosition:TipsPositionCenter];
//            }
//        }
//    }
//    else {
//        //do nothing
//    }
}

@end
