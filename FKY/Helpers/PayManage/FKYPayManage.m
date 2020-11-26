//
//  FKYPayManage.m
//  FKY
//
//  Created by mahui on 2016/11/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYPayManage.h"
#import "FKY-Swift.h"
#import "FKYPaymentService.h"
#import "FKYCartSchemeProtocol.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WeiXinModel.h"
#import "FKYPublicNetRequestSevice.h"

static  NSString *const appScheme = @"YHYC";


@interface FKYPayManage()

@property (nonatomic, strong) FKYPublicNetRequestSevice *payRequstSever;

@end


@implementation FKYPayManage

- (instancetype)init
{
    self = [super init];
    if (!self) {
        self = [[FKYPayManage alloc] init];
    }
    return self;
}

- (FKYPublicNetRequestSevice *)payRequstSever {
    if (_payRequstSever == nil) {
        _payRequstSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _payRequstSever;
}

#pragma mark - Public

- (BOOL)isWXAppInstall
{
    return [WXApi isWXAppInstalled];
}

// 支付宝
- (void)alipayWithPayflowId:(NSString *)payflowId andTotalMoney:(CGFloat)totalMoney andOrderType:(NSString *)orderType successBlock:(void(^)(void))successBlock failureBlock:(void(^)(NSString *reason))failureBlock
{
    AlipayProvider *pay = [[AlipayProvider alloc] init];
    [pay alipaySignWith:payflowId totalPay:totalMoney orderType:orderType  callback:^(NSString * _Nonnull resultStr) {
        if (![self resultIsAvailable:resultStr]) {
            // 支付失败
            safeBlock(failureBlock, @"支付失败，请重新尝试");
            return;
        }
        if (resultStr) {
            // 有返回值，可以调支付宝进行支付
            [[AlipaySDK defaultService] payOrder:resultStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                // 1.跳转到支付宝App后，当前block不会执行~!@
                // 2.若是手机未安装支付宝App，则会自动打开网页版支付宝页面，此时成功or失败会走当前block~!@
                NSNumber *code = resultDic[@"resultStatus"];
                if (code.integerValue == 9000) {
                    // 支付成功
                    safeBlock(successBlock);
                } else {
                    // 支付失败
                    safeBlock(failureBlock, @"支付失败，请重新尝试");
                }
            }];
            
            // 获取支付宝支付参数成功...<类似微信>
            safeBlock(successBlock);
        }
        else {
            // 无返回值，不可支付
            safeBlock(failureBlock, @"支付失败，请重新尝试");
        }
    }];
}


/// 花呗支付
- (void)alipayHuaBeiPayWithPayflowId:(NSString *)payflowId andOrderType:(NSString *)orderType successBlock:(void(^)(void))successBlock failureBlock:(void(^)(NSString *reason))failureBlock
{
    AlipayProvider *pay = [[AlipayProvider alloc] init];
    
    [pay alipayHuaBeiInstallmentWithPayFlowId:payflowId orderType:orderType  callback:^(NSString * _Nonnull resultStr) {
        if (![self resultIsAvailable:resultStr]) {
            // 支付失败
            NSArray *paramList = [resultStr componentsSeparatedByString:@","];
            if (paramList != nil && paramList.count >= 4){
                if ([paramList[2] isEqualToString:@"msg"]){
                    safeBlock(failureBlock, [NSString stringWithFormat:@"%@",paramList[3]]);
                    return;
                }
            }
            safeBlock(failureBlock, @"支付失败，请重新尝试");
            return;
        }
        if (resultStr) {
            // 有返回值，可以调支付宝进行支付
            [[AlipaySDK defaultService] payOrder:resultStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //
                NSNumber *code = resultDic[@"resultStatus"];
                if (code.integerValue == 9000) {
                    // 支付成功
                    safeBlock(successBlock);
                } else {
                    // 支付失败
                    safeBlock(failureBlock, @"支付失败，请重新尝试");
                }
            }];
            
            safeBlock(successBlock);
        }
        else {
            // 无返回值，不可支付
            safeBlock(failureBlock, @"支付失败，请重新尝试");
        }
    }];
}

