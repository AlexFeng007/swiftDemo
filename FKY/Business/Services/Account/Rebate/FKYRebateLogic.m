//
//  FKYRebateLogic.m
//  FKY
//
//  Created by Joy on 2018/7/6.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYRebateLogic.h"
#import "FKYTranslatorHelper.h"
#import "FKYRebateModel.h"

@interface FKYRebateLogic ()
@property (nonatomic, strong)  NSMutableArray *rebateList;
@end

@implementation FKYRebateLogic

/*  我的返利金接口
 *  http://gateway-b2b.fangkuaiyi.com/promotion/coupon/getRebateAmount
 */
-(void)getRebateData:(NSNumber *)enterpriseId
             success:(void(^)(NSMutableArray *rebateList,NSNumber *total,NSNumber *delayRebate))successBlock
             failure:(void(^)(NSString *reason))failureBlock
{
    HJOperationParam * param = [HJOperationParam paramWithBusinessName:@"promotion/coupon" methodName:@"getRebateAmount" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * data = (NSDictionary *)aResponseObject;
            NSArray *rebateList = [FKYTranslatorHelper translateCollectionFromJSON:data[@"listAmount"] withClass:[FKYRebateModel class]];
            if(!self.rebateList){
                self.rebateList = [NSMutableArray array];
            }
            [self.rebateList addObjectsFromArray:rebateList];
            NSNumber *total=data[@"amountAll"];
            NSNumber *delayNum=data[@"amountAll"];
            safeBlock(successBlock, self.rebateList,total,delayNum);
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            safeBlock(failureBlock,anError.localizedDescription);
        }
    }];
    [self.operationManger requestWithParam:param];
}

@end
