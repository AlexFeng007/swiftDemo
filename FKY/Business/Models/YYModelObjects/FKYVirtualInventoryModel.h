//
//  FKYVirtualInventoryModel.h
//  FKY
//
//  Created by Rabe on 17/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  自营虚拟库存-缺货页面-数据模型

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FKYVirtualInventoryStockState) {
    FKYVirtualInventoryStockZero = 0, // 库存为0
    FKYVirtualInventoryUnderStock, // 库存不足
    FKYVirtualInventorySufficientStock // 库存充足
};

@interface FKYVirtualInventoryPriceModel : FKYBaseModel

@property (nonatomic, assign) float orderPayMoney; // 订单金额
@property (nonatomic, assign) float couponMoney; // 优惠券金额
@property (nonatomic, assign) float allOrderProductMoney; // 商品金额
@property (nonatomic, assign) float orderFreight; // 运费金额
@property (nonatomic, assign) float totalCount; // 有货品种数
@property (nonatomic, assign) float allOrderShareMoney; // 满减金额
@property (nonatomic, assign) float sellerOrderSamount; // 订单起售金额

@end

@interface FKYVirtualInventoryProductModel : FKYBaseModel

@property (nonatomic, copy) NSString *productCodeCompany; // 本公司商品编码
@property (nonatomic, copy) NSString *productName; // 商品名称
@property (nonatomic, copy) NSString *spec; // 规格
@property (nonatomic, copy) NSString *manufactures; // 厂商
@property (nonatomic, assign) NSInteger productCount; // 可购买数量
@property (nonatomic, assign) NSInteger productNormalCount; // 计划采购数量
@property (nonatomic, assign) NSInteger stockAmount; // 库存数量
@property (nonatomic, assign) NSInteger noStockAmount; // 缺货数量
@property (nonatomic, assign) NSInteger minimumPacking; // 原价起批量
@property (nonatomic, assign) NSInteger promotionId; // 特价 活动id >0时代表该商品为特价商品
@property (nonatomic, assign) NSInteger promotionMinimumPacking; // 特价 活动最小起批量
@property (nonatomic, strong) NSNumber *productPrice; // 商品单价
@property (nonatomic, copy) NSString *spuCode;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *unitMsg; // 最小包装单位描述

//@property (nonatomic, copy) NSString *limitInfo;        // 限购
@property (nonatomic, assign) BOOL limitProduct;        // 商品是否限购
@property (nonatomic, assign) NSInteger limitNum;       // 商品限购数量
@property (nonatomic, assign) NSInteger limitType;      // 限购类型 1-不限购 2-周限购 3-月限购
@property (nonatomic, assign) NSInteger limitCanBuyNum; // 商品限购剩余购买数量

// 自定义属性
@property (nonatomic, assign) FKYVirtualInventoryStockState state;
@property (nonatomic, assign, getter=isItemSelected) BOOL itemSelected;

@end

@interface FKYSubmitCartOrderModel : FKYBaseModel

@property (nonatomic, copy) NSString *changeProductFlag;
@property (nonatomic, copy) NSNumber *couponMoney;
@property (nonatomic, copy) NSString *freight;
@property (nonatomic, copy) NSString *masterOrderFlag;
@property (nonatomic, copy) NSNumber *orderFreight;
@property (nonatomic, copy) NSString *orderFullReductionIntegration;
@property (nonatomic, copy) NSString *orderFullReductionMoney;
@property (nonatomic, copy) NSString *orderUuid;
@property (nonatomic, copy) NSNumber *payType;
@property (nonatomic, copy) NSNumber *supplyId;
@property (nonatomic, copy) NSArray<NSString *> *shopCartIdList;

@end

//API 接口数据转换
@interface FKYYSubmitCartModel : FKYBaseModel

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *billType;
@property (nonatomic, copy) NSString *couponCode;
@property (nonatomic, copy) NSString *billInfoJson;
@property (nonatomic, copy) NSString *isPart;
@property (nonatomic, copy) NSArray<FKYSubmitCartOrderModel *> *orderList;
@property (nonatomic, copy) NSArray<FKYVirtualInventoryProductModel *> *productList;
@property (nonatomic, copy) FKYVirtualInventoryPriceModel *orderMoney;

@end

@interface FKYVirtualInventoryModel : FKYBaseModel

/* 接口解析属性 */
@property (nonatomic, assign) NSInteger submitStatus; // 虚拟库存状态: 1、全部有货 2、部分有货、3、全部没货
@property (nonatomic, strong) FKYVirtualInventoryPriceModel *priceModel; // 部分缺货页面底部-订单金额信息面板-ui展示所需对象
@property (nonatomic, copy) NSArray *productModels; // 部分缺货页面-缺货商品明细-ui展示所需对象
@property (nonatomic, copy) FKYYSubmitCartModel *orderUrl; // 部分缺货页面-再次调用提交订单接口时的入参（submitStatus=2时才返回该字段）

/* 业务逻辑自定义属性 */
@property (nonatomic, copy) NSArray *supplyNames; // 缺货页面-顶部三方供应厂商发货提示文描-所需数组对象

- (NSDictionary *)changeOrderURL2Dic;
+ (FKYVirtualInventoryModel *)changeOrderURLDic2Model:(NSDictionary *)dataDictionary;
- (NSArray *)shopCartIdList;
- (void)filterProducts;
- (void)filterProductsWhenStockChanged;

@end

