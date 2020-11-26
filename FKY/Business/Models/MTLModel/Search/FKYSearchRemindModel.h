//
//  FKYSearchRemindModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  搜索之实时联想搜索model

#import "FKYBaseModel.h"

@interface FKYSearchRemindModel : FKYBaseModel

@property (nonatomic, copy) NSString *factoryName;  // 生产商名称?
@property (nonatomic, copy) NSString *proStoreName; // 搜索关键词
@property (nonatomic, copy) NSString *drugName; // 搜索关键词
@property (nonatomic, copy) NSString *sellerName;   // 商家(供应商)名称
@property (nonatomic, strong) NSNumber *sellerCode; // 商家(供应商)id
@property (nonatomic, strong) NSNumber *type;       // 搜索类型...1:商品 2:店铺?

/// 专给埋点用的
@property (nonatomic, strong) NSNumber *index;

@end
