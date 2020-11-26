//
//  FKYAccountService.m
//  FKY
//
//  Created by yangyouyong on 15/12/3.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAccountService.h"
#import "FKYLoginAPI.h"
#import "FKYCouponModel.h"
#import "NSArray+Block.h"
#import "FKYPublicNetRequestSevice.h"

@interface FKYAccountService (){
    BOOL _hasNextForUnusedCoupon ;
    BOOL _hasNextForUsedCoupon ;
    BOOL _hasNextForOutDateCoupon ;
    NSInteger _unusedCouponPageIndex;
    NSInteger _usedCouponPageIndex;
    NSInteger _outDateCouponPageIndex;
}

@property (nonatomic, assign, readwrite) NSInteger payCount;
@property (nonatomic, assign, readwrite) NSInteger sendCount;
@property (nonatomic, assign, readwrite) NSInteger receiveCount;
@property (nonatomic, assign, readwrite) NSInteger refuseCount;

@property (nonatomic, strong, readwrite) NSMutableArray *unuseCouponArray;
@property (nonatomic, strong, readwrite) NSMutableArray *outDateCouponArray;
@property (nonatomic, strong, readwrite) NSMutableArray *useCouponArray;
@property (nonatomic, strong, readwrite) NSArray *couponArray;
@property (nonatomic, strong) FKYPublicNetRequestSevice *orderRequestSever;
@end


@implementation FKYAccountService

