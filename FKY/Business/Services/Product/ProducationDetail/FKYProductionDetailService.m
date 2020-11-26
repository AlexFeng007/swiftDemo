//
//  FKYProducationDetailService.m
//  FKY
//
//  Created by mahui on 15/9/18.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductionDetailService.h"
#import "FKYLoginAPI.h"
#import "FKYCategories.h"
#import "NSDictionary+SafeAccess.h"
#import "NSArray+Block.h"
#import "FKYCartModel.h"
#import "FKYCartProductMO.h"
#import "NSArray+Block.h"
#import "FKYProductPromotionModel.h"
#import "FKYProductCouponModel.h"
#import "FKYCartNetRequstSever.h"


static NSString *getProductDetail = @"product/getProductDetail";


@interface FKYProductionDetailService ()

@property (nonatomic, copy) NSString *enterpriseId;
@property (nonatomic, copy) NSString *pushType;
@property (nonatomic, copy) NSString *spuCode;
@property (nonatomic, copy) NSString *productPrimeryKey;
@property (nonatomic, copy) NSString *productCodeCompany;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;

@property (nonatomic, strong) FKYProductObject *product;

/** 网络请求logic */
@property (nonatomic, strong) FKYCartNetRequstSever *cartRequstSever;

@end


@implementation FKYProductionDetailService

- (FKYCartNetRequstSever *)cartRequstSever
{
    if (_cartRequstSever == nil) {
        _cartRequstSever  = [FKYCartNetRequstSever logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _cartRequstSever;
}

// 获取商品详情（基本信息）
- (void)producationInfoWithParam:(NSDictionary *)params
                         success:(void(^)(FKYProductObject *model))successBlock
                         failure:(void(^)(NSString *reason))failureBlock
{
    [[FKYRequestService sharedInstance] getProductDetailInfoWithParam:params completionBlock:^(BOOL isSucceed, NSError *anError, id aResponseObject, id model) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *originData = (NSDictionary *)aResponseObject;
            if (!originData) {
                safeBlock(failureBlock, nil);
                return;
            }
            
            // 商品model
            FKYProductObject *model = [FKYTranslatorHelper translateModelFromJSON:originData withClass:[FKYProductObject class]];
            //解析同品推荐模型
            NSArray *mppArr = originData[@"MPProducts"];
            if (mppArr.count > 0) {
                model.MPProducts = [FKYSameProductModel getSameProducArr:mppArr];
            }
            //解析促销活动
//            NSArray *proArr = originData[@"promotionList"];
//            if (proArr.count > 0) {
//                model.promotionList = [ProductPromotionInfo getPromotionArr:mppArr];
//            }
            
            // 未返回步长时默认设置为1
            if (model.minPackage == nil || [model.minPackage intValue] == 0) {
                model.minPackage = [NSNumber numberWithInteger:1];
            }
            // 保存
            self.product = model;
            safeBlock(successBlock, model);
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            safeBlock(failureBlock, anError.localizedDescription);
        }
    }];
}

