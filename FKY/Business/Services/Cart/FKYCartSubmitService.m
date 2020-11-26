//
//  FKYCartSubmitService.m
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartSubmitService.h"
#import "FKY-Swift.h"

@interface FKYCartSubmitService ()

@property (nonatomic, strong) FKYPublicNetRequestSevice *orderRequestSever;

@end


@implementation FKYCartSubmitService

- (void)extracted:(FKYFailureBlock)failureBlock paraJson:(NSMutableDictionary *)paraJson self_weak_:(FKYCartSubmitService *const __weak)self_weak_ successBlock:(FKYSuccessBlock)successBlock {
    [self.orderRequestSever recheckCouponListBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            if (aResponseObject && aResponseObject[@"couponInfoDtoList"]) {
                self.couponListArray = [FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"couponInfoDtoList"] withClass:[FKYReCheckCouponModel class]];
            }
            for (FKYReCheckCouponModel *couponModel in self.couponListArray) {
                NSMutableArray *desArr = [NSMutableArray new];
                for (NSDictionary *dic in couponModel.couponDtoShopList) {
                    UseShopModel *model = [UseShopModel fromJSON:dic];
                    [desArr addObject:model];
                }
                couponModel.couponDtoShopList = desArr.copy;
            }
            if (aResponseObject) {
                self.checkCouponCodeStr = aResponseObject[@"checkCouponCodeStr"];
                self.showTxt = aResponseObject[@"showTxt"];
                if (self.showTxt.length == 0) {
                    self.showTxt = nil;
                }
                self.couponRuleContent = aResponseObject[@"couponRuleContent"];
                self.couponRuleTitle = aResponseObject[@"couponRuleTitle"];
            }
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
}

// 勾选优惠券
- (void)recheckCouponListPageInfo:(NSMutableDictionary *)reCheckDic
                          Success:(FKYSuccessBlock)successBlock
                          failure:(FKYFailureBlock)failureBlock
{
//    NSMutableDictionary *paraJson = @{}.mutableCopy;
//    paraJson[@"jsonParams"] = reCheckDic;
//    if(UD_OB(@"user_token")){
//        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
//    }
    @weakify(self);
    [self extracted:failureBlock paraJson:reCheckDic self_weak_:self_weak_ successBlock:successBlock];
}

// 获取分享签名
- (void)getOrderShareSign:(NSString *)orderid
                  payType:(NSString *)payType
                  success:(FKYRequestSuccessBlock)successBlock
                  failure:(FKYRequestFailureBlock)failureBlock
{
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"payType"] = payType;
    dic[@"flowId"] = orderid;
    if(UD_OB(@"user_token")){
        [dic setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever getPaySignBlockWithParam:dic completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
             successBlock(YES, aResponseObject);
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            failureBlock(anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败", nil);
        }
    }];
}


#pragma mark - Property

- (FKYPublicNetRequestSevice *)orderRequestSever
{
    if (_orderRequestSever == nil) {
        _orderRequestSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _orderRequestSever;
}


@end
