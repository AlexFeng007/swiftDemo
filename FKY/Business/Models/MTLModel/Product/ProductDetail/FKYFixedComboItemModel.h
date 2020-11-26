//
//  FKYFixedComboItemModel.h
//  FKY
//
//  Created by 夏志勇 on 2018/4/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  （商祥之固定套餐加车失败后）各商品加车失败的具体原因Model

#import <Foundation/Foundation.h>

@interface FKYFixedComboItemModel : NSObject

/*
statusCode字段说明：
200140001:固定套餐失效";
200140002:固定套餐中存在重复商品";
200140003:加车商品必须为同一套餐活动，且套餐子品必须为两个（含）以上";
200140004:套餐子品已下架";
200140005:您的所在地无法购买此商品";
200140006:套餐子品不在购买渠道范围";
200140007:套餐活动时间超过有效期";
200140008:套餐子品购买套数超过最大可购买套餐数";
200140010:购买数量小于套餐起售门槛";
200140011:购买数量不能大于9999999";
200140012:购买数量不能小于1";
200140013:套餐子品库存不足";
200140014:套餐子品价格异常";
*/

@property(nonatomic, copy) NSString *message;       // 单个商品处理消息 (套餐失效)
@property(nonatomic, copy) NSString *productName;   // 商品名称 (东阿阿胶.测试-维生素B12片)
@property(nonatomic, copy) NSString *specification; // 商品规格 (25ug*100片)
@property(nonatomic, copy) NSString *spuCode;       // 商品SPU（0350ANAH190038)
@property(nonatomic, strong) NSNumber *statusCode;  // 单个商品处理状态（200000001:"失败"时）
@property(nonatomic, strong) NSNumber *supplyId;    // 供应商ID ()
@property(nonatomic, strong) NSNumber *surplusNum;  // 剩余可购买数量

@end
