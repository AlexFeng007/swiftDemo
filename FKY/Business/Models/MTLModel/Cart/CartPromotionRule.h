//
//  CartPromotionRule.h
//  FKY
//
//  Created by yangyouyong on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  

#import "FKYBaseModel.h"

//加购价的“赠品”数据
@interface PromotionChangeGiftProductModel : FKYBaseModel
@property (nonatomic, copy) NSNumber * changePrice;  // 加价价钱
@property (nonatomic, assign) NSInteger changeQuantity; //送的赠品数量
@property (nonatomic, copy) NSString *unitCn; //送的赠品单位
@property (nonatomic, copy) NSString *shortName; //赠品名
@end


@interface CartPromotionRule : FKYBaseModel
@property (nonatomic, copy) NSNumber *promotionSum;  // 满多少元（件）
@property (nonatomic, copy) NSNumber *promotionMinu; // 减多少元(折)。送多少积分。送什么赠品
@property (nonatomic, strong) NSArray<PromotionChangeGiftProductModel *> *productPromotionChange;
@end
