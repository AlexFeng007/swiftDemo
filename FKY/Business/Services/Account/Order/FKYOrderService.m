
//
//  FKYOrderService.m
//  FKY
//
//  Created by mahui on 15/9/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderService.h"
#import "FKYLoginAPI.h"
#import "FKYTranslatorHelper.h"
#import "NSDictionary+FKYKit.h"
#import "FKYOrderModel.h"
#import "FKYReceiveModel.h"
#import "FKYMoreInfoModel.h"
#import "FKYPublicNetRequestSevice.h"
#import "FKYCartNetRequstSever.h"

static NSString *const orderListUrl = @"order/listOrder"; // 列表
static NSString *const orderDetailUrl = @"order/getOrderDetail"; // 详情
static NSString *const receiveProductUrl = @"order/confirmOrder"; // 收货
static NSString *const delayProductUrl = @"order/delayDelivery"; // 延期
static NSString *const cancleOrderUrl = @"order/cancelOrder"; // 取消
static NSString *const cancleSelfOrderUrl = @"order/buyerCancelPayedOrder"; // 取消(针对自营订单)
static NSString *const refusedReplenishProductUrl = @"order/orderDeliveryDetail/refusedReplenishOrder"; // 拒收 补货
static NSString *const deliveryInfoUrl = @"order/deliveryInfo"; // 物流信息
static NSString *const deliveryDetailUrl = @"order/queryLogistics"; // 物流详情
static NSString *const deliveryDetailTitleUrl = @"order/queryLogisticsTitle"; // 物流详情title
static NSString *const receiveListUrl = @"order/orderDeliveryDetail/confirmOrderDetail"; // 收货清单
static NSString *const moreInfoUrl = @"order/cancelOrderInfo"; // 收货清单
static NSString *const rebuyOrderUrl = @"cart/reBuyOrder"; // 再次购买


@interface FKYOrderService ()

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy)  NSString *orderStatus;
@property (nonatomic, strong) NSMutableArray *supplyName;

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger nowPage;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, copy)  NSString *offlineDescribe4Mp;      // 7天未付款则自动取消
@property (nonatomic, copy)  NSString *offlineDescribe4Self;    // 48小时未付款则自动取消
@property (nonatomic, copy) NSDictionary *cancelReasonTypeInfo;
@property (nonatomic, copy)  NSString *qualificationReminder;      // 资质文件过期或者即将过期提示
@property (nonatomic, strong) FKYPublicNetRequestSevice *orderRequestSever;
@property (nonatomic, strong) FKYCartNetRequstSever *cartRequstSever;

@end


@implementation FKYOrderService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nowPage = 1;
        _orderList = @[].mutableCopy;
    }
    return self;
}

