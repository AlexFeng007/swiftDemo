//
//  FKYProductSpecificationModel.h
//  FKY
//
//  Created by mahui on 15/11/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  商详之说明书

#import "FKYBaseModel.h"

@interface FKYExtModel : FKYBaseModel

@property (nonatomic, copy) NSString *commonName;          // 通用名称
@property (nonatomic, copy) NSString *commonNamePinyin;    // 商品名拼音
@property (nonatomic, copy) NSString *productName;         // 商品名称
@property (nonatomic, copy) NSString *incredinet;          // 成分
@property (nonatomic, copy) NSString *character;           // 性状
@property (nonatomic, copy) NSString *actionType;          // 作用类别
@property (nonatomic, copy) NSString *adaptationDisease;   // 适应症
@property (nonatomic, copy) NSString *directions;          // 用法用量
@property (nonatomic, copy) NSString *untowardEffect;      // 不良反应
@property (nonatomic, copy) NSString *taboo;               // 禁忌
@property (nonatomic, copy) NSString *announcements;       // 注意事项
@property (nonatomic, copy) NSString *drugInteractions;    // 药物相互作用
@property (nonatomic, copy) NSString *pharmacologicAction; // 药理作用
@property (nonatomic, copy) NSString *storage;             // 贮藏
@property (nonatomic, copy) NSString *pack;                // 包装
@property (nonatomic, copy) NSString *expiryDate;          // 有效期
@property (nonatomic, copy) NSString *carriedStandard;     // 执行标准
@property (nonatomic, copy) NSString *manualRevisionDate;  // 说明书修订日期

- (NSString *)mappedForKey:(NSString *)key;
- (NSInteger)numberOfValuesToShow;
- (NSString *)textForIndex:(NSIndexPath *)index;

@end