// (商详)单品加车
- (void)addToCartWithProductId:(NSString *)productId
                      quantity:(NSInteger)quantity
                       success:(FKYRequestSuccessBlock)successBlock
                        falure:(FKYRequestFailureBlock)failureBlock
{
    NSMutableDictionary *paramJson = @{}.mutableCopy;
    paramJson[@"addType"] = @(1);
    paramJson[@"sourceType"] = HomeString.PRODUCT_ADD_SOURCE_TYPE;
    NSMutableArray *paramArray = @[].mutableCopy;
    if (self.product) {
        NSMutableDictionary *contentJson = @{}.mutableCopy;
        contentJson[@"supplyId"] = self.product.sellerCode;
        contentJson[@"productNum"] = @(quantity);
        contentJson[@"spuCode"] = self.product.spuCode;
        if (self.product.productPromotion && self.product.productPromotion.promotionPrice) {
            contentJson[@"promotionId"] = self.product.productPromotion.promotionId;
        }
        if ([FKYPush sharedInstance].pushID != nil && ![[FKYPush sharedInstance].pushID isEqual:[NSNull null]] && [FKYPush sharedInstance].pushID.length >1) {
            contentJson[@"pushId"] = [FKYPush sharedInstance].pushID;
        }
        [paramArray addObject:contentJson];
    }
    paramJson[@"ItemList"] = paramArray;
    //分享bd 的佣金Id
    if ([FKYLoginAPI shareInstance].bdShardId != nil && [[FKYLoginAPI shareInstance].bdShardId length] >0){
        paramJson[@"shareUserId"] = [FKYLoginAPI shareInstance].bdShardId;
    }
    @weakify(self);
    [self.cartRequstSever addGoodsIntoCartBlockWithParam:paramJson completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            [FKYCartModel shareInstance].productCount = [aResponseObject[@"productsCount"] integerValue];
            //由于后台不愿意改别人代码，app端兼容判断取那一层message提示错误信息(statusCode==1 取内层message statusCode==2 取外层message)
            if ([aResponseObject[@"statusCode"] integerValue] == 1) {
                NSDictionary *dic = aResponseObject[@"cartResponseList"][0];
                NSString *errMsg = dic[@"message"];
                safeBlock(failureBlock, errMsg, nil);
            }else if([aResponseObject[@"statusCode"] integerValue] == 2) {
                NSString *errMsg = aResponseObject[@"message"];
                safeBlock(failureBlock, errMsg, nil);
            }else {
                safeBlock(successBlock, NO, nil);
                //弹出共享仓提示
                //[self popAlertShareStockTipVC:aResponseObject];
            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey]?anError.userInfo[HJErrorTipKey]:@"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期, 请重新手动登录";
            }
            safeBlock(failureBlock, errMsg, nil);
        }
    }];
}

// (商详)搭配套餐加车
- (void)addToCartWithGroup:(FKYProductGroupModel *)group
                   success:(FKYRequestSuccessBlock)successBlock
                    falure:(FKYRequestFailureBlock)failureBlock
{
    // param
    NSMutableDictionary *paramJson = @{}.mutableCopy;
    paramJson[@"addType"] = @(4);
    paramJson[@"sourceType"] = HomeString.PRODUCT_DP_ADD_SOURCE_TYPE;
    NSMutableArray *paramArray = @[].mutableCopy;
    for (FKYProductGroupItemModel *item in group.productList) {
        if (item.unselected == false) {
            NSMutableDictionary *contentJson = @{}.mutableCopy;
            contentJson[@"supplyId"] = item.supplyId;
            contentJson[@"productNum"] = @([item getProductNumber]); // 购买单品数量（如果商品已经存在则叠加...[必填];
            contentJson[@"spuCode"] = item.spuCode;
            contentJson[@"promotionId"] = group.promotionId ? group.promotionId : @""; // 特价活动ID(套餐必填)...[必填]
            if ([FKYPush sharedInstance].pushID != nil && ![[FKYPush sharedInstance].pushID isEqual:[NSNull null]] && [FKYPush sharedInstance].pushID.length >1) {
                contentJson[@"pushId"] = [FKYPush sharedInstance].pushID;
            }
            [paramArray addObject:contentJson];
        }
    }
    paramJson[@"ItemList"] = paramArray;
    @weakify(self);
    [self.cartRequstSever addGoodsIntoCartBlockWithParam:paramJson completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            NSInteger statusCode = [aResponseObject[@"statusCode"] integerValue];
            NSString *message = aResponseObject[@"message"];
            NSArray *productList = aResponseObject[@"cartResponseList"];
            if (statusCode == 0) {
                // 为0时成功
                //NSInteger productCount = [aResponseObject[@"productCount"] integerValue];
                //CGFloat sumPrice = [aResponseObject[@"sumPrice"] floatValue];
                //NSLog(@"套餐加车成功！购物车中商品数量为:%ld, 总金额为:%.2f", productCount, sumPrice);
                safeBlock(successBlock, NO, aResponseObject);
                //弹出共享仓提示
                //[self popAlertShareStockTipVC:aResponseObject];
            }
            else {
                // 为1时失败
                safeBlock(failureBlock, message, nil);
            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey]?anError.userInfo[HJErrorTipKey]:@"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期, 请重新手动登录";
            }
            safeBlock(failureBlock, errMsg, nil);
        }
    }];
}

