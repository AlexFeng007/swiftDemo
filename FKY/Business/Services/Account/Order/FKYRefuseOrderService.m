//
//  FKYRefuseOrderService.m
//  FKY
//
//  Created by yangyouyong on 2016/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYRefuseOrderService.h"
#import "FKYTranslatorHelper.h"
#import "FKYOrderModel.h"
#import "FKYPublicNetRequestSevice.h"

static  NSString * const refuseOrderAPI = @"order/exceptionOrder";


@interface FKYRefuseOrderService ()

@property (nonatomic, strong, readwrite) NSMutableArray *refuseOrderArray;
@property (nonatomic, strong, readwrite) NSMutableArray *addOrderArray;
@property (nonatomic, assign) NSInteger refusenowPage;
@property (nonatomic, assign) NSInteger refusetotalPage;//拒货总页数
@property (nonatomic, assign) NSInteger addOrdernowPage;
@property (nonatomic, assign) NSInteger addOrdertotalPage;//补货总页数
@property (nonatomic, strong) FKYPublicNetRequestSevice *orderSever;

@end


@implementation FKYRefuseOrderService

- (FKYPublicNetRequestSevice *)orderSever
{
    if (_orderSever == nil) {
        _orderSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _orderSever;
}

- (void)getOrderList:(NSString *)status Success:(FKYSuccessBlock)success failure:(FKYFailureBlock)failure
{
    //NSString *urlString = [self requestUrl:refuseOrderAPI];
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    parms[@"param"] = @{@"orderStatus": status};
    parms[@"pageSize"] = @(10);
    if (status.integerValue == 800) {
        //拒收
        self.refusenowPage = 1;
        parms[@"pageNo"] = @(self.refusenowPage);
    }
    else {
        //补货
        self.addOrdernowPage = 1;
        parms[@"pageNo"] = @(self.addOrdernowPage);
    }
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = parms;
    if (UD_OB(@"user_token")) {
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    
    [self.orderSever exceptionOrderBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            if (status.integerValue == 800) {
                self.refuseOrderArray = [[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"orderList"] withClass:[FKYOrderModel class]] mutableCopy];
                NSString *totalStr = aResponseObject[@"pageCount"];
                self.refusetotalPage = totalStr.integerValue;
                safeBlock(success,NO);
            }
            else {
                self.addOrderArray = [[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"orderList"] withClass:[FKYOrderModel class]]mutableCopy];
                NSString *totalStr = aResponseObject[@"pageCount"];
                self.addOrdertotalPage = totalStr.integerValue;
                safeBlock(success,NO);
            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failure, errMsg);
        }
    }];
    
//    [self POST:urlString
//   parameters:parms
//      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//        if (status.integerValue == 800) {
//            self.refuseOrderArray = [[FKYTranslatorHelper translateCollectionFromJSON:response.originalContent[@"data"][@"orderList"]
//                                                                            withClass:[FKYOrderModel class]] mutableCopy];
//            NSString *totalStr = response.originalContent[@"data"][@"pageCount"];
//            self.refusetotalPage = totalStr.integerValue;
//            safeBlock(success,NO);
//        }else {
//            self.addOrderArray = [[FKYTranslatorHelper translateCollectionFromJSON:response.originalContent[@"data"][@"orderList"]
//                                                                         withClass:[FKYOrderModel class]]mutableCopy];
//            NSString *totalStr = response.originalContent[@"data"][@"pageCount"];
//            self.addOrdertotalPage = totalStr.integerValue;
//            safeBlock(success,NO);
//        }
//    } failure:^(NSString *reason) {
//        safeBlock(failure,reason);
//    }];
}

- (BOOL)hasNext:(NSString *)status
{
    if (status.integerValue == 800) {
        return self.refusenowPage < self.refusetotalPage;
    }
    else {
        return self.addOrdernowPage < self.addOrdertotalPage;
    }
}

- (void)getNext:(NSString *)status Success:(FKYSuccessBlock)success failure:(FKYFailureBlock)failure
{
    // NSString *urlString = [self requestUrl:refuseOrderAPI];
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    parms[@"param"] = @{@"orderStatus": status};
    parms[@"pageSize"] = @(10);
    if (status.integerValue == 800) {
        self.refusenowPage++;
        parms[@"pageNo"] = @(self.refusenowPage);
    }else {
        self.addOrdernowPage++;
        parms[@"pageNo"] = @(self.refusenowPage);
    }
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = parms;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    
    [self.orderSever exceptionOrderBlockWithParam:para  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            if (status.integerValue == 800) {
                [self.refuseOrderArray addObjectsFromArray:[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"orderList"] withClass:[FKYOrderModel class]]];
                safeBlock(success,NO);
                return ;
            }
            [self.addOrderArray addObjectsFromArray:[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"orderList"] withClass:[FKYOrderModel class]]];
            safeBlock(success,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failure, errMsg);
        }
    }];
    
//    [self POST:urlString
//   parameters:parms
//      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//
//          if (status.integerValue == 800) {
//              [self.refuseOrderArray addObjectsFromArray:[FKYTranslatorHelper translateCollectionFromJSON:response.originalContent[@"data"][@"orderList"]
//                                                                                                withClass:[FKYOrderModel class]]];
//              safeBlock(success,NO);
//          }else {
//              [self.addOrderArray addObjectsFromArray:[FKYTranslatorHelper translateCollectionFromJSON:response.originalContent[@"data"][@"orderList"]
//                                                                                             withClass:[FKYOrderModel class]]];
//          }
//          safeBlock(success,NO);
//      } failure:^(NSString *reason) {
//          safeBlock(failure,reason);
//      }];
}

- (void)commitOrder:(NSString *)exceptionOrderId success:(FKYSuccessBlock)success failure:(FKYFailureBlock)failure
{
//    NSString *urlString = [self requestUrl:@"order/orderDeliveryDetail/refusedExceptionReplenishOrder"];
//    NSMutableDictionary *parms = @{}.mutableCopy;
//    parms[@"exceptionOrderId"] = exceptionOrderId;
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = exceptionOrderId;
    if (UD_OB(@"user_token")) {
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderSever refusedExceptionReplenishOrderBlockWithParam:para  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            safeBlock(success,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failure, errMsg);
        }
    }];
    
//    [self GET:urlString
//    parameters:parms
//       success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//           NSLog(@"originalContent_____%@",response.originalContent);
//           safeBlock(success,NO);
//       } failure:^(NSString *reason) {
//           safeBlock(failure,reason);
//       }];
}

@end
