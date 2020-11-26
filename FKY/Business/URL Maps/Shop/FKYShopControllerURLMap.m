//
//  FKYShopControllerURLMap.m
//  FKY
//
//  Created by yangyouyong on 2016/9/6.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYShopControllerURLMap.h"
#import "FKYShopSchemeProtocol.h"
#import "FKY-Swift.h"


@implementation FKYShopControllerURLMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
            NSStringFromProtocol(@protocol(FKY_ShopAllList)) : FKYShopAllListViewController.class,
            NSStringFromProtocol(@protocol(FKY_ShopHome)) : FKYShopHomeViewController.class,
            NSStringFromProtocol(@protocol(FKY_ShopItem)) : FKYNewShopItemViewController.class,
            NSStringFromProtocol(@protocol(FKY_ShopItemOld)) : ShopItemOldViewController.class,
            NSStringFromProtocol(@protocol(FKY_ShopList)):FKYShopListViewController.class,
            NSStringFromProtocol(@protocol(FKY_AllPrefecture)):FKYAllPrefectureViewController.class,
            NSStringFromProtocol(@protocol(FKY_ShopListCouponCenter)):ShopListCouponCenterViewController.class,
            NSStringFromProtocol(@protocol(FKY_ComboList)):FKYComboListViewController.class,
                NSStringFromProtocol(@protocol(FKY_ShopEnterPriseInfo)) : FKYShopEnterpriseInfoViewController.class,
            NSStringFromProtocol(@protocol(FKY_HeightGrossMarginVC)) : FKYHeightGrossMarginVC.class,
            NSStringFromProtocol(@protocol(FKY_MatchingPackageVC)) : FKYMatchingPackageVC.class,
            
        };
    }
    return self;
}

@end