/*
 响应参数列表
 变量名    含义    类型    备注
 data    接口返回数据    object
 itemCount    当前用户购物车中的商品种类总数        成功时有
 itemDetail        array<object>    失败时有
 message    单个商品处理消息    string    @mock=$order('套餐失效','套餐失效')
 productName    商品名称    string    @mock=$order(' 东阿阿胶.测试-维生素B12片',' ORION.华法林钠片')
 specification    商品规格    string    @mock=$order('25ug*100片','3mg*100片')
 spuCode    商品SPU    string    @mock=$order('0350ANAH190038','318AGAH190003')
 statusCode    单个商品处理状态（200000001:"失败"时）    number    200140001:固定套餐失效"; 200140002:固定套餐中存在重复商品"; 200140003:加车商品必须为同一套餐活动，且套餐子品必须为两个（含）以上"; 200140004:套餐子品已下架"; 200140005:您的所在地无法购买此商品"; 200140006:套餐子品不在购买渠道范围"; 200140007:套餐活动时间超过有效期"; 200140008:套餐子品购买套数超过最大可购买套餐数"; 200140010:购买数量小于套餐起售门槛"; 200140011:购买数量不能大于9999999"; 200140012:购买数量不能小于1"; 200140013:套餐子品库存不足"; 200140014:套餐子品价格异常";
 supplyId    供应商ID    number    @mock=$order( )
 surplusNum    剩余可购买数量    number
 totalAmount    当前用户购物车中的商品总金额    number    成功时有
 message    接口返回消息    string    @mock=失败
 statusCode    接口返回状态    number    200000000:"成功"; 200000001:"失败"; 200000002:"系统异常"; 200000003:"登陆超时"; 200000004:"非法参数"; 200140009:可以加车成功但套餐数量不能全部满足"; 200140015:最多只能添加200个品种，请先下单";
 */
// (商详)固定套餐加车
- (void)addToCartWithFixedGroup:(FKYProductGroupModel *)group
                        success:(FKYRequestSuccessBlock)successBlock
                         falure:(FKYRequestFailureBlock)failureBlock
{
    NSMutableDictionary *paramJson = @{}.mutableCopy;
    paramJson[@"addType"] = @(3);
    paramJson[@"sourceType"] = HomeString.PRODUCT_GD_ADD_SOURCE_TYPE;
    NSMutableArray *paramArray = @[].mutableCopy;
    for (FKYProductGroupItemModel *item in group.productList) {
        NSMutableDictionary *contentJson = @{}.mutableCopy;
        contentJson[@"supplyId"] = item.supplyId;
        contentJson[@"productNum"] = @([item.doorsill intValue] * [group getGroupNumber]);
        contentJson[@"promotionId"] = group.promotionId ? group.promotionId : @""; // 套餐活动ID(套餐必填)...[必填]
        contentJson[@"spuCode"] = item.spuCode;
        if ([FKYPush sharedInstance].pushID != nil && ![[FKYPush sharedInstance].pushID isEqual:[NSNull null]] && [FKYPush sharedInstance].pushID.length >1) {
            contentJson[@"pushId"] = [FKYPush sharedInstance].pushID;
            }
        [paramArray addObject:contentJson];
    }
    paramJson[@"ItemList"] = paramArray;
    
    @weakify(self);
    [self.cartRequstSever addGoodsIntoCartBlockWithParam:paramJson completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            NSInteger statusCode = [aResponseObject[@"statusCode"] integerValue];
            if (statusCode == 0) {
                // 操作成功(200000000)...<old>
                // 0：成功，1：失败，2：限购 ...<new>
                NSInteger productCount = [aResponseObject[@"productsCount"] integerValue]; // 当前用户购物车中的商品种类总数...<成功时有>
                //                CGFloat sumPrice = [aResponseObject[@"totalAmount"] floatValue]; // 当前用户购物车中的商品总金额...<成功时有>
                //                NSLog(@"套餐加车成功！购物车中商品种类数量为:%ld, 总金额为:%.2f", productCount, sumPrice);
                [FKYCartModel shareInstance].productCount = productCount;
                safeBlock(successBlock, NO, aResponseObject);
                //弹出共享仓提示
                //[self popAlertShareStockTipVC:aResponseObject];
            }
            else {
                // 操作失败
                NSString *message = aResponseObject[@"message"]; // 接口返回消息
                //NSArray *pList = [NSArray yy_modelArrayWithClass:[FKYFixedComboItemModel class] json:dic[@"data"][@"itemDetail"]]; // 套餐内商品加车失败原因...<失败时有>
                safeBlock(failureBlock, message, aResponseObject); // 1：失败，2：限购
            }
            //[FKYCartModel shareInstance].productCount = [aResponseObject[@"data"][@"productsCount"] integerValue];
            //safeBlock(successBlock, NO, nil);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey]?anError.userInfo[HJErrorTipKey]:@"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期, 请重新手动登录";
            }
            safeBlock(failureBlock, errMsg, nil);
        }
    }];
}


