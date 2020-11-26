//
//  FKYPromationInfoModel.h
//  FKY
//
//  Created by 寒山 on 2018/7/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"
#import "NSArray+Block.h"

@interface FKYPromationInfoModel : FKYBaseModel

@property (nonatomic, copy) NSString *promationDescription;    //      活动描述    string
@property (nonatomic, strong) NSNumber *discountMoney;    //      折扣/满减金额    number    @mock=10
@property (nonatomic, copy) NSString *hyperLink;    //      超链接    string    @mock=hyper link URL
@property (nonatomic, copy) NSString *iconPath;    //      满减图标地址    string    @mock=icon path
@property (nonatomic, strong) NSNumber *id;    //      促销活动ID    number    @mock=15336
@property (nonatomic, copy) NSString *name;    //      促销活动名称    string    @mock=促销测试-单品满减
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *teJiaPrice;    //     特价价格    number    @mock=9.9
@property (nonatomic, strong) NSNumber *point;    //    活动积分    number    @mock=10
@property (nonatomic, strong) NSArray<NSNumber *> *jfShoppingCartIdList;    //    送积分商品ID列表    array<number>
@property (nonatomic, strong) NSArray<NSNumber *> *mzShoppingCartIdList;    //    满赠商品    array<number>    @mock=1123666
@property (nonatomic, strong) NSArray<CartPromotionRule *> *ruleList; // 递增规则数组
@property (nonatomic, strong) NSNumber *promotionPre;
@property (nonatomic, strong) NSNumber * shareMoney;
@property (nonatomic, strong) NSNumber *standard;
@property (nonatomic, strong) NSNumber * state;
@property (nonatomic, strong) NSNumber * method;
@property (nonatomic, strong) NSNumber * limitNum;
@property (nonatomic, strong) NSNumber *promotionType;   // 活动类型;1:特价活动;2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;9:单品换购;11:自定义单品活动; 12:自定义多品活动'
@property (nonatomic, assign) BOOL isMixRebate;    //    判断是不是多品返利
@property (nonatomic,assign) int  type;    //    判断是不是多品满折 还是单品满折 2单 3多
- (NSString *)promotionDescriptionWithoutPromotionType;

//"description": "满200元，立减10元；",
//"discountMoney": null,
//"hyperLink": "",
//"iconPath": "",
//"id": 15081,
//"level": 0,
//"limitNum": -1,
//"method": 0,
//"name": "十一国庆促销",
//"promotionPre": 0,
//"ruleList": [{
//    "promotionMinu": "10",
//    "promotionSum": 200
//}],
//"shareMoney": 10,
//"standard": 0,
//"state": 1
//- (NSString *)showPromotionDesc: (BOOL)showLimit andUnit:(NSString *)unit promotionTypeDes:(NSString *)text;

@end
