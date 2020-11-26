//
//  FKYHomeProductModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

/*
 addSaleSize: 1,
 minSaleSize: 1,
 monomerDrugstorePrice: 25,
 policyPrice: 25,
 policyType: "T",
 productId: 287012,
 productName: "华佗再造丸",
 productProvider: "上海国邦医药有限公司",
 productSize: "80g",
 productVender: "广州奇星药业有限公司"
 */

/*
 addSaleSize: "1",
 minSaleSize: "1",
 monomerDrugstorePrice: "1.8",
 policyPrice: "1.8",
 policyType: "F",
 productId: 301062,
 productName: "医用压脉带(止血带)(D型)",
 productProvider: "上海九州通医药有限公司",
 productSize: "4*6",
 productVender: "常州乐佳",
 suggestPrice: "1.8"
 */

@interface FKYHomeProductionModel : FKYBaseModel

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productProvider;
@property (nonatomic, strong) NSString *productVender;
@property (nonatomic, strong) NSString *policyType; //T阶梯  F固定价格
@property (nonatomic, strong) NSString *productSize; // 规格
@property (nonatomic, assign) CGFloat policyPrice;
//@property (nonatomic, assign) CGFloat suggestPrice;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger supplyId;
@property (nonatomic, assign) CGFloat monomerDrugstorePrice;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, assign) NSInteger baseCount;
@property (nonatomic, assign) NSInteger stepCount;

@property (nonatomic, assign) NSInteger addedCount; // 本地添加的数量

@end
