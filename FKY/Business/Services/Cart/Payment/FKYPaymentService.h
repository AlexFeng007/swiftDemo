//
//  FKYPaymentService.h
//  FKY
//
//  Created by yangyouyong on 15/11/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"

@class FKYCartPaymentInfoModel;
@class WeiXinModel;


@interface FKYPaymentService : FKYBaseService

@property (nonatomic, strong) FKYCartPaymentInfoModel *paymentInfoModel;
@property (nonatomic, strong) NSString *htmlString;

/**
 *  加载支付信息
 *
 *  @param payFlowId    payFlowId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)loadPaymentDescripForPayflowId:(NSString *)payFlowId
                               success:(FKYSuccessBlock)successBlock
                               failure:(FKYFailureBlock)failureBlock;

/**
 *  支付接口
 *
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)payTheOrderSuccess:(FKYSuccessBlock)successBlock
                   failure:(FKYFailureBlock)failureBlock;



/**
 *  微信支付验签
 *
 *  @param payFlowId    payFlowId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)weixinSingnWithPayflowId:(NSString *)payFlowId
                               success:(void(^)(WeiXinModel*))successBlock
                               failure:(FKYFailureBlock)failureBlock;



@end
