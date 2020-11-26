//
//  FKYShopSchemeProtocol.h
//  FKY
//
//  Created by yangyouyong on 2016/9/6.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#ifndef FKYShopSchemeProtocol_h
#define FKYShopSchemeProtocol_h


@protocol FKY_ShopList <NSObject>

@end

@protocol FKY_ShopListCouponCenter <NSObject>

@end

@protocol FKY_ShopItemOld <NSObject>

@property (nonatomic, copy) NSString *shopId;

@end

@protocol FKY_ShopItem <NSObject>

@property (nonatomic, copy) NSString *shopId;

@end

//全部店铺列表
@protocol FKY_ShopAllList <NSObject>


@end

@protocol FKY_ShopHome <NSObject>


@end

//满减/特价
@protocol FKY_AllPrefecture <NSObject>

@end

/// 高毛专区
@protocol FKY_HeightGrossMarginVC <NSObject>

@end

@protocol FKY_ComboList <NSObject>

@property (nonatomic, assign) NSInteger sellerCode;
@property (nonatomic, assign) NSInteger dinnerType;

@end

@protocol FKY_ShopEnterPriseInfo <NSObject>

@end

/// 搭配套餐
@protocol FKY_MatchingPackageVC <NSObject>


@end

#endif
