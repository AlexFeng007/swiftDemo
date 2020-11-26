//
//  FKYPaymentService.m
//  FKY
//
//  Created by yangyouyong on 15/11/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPaymentService.h"
#import "FKYPublicNetRequestSevice.h"
#import "NSDictionary+FKYKit.h"
#import "NSDictionary+URL.h"
#import "FKYCartPaymentInfoModel.h"
#import "FKYTranslatorHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "WeiXinModel.h"

@interface FKYPaymentService ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, copy) FKYSuccessBlock successBlock;
@property (nonatomic, copy) FKYFailureBlock failureBlock;
@property (nonatomic, copy) FKYPublicNetRequestSevice *payRequstSever;
@end

@implementation FKYPaymentService


- (FKYPublicNetRequestSevice *)payRequstSever {
    if (_payRequstSever == nil) {
        _payRequstSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _payRequstSever;
}

/**
 *  加载支付信息
 *
 *  @param payFlowId    payFlowId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)loadPaymentDescripForPayflowId:(NSString *)payFlowId
                               success:(FKYSuccessBlock)successBlock
                               failure:(FKYFailureBlock)failureBlock {
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"orderIds"] = payFlowId;
    para[@"payTypeId"] = @"4";
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    para[@"appUuid"] = [UIDevice readIdfvForDeviceId] ?: @"";
    
    [self.payRequstSever getPayInfoBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
             self.paymentInfoModel = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartPaymentInfoModel class]];
            safeBlock(successBlock,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
    
//   NSString *urlString = [NSString stringWithFormat:@"%@orderPay/pay?orderIds=%@&payTypeId=4",[self orderAPI],payFlowId];
//    [self GET:urlString
//   parameters:nil
//      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//          self.paymentInfoModel = [FKYTranslatorHelper translateModelFromJSON:response.originalContent[@"data"] withClass:[FKYCartPaymentInfoModel class]];
//          safeBlock(successBlock,NO);
//      } failure:^(NSString *reason) {
//          safeBlock(failureBlock,reason);
//      }];
}

/**
 *  支付接口
 *
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)payTheOrderSuccess:(FKYSuccessBlock)successBlock
                   failure:(FKYFailureBlock)failureBlock {
    if (!self.paymentInfoModel.MerSplitMsg) {
        safeBlock(failureBlock,@"商户号错误,支付失败");
        return;
    }
    NSString *urlString = @"https://payment.chinapay.com/CTITS/service/rest/page/nref/000000000017/0/0/0/0/0";
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    parms[@"MerSplitMsg"] = self.paymentInfoModel.MerSplitMsg;
    parms[@"TranType"] = self.paymentInfoModel.TranType; // 交易类型
    parms[@"TranDate"] = self.paymentInfoModel.TranDate;
    parms[@"SplitMethod"] = self.paymentInfoModel.SplitMethod;
    parms[@"BankInstNo"] = self.paymentInfoModel.BankInstNo;
    parms[@"CurryNo"] = self.paymentInfoModel.CurryNo;
    parms[@"BusiType"] = self.paymentInfoModel.BusiType;
    parms[@"OrderAmt"] = self.paymentInfoModel.OrderAmt;
    parms[@"Version"] = self.paymentInfoModel.Version;
    parms[@"MerPageUrl"] = self.paymentInfoModel.MerPageUrl;
    parms[@"MerOrderNo"] = self.paymentInfoModel.MerOrderNo; // 订单号
    parms[@"Signature"] = self.paymentInfoModel.Signature; // 签名
    parms[@"SplitType"] = self.paymentInfoModel.SplitType;
    parms[@"MerId"] = self.paymentInfoModel.MerId;
    parms[@"MerBgUrl"] = self.paymentInfoModel.MerBgUrl; // 传什么????
    parms[@"TranTime"] = self.paymentInfoModel.TranTime;
    parms[@"AccessType"] = self.paymentInfoModel.AccessType;
    parms[@"CommodityMsg"] = self.paymentInfoModel.CommodityMsg;
    
    /*
    parms[@"MerSplitMsg"] = @"999901511181005^5;999901511181006^5";
    parms[@"TranType"] = @"0001"; // 交易类型
    parms[@"TranDate"] = @"20151130";
    parms[@"SplitMethod"] = @"0";
    parms[@"BankInstNo"] = @"700000000000017";
    parms[@"CurryNo"] = @"CNY";
    parms[@"BusiType"] = @"0001";
    parms[@"OrderAmt"] = @"10";
    parms[@"Version"] = @"20140728";
    parms[@"MerPageUrl"] = @"http://10.6.58.32:8080/trans/thirdpay/to_chinaPay_page.jsp";
    parms[@"MerOrderNo"] = @"YJ201511181010091011355"; // 订单号
    parms[@"Signature"] = @"0C26amprmR7qgIFe5wpXfsPxEitAVenWyO5+zUt9Bfg9vWkOH4Tb3GK+Auqih9MSghb9W3XP8QGRdBbokl7ylDnbZ3cM6dWhRguPbyCRc+Kbo+BYzXuZzsxMx5oIddI5OYx2Xas2Nw+YO9SKEPECKzkn6RjnSMvvWiODThaKmZs="; // 签名
    parms[@"SplitType"] = @"0002";
    parms[@"MerId"] = @"512201511118874";
    parms[@"MerBgUrl"] = @"http://10.6.58.32:8080/trans/thirdpay/to_chinaPay_page.jsp"; // 传什么????
    parms[@"TranTime"] = @"154120";
    parms[@"CommodityMsg"] = @"yiyaowang";
    parms[@"AccessType"] = @"0";
     */
    
//    urlString = @"http://www.fangkuaiyi.com/thirdpay/app_submit_success.html";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *parmsData = [parms.URLQueryString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:parmsData];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];

    self.responseData = [NSMutableData data];
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:true];
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    BOOL trust = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    safeBlock(self.failureBlock , error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.responseData.length > 0) {
        id obj = [[NSString alloc] initWithData:self.responseData
                                       encoding:NSUTF8StringEncoding];
        self.htmlString = obj;
        NSLog(@"local response - %@",obj);
        safeBlock(self.successBlock,NO);
    }
}

- (void)weixinSingnWithPayflowId:(NSString *)payFlowId
                         success:(void(^)(WeiXinModel*))successBlock
                         failure:(FKYFailureBlock)failureBlock {
    NSDictionary *prama = @{@"out_trade_no":payFlowId};
    NSString *url = [self requestUrl:@"wechatPay/getAppWechatPayParams"];
    url = [NSString stringWithFormat:@"%@%@",@"http://10.6.23.46/",@"wechatPay/getAppWechatPayParams"];
    [self POST:url parameters:prama success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        NSNumber *code = response.originalContent[@"statusCode"];
        if (code.integerValue == 0) {
            WeiXinModel *model = [FKYTranslatorHelper translateModelFromJSON:response.originalContent[@"data"] withClass:[WeiXinModel class]];
            safeBlock(successBlock,model);
        }
    } failure:^(NSString *reason) {
        safeBlock(failureBlock, reason);
    }];
}


@end