/**
 *  资质状态查询
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getUserAuditStatusSuccess:(void(^)(BOOL isNotPerfect))callBack failure:(FKYFailureBlock)failureBlock
{
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        [self.orderRequestSever getAuditStatusBlockWithParam:nil completionBlock:^(id aResponseObject, NSError *anError) {
            if (aResponseObject) {
                NSDictionary *data = (NSDictionary *)aResponseObject;
                NSInteger auditStatus = [data[@"statusCode"] integerValue];
                if ((-1 == auditStatus) || (11 == auditStatus) || (12 == auditStatus) || (13 == auditStatus) || (14 == auditStatus)) {
                    // -1 11 12 13 14
                    if (nil == UD_OB(@"isHandelUserGuideMask")) {
                        UD_ADD_OB(@(NO), @"isHandelUserGuideMask");
                    }
                    safeBlock(callBack, YES);
                }
                else {
                    safeBlock(callBack, NO);
                }
            }
            else {
                NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"状态获取不成功";
                if (anError && anError.code == 2) {
                    errMsg = @"用户登录过期，请重新手动登录";
                }
                safeBlock(failureBlock, errMsg);
            }
        }];
        
        // 已登录...<直接发请求>
//        NSString *urlString = [self requestUserUrl:@"enterpriseInfo/getAuditStatus"];
//        [self GET:urlString parameters:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//            NSDictionary *data = response.originalContent[@"data"];
//            NSInteger auditStatus = [data[@"statusCode"] integerValue];
//            if ((-1 == auditStatus) || (11 == auditStatus) || (12 == auditStatus) || (13 == auditStatus) || (14 == auditStatus)) {
//              // -1 11 12 13 14
//              if (nil == UD_OB(@"isHandelUserGuideMask")) {
//                  UD_ADD_OB(@(NO), @"isHandelUserGuideMask");
//              }
//              safeBlock(callBack, YES);
//            }
//            else {
//              safeBlock(callBack, NO);
//            }
//        } failure:^(NSString *reason) {
//            safeBlock(failureBlock,@"状态获取不成功");
//        }];
    }
    else {
        // 未登录
       safeBlock(failureBlock,@"未登录");
    }
}
/**
 *  查询正式表企业信息
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getEnterpriseInfoSuccess:(void(^)(BOOL isComplented))callBack failure:(FKYFailureBlock)failureBlock
{
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        [self.orderRequestSever getEnterpriseInfoBlockWithParam:nil completionBlock:^(id aResponseObject, NSError *anError) {
            if (aResponseObject) {
                NSDictionary *data = (NSDictionary *)aResponseObject;
                if ([data isEqual:[NSNull null]] || [[data allKeys] count] == 0) {
                    safeBlock(callBack, NO);
                }else{
                    safeBlock(callBack, YES);
                }
            }
            else {
                NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"状态获取不成功";
                if (anError && anError.code == 2) {
                    errMsg = @"用户登录过期，请重新手动登录";
                }
                safeBlock(failureBlock, errMsg);
            }
        }];
    }
    else {
        // 未登录
        safeBlock(failureBlock,@"未登录");
    }
}

/**
 *  获取个人中心数量提示 接口聚合
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getUserTipsInfoSuccess:(FKYSuccessBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock
{
   // NSString *urlString = [self requestUrl:@"order/getUserTipInfo"];
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        // 已登录
        @weakify(self);
        NSMutableDictionary *paraJson = @{}.mutableCopy;
        if(UD_OB(@"user_token")){
            [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
        }
        [self.orderRequestSever getUserTipInfoBlockWithParam:paraJson  completionBlock:^(id aResponseObject, NSError *anError) {
            @strongify(self);
            if (anError == nil) {
                @strongify(self);
                self.payCount = [aResponseObject[@"unPayNumber"] integerValue];
                self.sendCount = [aResponseObject[@"deliverNumber"] integerValue];
                self.receiveCount = [aResponseObject[@"reciveNumber"] integerValue];
                self.refuseCount = [aResponseObject[@"unRejRep"] integerValue];
                self.unuseCouponStr = @([aResponseObject[@"couponNumber"] integerValue]).stringValue;
                safeBlock(successBlock,NO);
            }else{
                self.payCount = 0;
                self.sendCount = 0;
                self.receiveCount = 0;
                self.refuseCount = 0;
                self.unuseCouponStr = @"0";
                NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
                if (anError && anError.code == 2) {
                    errMsg = @"用户登录过期，请重新手动登录";
                }
                safeBlock(failureBlock, errMsg);
            }
        }];
//        [self GET:urlString parameters:nil success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//            NSDictionary *data = response.originalContent[@"data"];
//            self.payCount = [data[@"unPayNumber"] integerValue];
//            self.sendCount = [data[@"deliverNumber"] integerValue];
//            self.receiveCount = [data[@"reciveNumber"] integerValue];
//            self.refuseCount = [data[@"unRejRep"] integerValue];
//            self.unuseCouponStr = @([data[@"couponNumber"] integerValue]).stringValue;
//            safeBlock(successBlock,NO);
//        } failure:^(NSString *reason) {
//            self.payCount = 0;
//            self.sendCount = 0;
//            self.receiveCount = 0;
//            self.refuseCount = 0;
//            self.unuseCouponStr = @"0";
//            safeBlock(failureBlock,reason);
//        }];
    }
    else {
        // 未登录...<不调接口>
        self.payCount = 0;
        self.sendCount = 0;
        self.receiveCount = 0;
        self.refuseCount = 0;
        self.unuseCouponStr = @"0";
        safeBlock(successBlock,NO);
    }
}

- (void)getUnusedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    self.unuseCouponArray = [NSMutableArray array];
    _hasNextForUnusedCoupon = YES;
    _unusedCouponPageIndex = 1;
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        // 已登录
        NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
        NSString *token = [FKYLoginAPI currentUserSessionId];
        NSDictionary *parms = @{@"token":token, @"useStatus":@"1", @"nowPage":@(_unusedCouponPageIndex), @"per":@10};
        [self GET:urlString parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
              NSDictionary *data = response.originalContent[@"data"];
              NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
              self.unuseCouponArray = [self changModelUseStatueToUnused:couponArray].mutableCopy;
              self.unuseCouponStr = [NSString stringWithFormat:@"%@",data[@"total"]];
              if (!self.unuseCouponStr || self.unuseCouponStr.length == 0) {
                  self.unuseCouponStr = @"0";
              }
              if (data[@"total"] == nil) {
                  self.unuseCouponStr = @"0";
              }
              safeBlock(successBlock,NO);
          } failure:^(NSString *reason) {
              self.unuseCouponStr = @"0";
              safeBlock(failureBlock,reason);
          }];
    }
    else {
        // 未登录
        self.unuseCouponStr = @"0";
        safeBlock(successBlock,NO);
    }
}

- (void)getUsedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    self.useCouponArray = [NSMutableArray array];
    _hasNextForUsedCoupon = YES;
    _usedCouponPageIndex = 1;
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        // 已登录
        NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
        NSString *token = [FKYLoginAPI currentUserSessionId];
        NSDictionary *parms = @{@"token":token, @"useStatus":@"2", @"nowPage":@(_usedCouponPageIndex), @"per":@10};
        [self GET:urlString parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
              NSDictionary *data = response.originalContent[@"data"];
              NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
              self.useCouponArray = [self changModelUseStatueToUsed:couponArray].mutableCopy;
              self.useCouponStr = [NSString stringWithFormat:@"%@",data[@"total"]];
              if (!self.useCouponStr || self.useCouponStr.length == 0) {
                  self.useCouponStr = @"0";
              }
              if (data[@"total"] == nil) {
                  self.useCouponStr = @"0";
              }
              safeBlock(successBlock,NO);
          } failure:^(NSString *reason) {
              safeBlock(failureBlock,reason);
          }];
    }
    else {
        // 未登录
        safeBlock(successBlock,NO);
    }
}

- (void)getOutDateCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    self.outDateCouponArray = [NSMutableArray array];
    _hasNextForOutDateCoupon = YES;
    _outDateCouponPageIndex = 1;
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        // 已登录
        NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
        NSString *token = [FKYLoginAPI currentUserSessionId];
        NSDictionary *parms = @{@"token":token, @"useStatus":@"3", @"nowPage":@(_outDateCouponPageIndex), @"per":@10};
        [self GET:urlString parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
              NSDictionary *data = response.originalContent[@"data"];
              NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
              self.outDateCouponStr = [NSString stringWithFormat:@"%@",data[@"total"]];
              self.outDateCouponArray = [self changModelUseStatueToDateOut:couponArray].mutableCopy;
              if (!self.outDateCouponStr || self.outDateCouponStr.length == 0) {
                  self.outDateCouponStr = @"0";
              }
              if (data[@"total"] == nil) {
                  self.outDateCouponStr = @"0";
              }
              safeBlock(successBlock,NO);
          } failure:^(NSString *reason) {
              safeBlock(failureBlock,reason);
          }];
    }
    else {
        // 未登录
        safeBlock(successBlock,NO);
    }
}

- (BOOL) hasNextForStatus:(FKYCouponStatus)status {
    switch (status) {
        case FKYCouponStatusUnused:
            return [self hasNextPageForUnusedCoupon];
            break;
        case FKYCouponStatusUsed:
            return [self hasNextPageForUsedCoupon];
            break;
        case FKYCouponStatusExpired:
            return [self hasNextPageForOutDateCoupon];
            break;
    }
}

- (void)getNextPageForStatus:(FKYCouponStatus)status
                     success:(FKYSuccessBlock)successBlock
                     failure:(FKYFailureBlock)failureBlock {
    switch (status) {
        case FKYCouponStatusUnused:
            if ([self hasNextPageForUnusedCoupon]) {
                return[self getNextPageForUnusedCouponInfoSuccess:successBlock
                                                          failure:failureBlock];
            };
            break;
        case FKYCouponStatusUsed:
            if ([self hasNextPageForUsedCoupon]) {
                return [self getNextPageForUsedCouponInfoSuccess:successBlock
                                                         failure:failureBlock];
            };
            break;
        case FKYCouponStatusExpired:
            if ([self hasNextPageForOutDateCoupon]) {
                return [self getNextPageForOutDateCouponInfoSuccess:successBlock
                                                            failure:failureBlock];
            };
            break;
    }
}

- (NSArray *)couponArrayForStatus:(FKYCouponStatus)status {
    switch (status) {
        case FKYCouponStatusUnused:
            return [self unuseCouponArray];
            break;
        case FKYCouponStatusUsed:
            return [self useCouponArray];
            break;
        case FKYCouponStatusExpired:
            return [self outDateCouponArray];
            break;
    }
}

- (BOOL) hasNextPageForUnusedCoupon {
    return _hasNextForUnusedCoupon;
}

- (BOOL) hasNextPageForUsedCoupon {
    return _hasNextForUsedCoupon;
}

- (BOOL) hasNextPageForOutDateCoupon {
    return _hasNextForOutDateCoupon;
}

- (void)getNextPageForUnusedCouponInfoSuccess:(FKYSuccessBlock)successBlock
                                      failure:(FKYFailureBlock)failureBlock {
    _unusedCouponPageIndex++;
    
    NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
    NSString *token = [FKYLoginAPI currentUserSessionId];
    NSDictionary *parms = @{@"token":token, @"useStatus":@"1", @"nowPage":@(_unusedCouponPageIndex), @"per":@10};
    
    [self GET:urlString parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        NSDictionary *data = response.originalContent[@"data"];
        NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
        if (couponArray.count <= 0) {
          self->_hasNextForUnusedCoupon = NO;
          safeBlock(successBlock,NO);
          return;
        }
        [self.unuseCouponArray addObjectsFromArray:[self changModelUseStatueToUnused:couponArray]];
        safeBlock(successBlock,NO);
    } failure:^(NSString *reason) {
        safeBlock(failureBlock,reason);
    }];
}
- (void)getNextPageForUsedCouponInfoSuccess:(FKYSuccessBlock)successBlock
                                    failure:(FKYFailureBlock)failureBlock {
    _usedCouponPageIndex ++ ;
    NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
    NSString *token = [FKYLoginAPI currentUserSessionId];
    NSDictionary *parms = @{@"token":token, @"useStatus":@"2", @"nowPage":@(_usedCouponPageIndex), @"per":@10};
    [self GET:urlString
   parameters:parms
      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
          NSDictionary *data = response.originalContent[@"data"];
          NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
          if (couponArray.count <= 0) {
              self->_hasNextForUsedCoupon = NO;
              safeBlock(successBlock,NO);
              return ;
          }
          [self.useCouponArray addObjectsFromArray:[self changModelUseStatueToUsed:couponArray]];
          safeBlock(successBlock,NO);
      } failure:^(NSString *reason) {
          safeBlock(failureBlock,reason);
      }];
}

- (void)getNextPageForOutDateCouponInfoSuccess:(FKYSuccessBlock)successBlock
                                       failure:(FKYFailureBlock)failureBlock {
    _outDateCouponPageIndex ++;
    NSString *urlString = [self.mainAPI stringByAppendingString:@"/coupon/listCustomerCoupon"];
    NSString *token = [FKYLoginAPI currentUserSessionId];
    NSDictionary *parms = @{@"token":token, @"useStatus":@"3", @"nowPage":@(_outDateCouponPageIndex), @"per":@10};
    [self GET:urlString
   parameters:parms
      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
          NSDictionary *data = response.originalContent[@"data"];
          NSArray *couponArray = [FKYTranslatorHelper translateCollectionFromJSON:data[@"result"] withClass:[FKYCouponModel class]];
          if (couponArray.count <= 0) {
              self->_hasNextForOutDateCoupon = NO;
              safeBlock(successBlock,NO);
              return ;
          }
          [self.outDateCouponArray addObjectsFromArray:[self changModelUseStatueToDateOut:couponArray]];
          safeBlock(successBlock,NO);
      } failure:^(NSString *reason) {
          safeBlock(failureBlock,reason);
      }];
}

- (NSArray *)changModelUseStatueToUnused:(NSArray *)modelArray{
    NSMutableArray *mutable = [NSMutableArray array];
    for (int index = 0; index < modelArray.count; index++) {
        FKYCouponModel *model = modelArray[index];
        model.useStatus = @"1";
        [mutable addObject:model];
    }
    return mutable;
}

- (NSArray *)changModelUseStatueToUsed:(NSArray *)modelArray{
    NSMutableArray *mutable = [NSMutableArray array];
    for (int index = 0; index < modelArray.count; index++) {
        FKYCouponModel *model = modelArray[index];
        model.useStatus = @"2";
        [mutable addObject:model];
    }
    return mutable;
}

- (NSArray *)changModelUseStatueToDateOut:(NSArray *)modelArray{
    NSMutableArray *mutable = [NSMutableArray array];
    for (int index = 0; index < modelArray.count; index++) {
        FKYCouponModel *model = modelArray[index];
        model.useStatus = @"3";
        [mutable addObject:model];
    }
    return mutable;
}

- (FKYPublicNetRequestSevice *)orderRequestSever {
    if (_orderRequestSever == nil) {
        _orderRequestSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _orderRequestSever;
}

@end
