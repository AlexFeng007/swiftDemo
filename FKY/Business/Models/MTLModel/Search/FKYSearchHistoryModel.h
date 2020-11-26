//
//  FKYSearchHistoryModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  搜索之搜索历史model

#import "FKYBaseModel.h"

@interface FKYSearchHistoryModel : FKYBaseModel

@property (nonatomic, copy) NSString *name;         // 商品名称
@property (nonatomic, copy) NSString *vender;       // 商家名称
@property (nonatomic, strong) NSNumber *venderid;   // 商家id
@property (nonatomic, strong) NSDate *addedDate;    // 添加日期
@property (nonatomic, strong) NSNumber *type;       // 类型...<店铺or商品>
/// 这个item的类型 flodItem_up折叠状态，箭头朝下/  flodItem_down展开状态，箭头朝上 是折叠类型，否则是正常的搜索词
@property (nonatomic, strong) NSString *itemType;

@end
