//
//  FKYProductRecommendListModel.h
//  FKY
//
//  Created by 夏志勇 on 2019/6/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  说明：当前各Model虽然继承于FKYBaseModel<MTLModel>，但最终未使用Mantle进行解析，而是用的YYModel~!@
//  测试表明：
//  <1> FKYProductRecommendListModel: 当前这种形式的model，使用Mantle无法完全解析，只能使用YYModel。
//  <2> FKYProductHotSaleModel：这种形式的model，使用Mantle可以完全解析.

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"


#pragma mark - 单个商品model

@interface FKYProductItemModel : FKYBaseModel

@property (nonatomic, copy) NSString *productId;    // 商品id
@property (nonatomic, copy) NSString *productImg;   // 商品图片
@property (nonatomic, copy) NSString *productName;  // 商品名称
@property (nonatomic, copy) NSString *showPrice;    // 价格
@property (nonatomic, copy) NSString *spec;         // 规格
@property (nonatomic, copy) NSString *spuCode;      // spuCode
@property (nonatomic, copy) NSString *enterpriseId; // (商家)店铺id
@property (nonatomic, copy) NSString *statusDesc;   // 商品状态
@property (nonatomic, copy) NSString *priceDesc;    // 不显示价格时的原因文描
@property (nonatomic, assign) BOOL flag;            // 是否显示价格

// 注：进商详时，用spuCode和verdorId

@end


/************************************************/


#pragma mark - 店铺信息model

@interface FKYProductShopModel : FKYBaseModel

@property (nonatomic, copy) NSString *enterpriseId;         // 店铺id
@property (nonatomic, copy) NSString *enterpriseLogo;       // 店铺图
@property (nonatomic, copy) NSString *enterpriseName;       // 店铺名称
@property (nonatomic, copy) NSString *totalProductCount;    // 商品总数
@property (nonatomic, copy) NSString *realEnterpriseName;    //     真实的店铺名称    string    新增
@property (nonatomic, assign) bool zhuanquTag;    //     是否专区    boolean    新增
@property (nonatomic, assign) bool ziyingTag ;    //    是否自营    boolean    新增
@property (nonatomic, copy) NSString *ziyingWarehouseName;    //     自营仓简称    string    新增
@property (nonatomic, strong) NSArray<FKYProductItemModel *> *productList; // 商品列表

@end


#pragma mark - 同品热卖model

@interface FKYProductHotSaleModel : FKYBaseModel

@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, strong) NSArray<FKYProductItemModel *> *productList; // 商品列表

// 本地新增业务逻辑字段
@property (nonatomic, assign) NSInteger indexItem; // 当前商品索引<用于分页>

@end


/************************************************/


#pragma mark - 总的接口返回model

@interface FKYProductRecommendListModel : FKYBaseModel

@property (nonatomic, strong) FKYProductShopModel *enterpriseInfo;  // 店铺信息
@property (nonatomic, strong) FKYProductHotSaleModel *hotSell;      // 热卖商品

@end

