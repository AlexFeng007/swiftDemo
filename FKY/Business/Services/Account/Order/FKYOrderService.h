//
//  FKYOrderService.h
//  FKY
//
//  Created by mahui on 15/9/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单相关请求服务类

#import "FKYBaseService.h"
#import "FKYPersonModel.h"
#import "FKYDelayInfoModel.h"
#import "FKYDeliveryModel.h"
#import "FKYDeliveryHeadModel.h"
#import "FKYDeliveryItemModel.h"

@class FKYReceiveModel;
@class FKYOrderModel;
@class FKYMoreInfoModel;
@class FKYOrderResonModel;


@interface FKYOrderService : FKYBaseService

@property (nonatomic, strong) NSArray *orderDetailArr;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSArray *providerArr;
@property (nonatomic, strong) FKYDelayInfoModel *delayInfoModel;
@property (nonatomic, copy) NSArray<FKYOrderResonModel *> *reasonsArray;
/// 当前类型订单的总条数
@property (nonatomic, assign)NSInteger totalCount;
/// 当前推荐品的总页数
@property (nonatomic, assign)NSInteger recommendTotalPages;
/// 当前推荐商品所在页
@property (nonatomic, assign)NSInteger recommendCurrentPage;
- (NSString *)getOfflineDescribe4Mp;
- (NSString *)getOfflineDescribe4Self;
- (NSString *)getQualificationReminder;
/**
 *  确认收货
 *
 *  @param orderId      orderId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)receiveProductionWithOrderId:(NSString *)orderId
                             success:(FKYFailureBlock)successBlock
                             failure:(FKYFailureBlock)failureBlock;
/**
 *  延期收货
 *
 *  @param orderId      orderId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)delayProductionWithOrderId:(NSString *)orderId
                           success:(FKYFailureBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock;

- (BOOL)hasNext;
- (void)nowPageToZero;

- (void)getDelayInfoWithOrderId:(NSString *)orderId
                        success:(FKYSuccessBlock)successBlock
                        failure:(FKYFailureBlock)failureBlock;


#pragma mark ---- new order
/**
 *  获取订单列表
 *
 *  @param type         订单状态
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)getOrderListWithOrderType:(NSString *)type keyWord:(NSString *)keyWord
                          success:(void(^)(NSMutableArray *orderList))successBlock failure:(void(^)(NSString *reason))failureBlock;

/**
 *  订单详情
 *
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)getOrderDetailWithOrderId:(NSString *)orderId
                          success:(void(^)(FKYOrderModel *model))successBlock
                          failure:(void(^)(NSString *reason))failureBlock;

- (void)getOrderDetailWithOrderId:(NSString *)orderId
                       statusCode:(NSString *)statusCode
                          success:(void(^)(FKYOrderModel *model))successBlock
                          failure:(void(^)(NSString *reason))failureBlock;

/**
 *  取消订单
 *
 *  @param orderId      orderId
 *  @param isSelf       isSelf
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)cancelOrderWithOrderId:(FKYOrderModel *)model
                        isSelf:(BOOL)isSelf
                       success:(FKYFailureBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock;


/**
 *  拒收/补货
 *
 *  @param orderId      订单id
 *  @param productList  商品列表
 *  @param applyType    类型 (3:拒收,4:补货)
 *  @param applyCause   原因
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)refusedOrReplenishOrderWithOrderId:(NSString *)orderId
                            andProductList:(NSString *)productList
                              andApplyType:(NSString *)applyType
                             andApplyCause:(NSString *)applyCause
                              andAddressId:(NSString *)addressId
                                   success:(void(^)(NSString *message))successBlock
                                   failure:(void(^)(NSString *reason))failureBlock;


/**
 *  物流信息
 *
 *  @param type         物流类型
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)getDeliveryInfoWithType:(NSString *)type
                     andOrderId:(NSString *)orderId
                        success:(void(^)(FKYDeliveryModel *model))successBlock
                        failure:(void(^)(NSString *reason))failureBlock;

/**
 *  物流详情
 *
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)getDeliveryDetailWithOrderId:(NSString *)orderId
                             success:(void(^)(NSMutableArray *modelsArr))successBlock
                             failure:(void(^)(NSString *reason))failureBlock;

/**
 *  物流详情title
 *
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)getDeliveryTitleWithOrderId:(NSString *)orderId
                            success:(void(^)(FKYDeliveryHeadModel *model))successBlock
                            failure:(void(^)(NSString *reason))failureBlock;

/**
 *  收货商品列表
 *
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)geiReceiveProductListWithOrderId:(NSString *)orderId
                                 success:(void(^)(FKYReceiveModel *receiveModel))successBlock
                                 failure:(void(^)(NSString *reason))failureBlock;

/**
 *  订单详情更多信息
 *
 *  @param orderId      订单ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
- (void)orderDetailMoreInfo:(NSString *)orderId
                    success:(void(^)(FKYMoreInfoModel *model))successBlock
                    failure:(void(^)(NSString *reason))failureBlock;

// 已完成订单之再次购买
- (void)buyAgainOrderType:(NSString *)type
               andOrderId:(NSString *)orderId
                  success:(void(^)(NSNumber *))successBlock
                  failure:(void(^)(NSString *))failureBlock;


//取消订单 加原因
- (void)cancelOrderWithOrderId:(FKYOrderModel *)model
                        isSelf:(BOOL)isSelf
                          type:(NSString *)type
                        reason:(NSString *)reasonStr
                       success:(FKYFailureBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock;

/// 获取订单列表底部的推荐品列表
- (void)requestRecommendProductList:(NSDictionary *)parameters callBack:(void (^)(BOOL isSucceed, NSError *error, id response, id model))callBack;

@end

