//
//  FKYOrderProductModel.h
//  FKY
//
//  Created by mahui on 16/9/9.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYOrderProductModel : FKYBaseModel

@property (nonatomic, strong) NSString *productPicUrl;      // 图片url
@property (nonatomic, strong) NSString *productId;          // 商品id
@property (nonatomic, strong) NSString *productName;        // 名称
@property (nonatomic, strong) NSString *spec;               // 规格
@property (nonatomic, strong) NSString *unit;               // 单位
@property (nonatomic, strong) NSNumber *productPrice;       // 价格
@property (nonatomic, strong) NSString *factoryName;        // 厂家
@property (nonatomic, strong) NSArray *batchList;           // 批次
@property (nonatomic, strong) NSString *batchNumber;        // 异常订单批次号


@property (nonatomic, strong) NSNumber *quantity;           // 数量
@property (nonatomic, strong) NSNumber *realShipment;       // 实发货数量

@property (nonatomic, strong) NSString *freightTotal;       // 运费
@property (nonatomic, strong) NSString *freight;            //
@property (nonatomic, strong) NSString *productAllMoney;    // 订单总额
@property (nonatomic, strong) NSString *billMoney;          // 开票金额
@property (nonatomic, strong) NSString *productShareMoney;  // 满减金额
@property (nonatomic, assign) NSInteger orderDetailId;      //
@property (nonatomic, assign) NSInteger orderDeliveryDetailId;// mp退货需要字段（非订单列表接口返回）

@property (nonatomic, assign) NSInteger steperCount;        // 退换货模块中作为退换货数量
@property (nonatomic, assign) BOOL checkStatus;             // 
@property (nonatomic, assign) NSInteger promotionType;      // 促销类型
@property (nonatomic, assign) NSInteger inventoryStatus;    // 0：组货中 1：组货成功
@property (nonatomic, strong) NSString *arrivalTips;        // 调拨标签描述
@property (nonatomic, copy) NSString *vendorId;             // 供应商ID
@property (nonatomic, copy) NSString *vendorName;           // 供应商名称

// 若不是虚拟商家，直接传供应商ID；若是虚拟商家，则传虚拟商家ID；
@property (nonatomic, strong) NSNumber *fictitiousId;       // 最终的供应商ID
@property (nonatomic, strong) NSString *shortName;//商品名称

@property (nonatomic, copy) NSString *agreementRebateProductTips;//"协议奖励金"
@property (nonatomic, copy) NSString *normalRebateProductTips;//"预计返利1.69元",
@property (nonatomic, copy) NSString *agreementRebateDetailUrl;//协议奖励金跳转url

@property (nonatomic, strong) NSNumber *payPrice;//实付金额
@property (nonatomic, strong) NSNumber *isSpecialOffer;//是否特价商品，0-是，1-不是
@property (nonatomic, strong) NSNumber *isVip;//是否会员商品,0-是，1-不是
@property (nonatomic, strong) NSNumber *isRebate;//是否返利商品,0-是，1-不是
@property (nonatomic, strong) NSNumber *isFullGift;//是否满赠,0-是，1-不是


////获取库存埋点数据
-(NSString *)getStorageData;
//获取促销埋点数据
-(NSString *)getPm_pmtn_type;
//获取价格埋点数据
-(NSString *)getPm_price;
@end