#pragma mark - Private

// 搭配套餐加车参数封装
- (NSMutableDictionary *)getGroupParamForRequest:(FKYProductGroupModel *)group
{
    // 最终的请求参数字典
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    // 包含套餐内多个商品相关数据的数组
    NSMutableArray *arr = @[].mutableCopy;
    for (FKYProductGroupItemModel *product in group.productList) {
        // 未选中的商品不加入数组
        if (product.unselected) {
            continue;
        }
        // 封装套餐中选中的商品数据
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"custId"] = [FKYLoginAPI currentUser].userId ? [FKYLoginAPI currentUser].userId : @""; // 企业ID(用户id)...[必填]
        dict[@"supplyId"] = product.supplyId ? product.supplyId : @""; // 供应商ID...[必填]
        dict[@"productCodeCompany"] = product.productcodeCompany ? product.productcodeCompany : @""; // 本公司商品编码...[必填]
        dict[@"productId"] = product.productId ? product.productId : @""; // 商品ID...[必填]
        //dict[@"skuId"] = product.vendorId; // 商品主数据ID...<不必填>
        dict[@"productPrice"] = [NSString stringWithFormat:@"%.2f", [product getProductRealPrice]]; // 商品单价(最终价格)...[必填]
        dict[@"productName"] = [product getProductFullName]; // 商品名称...[必填]
        dict[@"specification"] = product.spec ? product.spec : @""; // 商品规格...[必填]
        //dict[@"index"] = product.vendorId; // 数据列下标(批量加车必填)...<不必填>
        dict[@"spuCode"] = product.spuCode ? product.spuCode : @""; // SPU编码...[必填]
        dict[@"promotionType"] = @(13);  // 活动类型(套餐必填)...[必填]...[搭配套餐加车时固定为13]
        dict[@"promotionId"] = group.promotionId ? group.promotionId : @""; // 特价活动ID(套餐必填)...[必填]
        dict[@"manufactures"] = product.factoryName ? product.factoryName : @""; // 生产厂家...[必填]
        dict[@"createUser"] = [FKYLoginAPI currentUser].userName ? [FKYLoginAPI currentUser].userName : @""; // 登录用户名...<不必填>
        dict[@"productCount"] = @([product getProductNumber]); // 购买单品数量（如果商品已经存在则叠加...[必填]
        [arr addObject:dict];
    } // for
    dic[@"shoppingJsonDataArray"] = arr;
    
    return dic;
}

// 固定套餐加车参数封装
- (NSMutableDictionary *)getFixedGroupParamForRequest:(FKYProductGroupModel *)group
{
    // 最终的请求参数字典
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    // 包含套餐内多个商品相关数据的数组...<需要加入购物车的商品列表>
    NSMutableArray *arr = @[].mutableCopy;
    for (FKYProductGroupItemModel *product in group.productList) {
        // 未选中的商品不加入数组
        if (product.unselected) {
            continue;
        }
        // 封装套餐中选中的商品数据
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"spuCode"] = product.spuCode ? product.spuCode : @""; // SPU编码...[必填]
        dict[@"supplyId"] = product.supplyId ? product.supplyId : @""; // 供应商ID...[必填]
        dict[@"promotionId"] = group.promotionId ? group.promotionId : @""; // 套餐活动ID(套餐必填)...[必填]
        dict[@"promotionType"] = @(14);  // 活动类型(套餐必填)...[必填]...套餐活动类型（13："组合套餐"，14："固定套餐"）
        dict[@"comboNum"] = @([group getGroupNumber]); // 商品购买数量（套)...[必填]
        [arr addObject:dict];
    } // for
    dic[@"addCartItemList"] = arr;
    
    return dic;
}