- (FKYCartNetRequstSever *)cartRequstSever
{
    if (_cartRequstSever == nil) {
        _cartRequstSever  = [FKYCartNetRequstSever logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _cartRequstSever;
}

- (BOOL)hasNext
{
    ++_nowPage;
    return _nowPage <= _pageCount;
}

- (void)nowPageToZero
{
    _nowPage = 1;
    _orderList = @[].mutableCopy;
}

- (NSString *)getOfflineDescribe4Mp
{
    return self.offlineDescribe4Mp;
}
- (NSString *)getQualificationReminder{
    return self.qualificationReminder;
}
- (NSString *)getOfflineDescribe4Self
{
    return self.offlineDescribe4Self;
}


/**
 *  确认收货
 *
 *  @param orderId      orderId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)receiveProductionWithOrderId:(NSString *)orderId
                             success:(FKYFailureBlock)successBlock
                             failure:(FKYFailureBlock)failureBlock
{
    NSString *url = [self requestUrl:receiveProductUrl];
    return [self p_dealOrder:orderId url:url success:^(NSString *message) {
        if (message) {
            safeBlock(successBlock,message);
        }else{
            safeBlock(successBlock,message);
        }
    } failure:^(NSString *reason) {
        safeBlock(failureBlock,reason);
    }];
}

/**
 *  延期收货
 *
 *  @param orderId      orderId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)delayProductionWithOrderId:(NSString *)orderId
                           success:(FKYFailureBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever delayDeliveryBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSString *message = aResponseObject[@"message"];
            safeBlock(successBlock, message);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
    
    //    NSString *url = [self requestUrl:delayProductUrl];
    //    return [self p_dealOrder:orderId url:url success:^(NSString *message) {
    //        //
    //        if (message) {
    //            safeBlock(successBlock,message);
    //        }else{
    //            safeBlock(successBlock,message);
    //        }
    //    } failure:^(NSString *reason) {
    //        //
    //        safeBlock(failureBlock,reason);
    //    }];
}

/**
 *  检查优惠券是否过期
 *
 *  @param orderId      orderId
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)validOrderParentWithOrderId:(NSString *)orderId
                            success:(FKYSuccessBlock)successBlock
                            failure:(void(^)(NSString *message, NSInteger key))failureBlock
{
    //    NSString *url = [self requestUrl:delayProductUrl];
    //    NSMutableDictionary *parms = @{}.mutableCopy;
    //    parms[@"orderParentId"] = orderId;
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever delayDeliveryBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSNumber *resultCode = aResponseObject[@"key"];
            if (resultCode.integerValue == 0) {
                safeBlock(successBlock,resultCode.integerValue);
            }else{
                safeBlock(failureBlock,aResponseObject[@"message"],resultCode.integerValue);
            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg, 1);
        }
    }];
    
    //    [self GET:url parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
    //        // 优惠券结果 状态
    //        NSNumber *resultCode = response.originalContent[@"data"][@"key"];
    //        if (resultCode.integerValue == 0) {
    //            safeBlock(successBlock,resultCode.integerValue);
    //        }else{
    //            safeBlock(failureBlock,response.originalContent[@"data"][@"message"],resultCode.integerValue);
    //        }
    //    } failure:^(NSString *reason) {
    //        //
    //        safeBlock(failureBlock,reason,1);
    //    }];
}

//
- (void)p_cancelHasPayOrder:(NSString *)orderId
                        url:(NSString *)urlString
                    success:(void(^)(NSString *))successBlock
                    failure:(void(^)(NSString *))failureBlock
{
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    paraJson[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever buyerCancelPayedOrderBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSString *message = aResponseObject[@"message"];
            safeBlock(successBlock, message);
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

- (void)p_dealNotPayOrder:(NSString *)orderId
                      url:(NSString *)urlString
                  success:(void(^)(NSString *))successBlock
                  failure:(void(^)(NSString *))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    [para setValue:orderId forKey:@"flowId"];
    
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    paraJson[@"jsonParams"] = para;
    if (UD_OB(@"user_token")) {
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever cancelOrderBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSString *message = aResponseObject[@"message"];
            safeBlock(successBlock, message);
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

- (void)p_dealOrder:(NSString *)orderId
                url:(NSString *)urlString
            success:(void(^)(NSString *))successBlock
            failure:(void(^)(NSString *))failureBlock
{
    NSMutableDictionary *parms = @{}.mutableCopy;
    parms[@"orderId"] = orderId;
    [self GET:urlString parameters:parms success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        // 取消结果 状态
        NSString *message = response.originalContent[@"message"];
        safeBlock(successBlock, message);
    } failure:^(NSString *reason) {
        //
        safeBlock(failureBlock,reason);
    }];
}

// 延期
- (void)getDelayInfoWithOrderId:(NSString *)orderId
                        success:(FKYSuccessBlock)successBlock
                        failure:(FKYFailureBlock)failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever delayDeliveryBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            self.delayInfoModel = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYDelayInfoModel class]];
            safeBlock(successBlock, NO);
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


#pragma mark ---- new order

// 请求订单列表数据
- (void)getOrderListWithOrderType:(NSString *)type
                          keyWord:(NSString *)keyWord
                          success:(void(^)(NSMutableArray *orderList))successBlock
                          failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    if (keyWord != nil && keyWord.length > 0){
        para[@"param"] = @{@"variableParameter" :keyWord,@"orderStatus" : @(type.integerValue)};
    }else{
        para[@"param"] = @{@"orderStatus" : @(type.integerValue)};
    }
    
    para[@"pageNo"] = @(_nowPage);
    para[@"pageSize"] = @10;
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    paraJson[@"jsonParams"] = para;
    if (UD_OB(@"user_token")) {
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever listOrderBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSNumber *pageCount = aResponseObject[@"pageCount"];
            NSNumber *totalCount = aResponseObject[@"totalCount"];//totalCount
            self.totalCount = totalCount.integerValue;
            self.pageCount = pageCount.integerValue;
            self.offlineDescribe4Mp = aResponseObject[@"offlineDescribe4Mp"];
            self.offlineDescribe4Self = aResponseObject[@"offlineDescribe4Self"];
            NSArray *orderList = [FKYTranslatorHelper translateCollectionFromJSON:aResponseObject[@"orderList"] withClass:[FKYOrderModel class]];
            for (FKYOrderModel *model in orderList) {
                model.cellType = 1;
            }
            [self.orderList addObjectsFromArray:orderList];
            
            //取消原因
            NSDictionary *reasonsDic = aResponseObject[@"cancelReasonTypeInfo"];
            if (reasonsDic && [reasonsDic isKindOfClass:NSDictionary.class]) {
                self.reasonsArray = [FKYReasonHandler filterReasons:reasonsDic];
            }
            if(aResponseObject[@"qualificationReminder"]){
                self.qualificationReminder = aResponseObject[@"qualificationReminder"];
            }
            
            safeBlock(successBlock, self.orderList);
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

//
- (void)getOrderDetailWithOrderId:(NSString *)orderId
                          success:(void(^)(FKYOrderModel *))successBlock
                          failure:(void(^)(NSString *reason))failureBlock
{
    return [self getOrderDetailWithOrderId:orderId
                                statusCode:@""
                                   success:successBlock
                                   failure:failureBlock];
}

//
- (void)getOrderDetailWithOrderId:(NSString *)orderId
                       statusCode:(NSString *)statusCode
                          success:(void(^)(FKYOrderModel *model))successBlock
                          failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    para[@"orderId"] = orderId;
    NSString *code = @"";
    if (statusCode.integerValue < 900 && statusCode.integerValue >= 800) {
        code = @"800";
    }else if(statusCode.integerValue >= 900){
        code = @"900";
    }else{
        code = statusCode;
    }
    para[@"orderStatus"] = code;
    paraJson[@"jsonParams"] = para;
    if(UD_OB(@"user_token")){
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    @weakify(self);
    [self.orderRequestSever orderDetailBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            FKYOrderModel *model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYOrderModel class]];
            //取消原因
            NSDictionary *reasonsDic = aResponseObject[@"cancelReasonTypeInfo"];
            if (reasonsDic && [reasonsDic isKindOfClass:NSDictionary.class]) {
                self.reasonsArray = [FKYReasonHandler filterReasons:reasonsDic];
            }
            safeBlock(successBlock, model);
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

// 取消订单请求
- (void)cancelOrderWithOrderId:(FKYOrderModel *)model
                        isSelf:(BOOL)isSelf
                       success:(FKYFailureBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock
{
    NSString *url = [self requestUrl:isSelf ? cancleSelfOrderUrl : cancleOrderUrl];
    //0:全部订单, 1:待付款,2:待发货,3:待收货,4:已完成,5:拒收,6补货
    if (model.orderStatus.integerValue == 2 && isSelf) {
        return [self p_cancelHasPayOrder:model.orderId url:url success:^(NSString *message) {
            //
            if (message) {
                safeBlock(successBlock,message);
            }else{
                safeBlock(successBlock,message);
            }
        } failure:^(NSString *reason) {
            //
            safeBlock(failureBlock,reason);
        }];
    } else if (model.orderStatus.integerValue == 1) {
        return [self p_dealNotPayOrder:model.orderId url:url success:^(NSString *message) {
            //
            if (message) {
                safeBlock(successBlock,message);
            }else{
                safeBlock(successBlock,message);
            }
        } failure:^(NSString *reason) {
            //
            safeBlock(failureBlock,reason);
        }];
    }
}

// 拒收 补货
- (void)refusedOrReplenishOrderWithOrderId:(NSString *)orderId
                            andProductList:(NSString *)productList
                              andApplyType:(NSString *)applyType
                             andApplyCause:(NSString *)applyCause
                              andAddressId:(NSString *)addressId
                                   success:(void(^)(NSString *message))successBlock
                                   failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"orderId"] = orderId;
    para[@"productList"] = productList;
    para[@"applyType"] = applyType;
    para[@"applyCause"] = applyCause;
    if (addressId) {
        // 补货需要，拒收不需要
        para[@"selectDeliveryAddressId"] = addressId;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"jsonParams"] = para;
    if(UD_OB(@"user_token")){
        [params setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever refusedReplenishOrderBlockWithParam:params completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            safeBlock(successBlock, aResponseObject);
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

//
- (void)getDeliveryInfoWithType:(NSString *)type
                     andOrderId:(NSString *)orderId
                        success:(void(^)(FKYDeliveryModel *model))successBlock
                        failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"jsonParams"] =  orderId;
    if(UD_OB(@"user_token")){
        [params setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    
    [self.orderRequestSever getDeliveryInfoBlockWithParam:params  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            FKYDeliveryModel *model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYDeliveryModel class]];
            safeBlock(successBlock, model);
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

// 第三方物流详情
- (void)getDeliveryDetailWithOrderId:(NSString *)orderId
                             success:(void(^)(NSMutableArray *modelsArr))successBlock
                             failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever checkDeliveryInfoBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSMutableArray *modelsArr = [NSMutableArray arrayWithArray:[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject withClass:[FKYDeliveryItemModel class]]];
            safeBlock(successBlock, modelsArr);
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

// 第三方物流详情 退换货
//- (void)queryByChildOrderId:(NSString *)orderId
//                             success:(void(^)(NSMutableArray *modelsArr))successBlock
//                             failure:(void(^)(NSString *reason))failureBlock
//{
//    NSMutableDictionary *para = @{}.mutableCopy;
//    para[@"jsonParams"] = orderId;
//    if(UD_OB(@"user_token")){
//        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
//    }
//    [self.orderRequestSever queryByChildOrderIdBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
//        if (anError == nil) {
//            NSMutableArray *modelsArr = [NSMutableArray arrayWithArray:[FKYTranslatorHelper translateCollectionFromJSON:aResponseObject withClass:[FKYDeliveryItemModel class]]];
//            safeBlock(successBlock, modelsArr);
//        }
//        else {
//            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
//            if (anError && anError.code == 2) {
//                errMsg = @"用户登录过期，请重新手动登录";
//            }
//            safeBlock(failureBlock, errMsg);
//        }
//    }];
//}

// 第三方物流详情title
- (void)getDeliveryTitleWithOrderId:(NSString *)orderId
                            success:(void(^)(FKYDeliveryHeadModel *model))successBlock
                            failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever queryLogisticsTitleBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            FKYDeliveryHeadModel *model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYDeliveryHeadModel class]];
            safeBlock(successBlock, model);
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

//queryByChildOrderIdBlockWithParam
// 收货清单
- (void)geiReceiveProductListWithOrderId:(NSString *)orderId
                                 success:(void(^)(FKYReceiveModel *receiveModel))successBlock
                                 failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [para setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    
    [self.orderRequestSever confirmOrderDetailBlockWithParam:para completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            FKYReceiveModel *model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYReceiveModel class]];
            safeBlock(successBlock, model);
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

//
- (void)orderDetailMoreInfo:(NSString *)orderId
                    success:(void(^)(FKYMoreInfoModel *model))successBlock
                    failure:(void(^)(NSString *reason))failureBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [params setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [self.orderRequestSever cancelOrderInfoBlockWithParam:params completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            FKYMoreInfoModel *model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYMoreInfoModel class]];
            safeBlock(successBlock, model);
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

// 已完成订单之再次购买
- (void)buyAgainOrderType:(NSString *)type
               andOrderId:(NSString *)orderId
                  success:(void(^)(NSNumber *))successBlock
                  failure:(void(^)(NSString *))failureBlock
{
    NSMutableDictionary *paramJson = @{}.mutableCopy;
    paramJson[@"addType"] = @(2);
    paramJson[@"sourceType"] = HomeString.ORDER_LIST_ADD_SOURCE_TYPE;
//    if ([type isEqualToString:@"1"]){
//        //一起购订单 不需要特别处理 变成普通 产品说的
//        paramJson[@"fromwhere"] =  @"2";
//    }
    paramJson[@"flowId"] = orderId ? orderId : @""; // 订单号
    [self.cartRequstSever addGoodsIntoCartBlockWithParam:paramJson  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSNumber *failCount  = aResponseObject[@"failCount"];
            safeBlock(successBlock, failCount);
            //弹出共享仓提示
            //           FKYAddCarResultModel *cartInfo = [FKYAddCarResultModel fromJSON:aResponseObject];
            //            if (cartInfo.needAlertCartList.count > 0) {
            //                PDShareStockTipVC *shareStockVC = [[PDShareStockTipVC alloc] init];
            //                shareStockVC.popTitle = @"调拨发货提醒";
            //                shareStockVC.tipTxt = cartInfo.shareStockDesc;
            //                shareStockVC.dataList = cartInfo.needAlertCartList;
            //                [shareStockVC showOrHidePopView:true];
            //            }
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

- (FKYPublicNetRequestSevice *)orderRequestSever
{
    if (_orderRequestSever == nil) {
        _orderRequestSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _orderRequestSever;
}



#pragma mark - 取消订单加原因
- (void)cancelOrderWithOrderId:(FKYOrderModel *)model isSelf:(BOOL)isSelf type:(NSString *)type reason:(NSString *)reasonStr success:(FKYFailureBlock)successBlock failure:(FKYFailureBlock)failureBlock {
    NSString *url = [self requestUrl:isSelf ? cancleSelfOrderUrl : cancleOrderUrl];
    //0:全部订单, 1:待付款,2:待发货,3:待收货,4:已完成,5:拒收,6补货
    if (model.orderStatus.integerValue == 2 && isSelf) {
        return [self p_cancelHasPayOrder:model.orderId url:url type:type reason:reasonStr success:^(NSString *message) {
            //
            if (message) {
                safeBlock(successBlock,message);
            }else{
                safeBlock(successBlock,message);
            }
        } failure:^(NSString *reason) {
            //
            safeBlock(failureBlock,reason);
        }];
    } else if (model.orderStatus.integerValue == 1) {
        return [self p_dealNotPayOrder:model.orderId url:url type:type reason:reasonStr success:^(NSString *message) {
            //
            if (message) {
                safeBlock(successBlock,message);
            }else{
                safeBlock(successBlock,message);
            }
        } failure:^(NSString *reason) {
            //
            safeBlock(failureBlock,reason);
        }];
    }
}

//
- (void)p_cancelHasPayOrder:(NSString *)orderId
                        url:(NSString *)urlString
                       type:(NSString *)type
                     reason:(NSString *)reasonStr
                    success:(void(^)(NSString *))successBlock
                    failure:(void(^)(NSString *))failureBlock
{
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    paraJson[@"jsonParams"] = orderId;
    if(UD_OB(@"user_token")){
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    [paraJson setValue:type forKey:@"CancelReasonType"];
    [paraJson setValue:reasonStr forKey:@"otherCancelReason"];
    
    [self.orderRequestSever buyerCancelPayedOrderBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSString *message = aResponseObject[@"message"];
            safeBlock(successBlock, message);
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

- (void)p_dealNotPayOrder:(NSString *)orderId
                      url:(NSString *)urlString
                     type:(NSString *)type
                   reason:(NSString *)reasonStr
                  success:(void(^)(NSString *))successBlock
                  failure:(void(^)(NSString *))failureBlock
{
    
    NSMutableDictionary *para = @{}.mutableCopy;
    [para setValue:type forKey:@"cancelReasonType"];
    [para setValue:reasonStr forKey:@"otherCancelReason"];
    [para setValue:orderId forKey:@"flowId"];
    
    NSMutableDictionary *paraJson = @{}.mutableCopy;
    paraJson[@"jsonParams"] = para;
    if (UD_OB(@"user_token")) {
        [paraJson setObject: UD_OB(@"user_token") forKey:@"ycToken"];
    }
    
    [self.orderRequestSever cancelOrderBlockWithParam:paraJson completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSString *message = aResponseObject[@"message"];
            safeBlock(successBlock, message);
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

/// 获取订单列表底部的推荐品列表
- (void)requestRecommendProductList:(NSDictionary *)parameters callBack:(void (^)(BOOL isSucceed, NSError *error, id response, id model))callBack{
    [[FKYRequestService sharedInstance] getRequestRecommendProductList:parameters completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        self.recommendTotalPages = [((NSDictionary *)response)[@"allPages"] integerValue];
        self.recommendCurrentPage = [((NSDictionary *)response)[@"currentPage"] integerValue];
        callBack(isSucceed,error,response,model);
    }];
}



@end
