//
//  FKYPayManage.h
//  FKY
//
//  Created by mahui on 2016/11/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKYPayManage : NSObject

@property (nonatomic, copy) void (^isInstall)(NSString *);

// 检测微信是否安装
- (BOOL)isWXAppInstall;

// 支付宝
- (void)alipayWithPayflowId:(NSString *)payflowId
              andTotalMoney:(CGFloat)totalMoney
               andOrderType:(NSString *)orderType
               successBlock:(void(^)(void))successBlock
               failureBlock:(void(^)(NSString *))failureBlock;

/// 花呗支付
- (void)alipayHuaBeiPayWithPayflowId:(NSString *)payflowId
     andOrderType:(NSString *)orderType
     successBlock:(void(^)(void))successBlock
     failureBlock:(void(^)(NSString *reason))failureBlock;

// 花呗分期
- (void)huaBeiPayWithPayflowId:(NSString *)payflowId
             andInstallmentNum:(NSString *)num
                  andOrderType:(NSString *)orderType
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSString *reason))failureBlock;

// 银联
- (void)unionPayWithPayflowId:(NSString *)payflowId
                andTotalMoney:(CGFloat)totalMoney
                 successBlock:(void(^)(void))successBlock
                 failureBlock:(void(^)(NSString *))failureBlock;

// 微信
- (void)weixinPayWithPayflowId:(NSString *)payflowId
                  andOrderType:(NSString *)orderType
                  successBlock:(void(^)(void))successBlock
                 failureBlock:(void(^)(NSString *))failureBlock;

// 1药贷
- (void)loanPayWithPayflowId:(NSString *)payflowId
                enterpriseId:(NSString *)enterpriseId
                successBlock:(void(^)(NSDictionary * data))successBlock
                failureBlock:(void(^)(NSString * reason))failureBlock;

@end