// 弹出共享仓提示
//- (void)popAlertShareStockTipVC:(id)aResponseObject
//{
//    NSArray *needArr = aResponseObject[@"needAlertCartList"];
//    if (needArr.count > 0) {
//        NSArray * productArr = [FKYPostphoneProductModel parsePostphoneProductArr:needArr];
//        PDShareStockTipVC *shareStockVC = [[PDShareStockTipVC alloc] init];
//        shareStockVC.popTitle = @"调拨发货提醒";
//        shareStockVC.tipTxt = aResponseObject[@"shareStockDesc"];
//        shareStockVC.dataList = productArr;
//        [shareStockVC showOrHidePopView:true];
//    }
//}

#pragma mark -

/**
 *    @brief    获取商品满赠信息
 *
 *    @param     pId     商品促销id
 *    @param     successBlock     请求成功回调block
 *    @param     failureBlock     请求失败回调block
 */
+ (void)requestProductFullGiftInfo:(NSString *)pId
                           success:(FKYRequestSuccessBlock)successBlock
                            falure:(FKYRequestFailureBlock)failureBlock
{
    // 入参
    NSDictionary *dic = @{@"promotionId": pId};
    // 请求
    [[FKYRequestService sharedInstance] getProductDetailFullGiftInfoWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (isSucceed) {
            // 成功
            NSString *reason = nil; // 暂无数据
            if (response && [response isKindOfClass:NSDictionary.class]) {
                // 有返回数据
                NSDictionary *dic = (NSDictionary *)response;
                NSArray *list = dic[@"data"];
                //reason = dic[@"msg"];
                if (list && list.count > 0) {
                    // 有数据
                    NSMutableArray *promotions = @[].mutableCopy;
                    for (NSDictionary *json in list) {
                        FKYFullGiftActionSheetModel *model = [FKYFullGiftActionSheetModel yy_modelWithJSON:json];
                        [promotions addObject:model];
                    }
                    safeBlock(successBlock, YES, promotions);
                    return;
                }
            }
            // 无数据
            safeBlock(failureBlock, reason, nil);
        }
        else {
            // 失败
            NSString *reason = @"请求失败";
            if (error && error.localizedDescription) {
                reason = error.localizedDescription;
            }
            safeBlock(failureBlock, reason, nil);
        }
    }];
}

#pragma mark -

/**
 *    @brief    浏览商详页记录浏览次数达30次送券
 *
 *    @param    商品编码     卖家编码(包含jbp)  supplyId 卖家编码(包含jbp)
 *    @param     successBlock     请求成功回调block
 *    @param     failureBlock     请求失败回调block
 */
+ (void)sendViewInfoForCoupon:(NSString *)spuCode
                       senderId:(NSString *)supplyId
                      success:(FKYRequestSuccessBlock)successBlock
                       falure:(FKYRequestFailureBlock)failureBlock
{
    // 入参
    NSDictionary *dic = @{@"spuCode": spuCode,@"sellerCode": supplyId};
    // 请求
    [[FKYRequestService sharedInstance] requestViewCouponSendWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (isSucceed) {
            // 成功
            NSString *reason = nil; // 暂无数据
            if (response && [response isKindOfClass:NSDictionary.class]) {
                // 有返回数据
                NSDictionary *dic = (NSDictionary *)response;
                FKYThousandCouponDetailModel *model = [[FKYThousandCouponDetailModel alloc]init];
                [model initWithModel:dic];
                safeBlock(successBlock, YES, model);
                return;
            }
            // 无数据
            safeBlock(failureBlock, reason, nil);
        }
        else {
            // 失败
            NSString *reason = @"请求失败";
            if (error && error.localizedDescription) {
                reason = error.localizedDescription;
            }
            safeBlock(failureBlock, reason, nil);
        }
    }];
}


@end
