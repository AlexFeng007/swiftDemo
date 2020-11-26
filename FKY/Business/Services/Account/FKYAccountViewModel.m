//
//  FKYAccountViewModel.m
//  FKY
//
//  Created by yangyouyong on 15/12/3.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAccountViewModel.h"
#import "FKYAccountService.h"

@interface FKYAccountViewModel ()

@property (nonatomic, strong) FKYAccountService *service;
@property (nonatomic, assign, readwrite) NSInteger payCount;
@property (nonatomic, assign, readwrite) NSInteger sendCount;
@property (nonatomic, assign, readwrite) NSInteger receiveCount;
@property (nonatomic, assign, readwrite) NSInteger refuseCount;
//@property (nonatomic, assign, readwrite) NSInteger unusedCouponCount;
@property (nonatomic, assign, readwrite) BOOL isNotPerfectInformation;//用户资料审核状态

@end


@implementation FKYAccountViewModel

- (instancetype)init {
    if (self = [super init]) {
//        self.service = [[FKYAccountService alloc] init];
//
//        __weak __typeof(FKYAccountService *)weakService = self.service;
//        __weak __typeof(self)weakSelf = self;
//        self.getServiceDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                // 获取个人中心(不同状态下的订单)数量提示
//                [weakService getUserTipsInfoSuccess:^(BOOL mutiplyPage) {
//                    [subscriber sendCompleted];
//                } failure:^(NSString *reason) {
//                    [subscriber sendError:[NSError errorWithDomain:reason code:0 userInfo:nil]];
//                }];
//                if (weakSelf.isLogin) {
//                    // 资质状态查询 接口聚合
//                    [weakService getUserAuditStatusSuccess:^(BOOL isNotPerfect) {
//                        weakSelf.isNotPerfectInformation = isNotPerfect;
//                    } failure:^(NSString *reason) {
//                        weakSelf.isNotPerfectInformation = NO;
//                    }];
//                } else {
//                    weakSelf.isNotPerfectInformation = NO;
//                }
//
//                return nil;
//            }];
//        }];

        RAC(self, payCount) = RACObserve(self.service, payCount);
        RAC(self, sendCount) = RACObserve(self.service, sendCount);
        RAC(self, receiveCount) = RACObserve(self.service, receiveCount);
        RAC(self, refuseCount) = RACObserve(self.service, refuseCount);
        RAC(self, unusedCouponCount) = RACObserve(self.service, unuseCouponStr);
    }
    return self;
}

// 获取用户聚合信息
- (void)getUserBaseInfo:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    @weakify(self);
    [[FKYRequestService sharedInstance] requestForBaseInfoWithParam:nil completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        @strongify(self);
        if (isSucceed) {
            self.baseInfoModel = [FKYTranslatorHelper translateModelFromJSON:response withClass:[FKYAccountBaseInfoModel class]];
            self.payCount = self.baseInfoModel.unPayNumber;
            self.sendCount = self.baseInfoModel.deliverNumber;
            self.receiveCount = self.baseInfoModel.reciveNumber;
            self.refuseCount = self.baseInfoModel.rmaCount;
            self.unusedCouponCount = self.baseInfoModel.couponCount;
            NSInteger auditStatus = self.baseInfoModel.enterpriseAuditStatus;
            // 保存手机号
            if (self.baseInfoModel.mobile != nil  & self.baseInfoModel.mobile.length > 0) {
                UD_ADD_OB(self.baseInfoModel.mobile ? self.baseInfoModel.mobile : @"", @"user_mobile");
            }
            if ((-1 == auditStatus) || (11 == auditStatus) || (12 == auditStatus) || (13 == auditStatus) || (14 == auditStatus)) {
                // -1 11 12 13 14
                if (nil == UD_OB(@"isHandelUserGuideMask")) {
                    UD_ADD_OB(@(NO), @"isHandelUserGuideMask");
                }
                self.isNotPerfectInformation = YES;
            }else{
                self.isNotPerfectInformation = NO;
            }
             [[GLCookieSyncManager sharedManager] updateAllCookies];
             safeBlock(successBlock,NO);
        }
        else {
            self.payCount = 0;
            self.sendCount = 0;
            self.receiveCount = 0;
            self.refuseCount = 0;
            self.unusedCouponCount = @"0";
            self.isNotPerfectInformation = NO;
            NSString *errMsg = error.userInfo[HJErrorTipKey] ? error.userInfo[HJErrorTipKey] : @"请求失败";
            if (error && error.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

- (void)resetBaseInfo
{
    self.payCount = 0;
    self.sendCount = 0;
    self.receiveCount = 0;
    self.refuseCount = 0;
    self.unusedCouponCount = @"0";
    self.isNotPerfectInformation = NO;
}


@end
