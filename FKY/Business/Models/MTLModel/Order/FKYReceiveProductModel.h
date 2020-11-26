//
//  FKYReceiveProductModel.h
//  FKY
//
//  Created by mahui on 16/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp确认收货之商品model

#import "FKYBaseModel.h"

@interface FKYReceiveProductModel : FKYBaseModel

// 接口返回的字段
@property (nonatomic, copy) NSString *productId;                // 商品ID
@property (nonatomic, copy) NSString *productPicUrl;            // 商品图片
@property (nonatomic, copy) NSString *productName;              // 商品名
@property (nonatomic, copy) NSString *spec;                     // 商品规格
@property (nonatomic, copy) NSString *factoryName;              // 生产厂商名称
@property (nonatomic, copy) NSString *batchNumber;              // 批次号
@property (nonatomic, copy) NSString *orderDeliveryDetailId;    // 发货批次id
@property (nonatomic, strong) NSNumber *buyNumber;              // 购买数量
@property (nonatomic, strong) NSNumber *batchId;                // 批次号Id
@property (nonatomic, strong) NSNumber *orderDetailId;          // 订单详情id
@property (nonatomic, strong) NSNumber *deliveryProductCount;   // 实收货数量

// 本地新增业务逻辑字段
@property (nonatomic, assign) NSInteger inputNumber;    // 用户设置的实收货数量

@end
