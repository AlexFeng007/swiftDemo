//
//  FKYProductGroupModel.h
//  FKY
//
//  Created by 夏志勇 on 2017/12/22.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详之套餐model

#import <Foundation/Foundation.h>
#import "FKYProductGroupItemModel.h"
#import "FKYBaseModel.h"


@interface FKYProductGroupModel : FKYBaseModel <NSCopying>

@property (nonatomic, copy) NSString *useDesc;          // 使用说明
@property (nonatomic, copy) NSString *promotionName;    // 套餐标题
@property (nonatomic, strong) NSNumber *promotionId;    // 套餐id
@property (nonatomic, strong) NSNumber *endTime;        // 套餐活动结束时间
@property (nonatomic, strong) NSNumber *promotionRule;  // 促销活动规则 1-搭配套餐 2-固定套餐
@property (nonatomic, strong) NSNumber *maxBuyNum;      // 当为固定套餐时，当前用户可购买的最大套餐数
@property (nonatomic, strong) NSNumber *maxBuyNumPerDay;      // 当为固定套餐时，每日限购数量

@property (nonatomic, strong) NSArray<FKYProductGroupItemModel *> *productList; // 套餐中商品列表

// 本地新增业务字段
@property (nonatomic, assign) NSInteger groupNumber; // 购买数量...<默认为1>...<仅针对固定套餐>

- (NSInteger)getGroupNumber;

- (void)setNumberForAdd:(NSInteger)number;
- (void)setNumberForMinus:(NSInteger)number;
- (void)checkNumberForInput:(NSInteger)number;
- (BOOL)checkAddBtnStatus;
- (BOOL)checkMinusBtnStatus;
// 获取固定套餐的最大可加车数
- (NSInteger)getMaxGroupNumber;

@end