// 花呗分期
- (void)huaBeiPayWithPayflowId:(NSString *)payflowId andInstallmentNum:(NSString *)num andOrderType:(NSString *)orderType successBlock:(void(^)(void))successBlock failureBlock:(void(^)(NSString *reason))failureBlock
{
    AlipayProvider *pay = [[AlipayProvider alloc] init];
    [pay huaBeiInstallmentWithPayFlowId:payflowId num:num orderType:orderType  callback:^(NSString * _Nonnull resultStr) {
        if (![self resultIsAvailable:resultStr]) {
            // 支付失败
            safeBlock(failureBlock, @"支付失败，请重新尝试");
            return;
        }
        if (resultStr) {
            // 有返回值，可以调支付宝进行支付
            [[AlipaySDK defaultService] payOrder:resultStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //
                NSNumber *code = resultDic[@"resultStatus"];
                if (code.integerValue == 9000) {
                    // 支付成功
                    safeBlock(successBlock);
                } else {
                    // 支付失败
                    safeBlock(failureBlock, @"支付失败，请重新尝试");
                }
            }];
            
            safeBlock(successBlock);
        }
        else {
            // 无返回值，不可支付
            safeBlock(failureBlock, @"支付失败，请重新尝试");
        }
    }];
}

// 银联
- (void)unionPayWithPayflowId:(NSString *)payflowId andTotalMoney:(CGFloat)totalMoney successBlock:(void(^)(void))successBlock failureBlock:(void(^)(NSString *reason))failureBlock
{
    FKYPaymentService *pay = [[FKYPaymentService alloc] init];
    [pay loadPaymentDescripForPayflowId:payflowId success:^(BOOL mutiplyPage) {
        //
        [pay payTheOrderSuccess:^(BOOL mutiplyPage) {
            // 成功
            safeBlock(successBlock);
            //
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CartPaymentWebView) setProperty:^(id<FKY_CartPaymentWebView> destinationViewController) {
                destinationViewController.webHTMLString = pay.htmlString;
            }];
        } failure:^(NSString *reason) {
            // 失败
            safeBlock(failureBlock, reason);
        }];
    } failure:^(NSString *reason) {
        //
        safeBlock(failureBlock, reason);
    }];
}

// 微信支付
- (void)weixinPayWithPayflowId:(NSString *)payflowId
                  andOrderType:(NSString *)orderType
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSString *))failureBlock
{
//    if (![WXApi isWXAppInstalled]) {
//        safeBlock(failureBlock, @"未安装微信");
//        return;
//    }

    WXPayProvider *service = [[WXPayProvider alloc] init];
    [service WXPaySignWith:payflowId orderType:orderType  callback:^(WXPayInfoModel * _Nonnull wxInfoModel) {
        // 获取微信支付参数成功
        safeBlock(successBlock);
        // 开始支付操作
        [self wxPayWithInfoModel:wxInfoModel];
    } failure:^(NSString * _Nullable reason) {
        // 获取微信支付参数失败
        safeBlock(failureBlock, reason);
    }];
}

// 1药贷
- (void)loanPayWithPayflowId:(NSString *)payflowId
                enterpriseId:(NSString *)enterpriseId
                successBlock:(void(^)(NSDictionary * data))successBlock
                failureBlock:(void(^)(NSString * reason))failureBlock
{
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"flowId"] = payflowId;
    param[@"payTypeId"] = @"17";
    param[@"supplyId"] = [NSString stringWithFormat:@"%@", enterpriseId];
    param[@"siteType"] = @"2";
    if(UD_OB(@"user_token")){
        [param setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    param[@"appUuid"] = [UIDevice readIdfvForDeviceId] ?: @"";
    
    [self.payRequstSever confirmFosunPayBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            // 成功
             safeBlock(successBlock, aResponseObject);
        }
        else {
            // 失败
            safeBlock(failureBlock, anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败");
        }
    }];
}


#pragma mark - Private

- (BOOL)resultIsAvailable:(NSString *)result
{
    if (result && result.length > 0) {
        NSArray *paramList = [result componentsSeparatedByString:@","];
        if (paramList != nil && paramList.count >= 2){
            if ([paramList[0] isEqualToString:@"code"] && ![paramList[1] isEqualToString:@"0"]){
                return false;
            }
        }
        return YES;
    }
    return NO;
}

- (void)wxPayWithInfoModel:(WXPayInfoModel *)model
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = model.partnerId;
    request.prepayId = model.prepayId;
    request.package = model.packageValue;
    request.nonceStr = model.nonceStr;
    request.timeStamp = model.timeStamp.intValue;
    request.sign = model.sign;
    [WXApi sendReq:request completion:nil];
}


@end
