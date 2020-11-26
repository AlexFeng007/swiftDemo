//
//  CartPromotionModel.h
//  FKY
//
//  Created by yangyouyong on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

typedef enum : NSUInteger {
    CartPromotionType_TeJia = 1,            // 1:特价活动
    CartPromotionType_DanPinMJ = 2,         // 2:单品满减
    CartPromotionType_DuoPinMJ = 3,         // 3:多品满减
    CartPromotionType_DanPinMZ = 5,         // 5:单品满赠
    CartPromotionType_DuoPinMZ = 6,         // 6:多品满赠
    CartPromotionType_DanPinScore = 7,      // 7:单品满送积分
    CartPromotionType_DuoPinScore = 8,      // 8:多品满送积分
    CartPromotionType_DanPinHuanGou = 9,    // 9:单品换购(加价购)
    CartPromotionType_DuoPinHuanGou = 10,   // 10:多品换购
    CartPromotionType_DanPinCustom = 11,    // 11:自定义单品活动
    CartPromotionType_DuoPinCustom = 12,    // 12:自定义多品活动
    artPromotionType_TaoCan = 13,           // 13:套餐活动
    CartPromotionType_HuiYuan = 14,         // 14:会员活动
    CartPromotionType_DanPinManZhe = 15,    // 15:单品满折
    CartPromotionType_DuoPinManZhe = 16,    // 16:多品满折
    CartPromotionType_ProtocolReabte = 101, // 101:协议返利
} CartPromotionType;


@interface CartPromotionModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *promotionId;        // 促销id
@property (nonatomic, strong) NSNumber *promotionMethod;    // 满减方式: 0:减总金额; 1:减每件金额(打折)
@property (nonatomic, strong) NSNumber *promotionType;      // 活动类型: 1:特价活动; 2:单品满减; 3:多品满减; 5:单品满赠；6:多品满赠送; 7:单品满送积分; 8:多品满送积分; 9:单品换购; 10:多品换购; 11:自定义单品活动; 12:自定义多品活动; 13:套餐活动; 14:会员活动; 15:单品满折; 16:多品满折
@property (nonatomic, strong) NSNumber *promotionPre;       // 活动条件: 0:按金额;1:按件数
@property (nonatomic, strong) NSNumber *promotionState;     // 活动状态: 0:有效; 1:已取消

@property (nonatomic, copy) NSString *levelIncre;           // 层级递增 0,不是;1,是
@property (nonatomic, copy) NSString *promotionDesc;        // 优惠描述
@property (nonatomic, strong) NSNumber *limitNum;           // 每个用户可参加次数

@property (nonatomic, strong) NSArray *productPromotionRules; // 递增规则数组

@property (nonatomic, copy, readonly) NSString *promotionDescription;

//主品的单位，用户满件优惠信息的展示，从商品model来
@property (nonatomic, copy) NSString *unit;

- (NSString *)promotionDescWithUnit:(NSString *)unit;
- (NSString *)promotionDescriptionWithoutPromotionType;

@end
