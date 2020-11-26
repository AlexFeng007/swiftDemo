//
//  FKYCartModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

//@class FKYCartProductModel;
@class FKYCartOfInfoModel;


@interface FKYCartModel : NSObject

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger productCount;   // 购物车中商品数量
@property (nonatomic, strong) NSMutableArray<FKYCartOfInfoModel *> *productArr; //购物车中的部分字段
/*一起购商品数量*/
@property (nonatomic, assign) NSInteger togeterBuyProductCount;   // 一起购购物车中商品数量
@property (nonatomic, strong) NSMutableArray<FKYCartOfInfoModel *> *togeterBuyProductArr; //购物车中的部分字段

@property (nonatomic, strong) NSMutableArray<FKYCartOfInfoModel *> *mixProductArr; //获取混合商品购物车数量

+ (FKYCartModel *)shareInstance;

- (NSInteger)badgeValue;
- (void)initilizeLocalProduct;


@end


@interface FKYCartOfInfoModel : NSObject

@property (nonatomic, strong) NSNumber *buyNum;//已加车数
@property (nonatomic, strong) NSNumber *cartId;//购物车id
@property (nonatomic, strong) NSString *spuCode;//spu编码
@property (nonatomic, strong) NSNumber *supplyId;//供应商id
@property (nonatomic, strong) NSNumber *promotionId;//一起购活动id，套餐id
@property (nonatomic, strong) NSNumber *fromWhere;//2一起购商品 其他普通
@property (nonatomic, strong) NSArray *comboItems;//套餐商品数组

@end
