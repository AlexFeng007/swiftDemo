//
//  FKYProductPromotionModel.h
//  FKY
//
//  Created by mahui on 2016/11/17.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

typedef NS_ENUM(NSUInteger, FKYProductPromotionType) {
    PromotionTypeTeJia = 1, // 特价
    PromotionTypeShanGou = 20, // 闪购
};


@interface FKYProductPromotionModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *limitNum;           // 限购数
@property (nonatomic, copy) NSString *promotionId;          // 促销活动id
//@property (nonatomic, assign) double promotionPrice;        // 促销商品的活动价格（固定套餐无值）
@property (nonatomic, strong) NSNumber *promotionPrice;     // 促销商品的活动价格（固定套餐无值）
@property (nonatomic, strong) NSNumber *currentInventory;   // 当前实时库存
@property (nonatomic, copy) NSString *promotionName;        // 套餐名(活动名称)
@property (nonatomic, assign) NSInteger currentStock;
@property (nonatomic, assign) NSInteger priceVisible;
@property (nonatomic, assign) NSInteger minimumPacking;     //特价时最小批发数量
@property (nonatomic, assign) NSInteger liveStreamingFlag;   // 1直播价

// 说明：当前字段，在购物车接口返回类型为Integer，在商详接口返回类型为String；为解决商详页crash的问题，需统一写成String对象类型以兼容
@property (nonatomic, copy) NSString *promotionType; // 活动类型（14：固定套餐） 1-特价 20-闪购 
//@property (nonatomic, assign) FKYProductPromotionType promotionType; // 1-特价 20-闪购

// 特价限购文描
//@property (nonatomic, copy) NSString *promotionText;

//商品详情中用到字段<特价限购文字描述>
@property (nonatomic, copy) NSString *limitText;

@end
