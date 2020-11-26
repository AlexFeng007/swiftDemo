//
//  FKYCartCheckOrderProductModel.h
//  FKY
//
//  Created by airWen on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYCartCheckOrderProductModel : FKYBaseModel

@property (nonatomic, assign) float shareMoney; // 新增，商品均摊的满减金额
@property (nonatomic, copy) NSString *shoppingCartId; // 购物车id
@property (nonatomic, copy) NSString *promotionType; // 套餐(促销)类型 eg:13
@property (nonatomic, strong) NSNumber *promotionId; // 套餐(促销)id eg:15155
@property (nonatomic, copy) NSString *shoppingCartChangeId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *factoryName;
@property (nonatomic, assign) NSInteger minimumPacking;
@property (nonatomic, strong) FKYProductPromotionModel *productPromotion;
@property (nonatomic, strong) NSArray<CartPromotionModel *> *promotionList; // 满减促销列表
@property (nonatomic, copy) NSString *productGetRebateMoney;//返利的金额
@property (nonatomic, strong) NSNumber *showRebateMoneyFlag;//是否展示返利标识1:展示
@property (nonatomic, copy) NSString *batchNo; // 商品批号
@property (nonatomic, copy) NSString *deadLine; //  商品有效期
@property (nonatomic, assign) BOOL isMutexTeJia;//":1  //是否是与优惠券互斥特价商品   1：是   0：不是
@property (nonatomic, assign) NSInteger isNearEffect;  //近效期
@property (nonatomic, copy) NSString *productCodeCompany; // 公司编码

@end
