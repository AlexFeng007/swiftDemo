//
//  FKYHomeURLMap.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYHomeURLMap.h"
#import "FKYSearchViewController.h"
#import "FKYHomeSchemeProtocol.h"
#import "FKYProductionDetailViewController.h"
#import "FKYProductionBaseInfoController.h"

@implementation FKYHomeURLMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
                      NSStringFromProtocol(@protocol(FKY_Home)) : HomeController.class,
                      NSStringFromProtocol(@protocol(FKY_HotSale)) : HotSaleController.class,
                      NSStringFromProtocol(@protocol(FKY_Search)) : FKYSearchViewController.class,
                      NSStringFromProtocol(@protocol(FKY_NewSearch)) : FKYSearchInputKeyWordVC.class,
                      NSStringFromProtocol(@protocol(FKY_SearchResult)) : FKYSearchResultVC.class,
                      NSStringFromProtocol(@protocol(FKY_ProdutionDetail)) : FKYProductionDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_ProductionBaseInfo)) : FKYProductionBaseInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_ShopCart)) : CartSwitchViewController.class,
                      NSStringFromProtocol(@protocol(FKY_HomeCategory)) : FKYCategoryWebViewController.class,
                      NSStringFromProtocol(@protocol(FKY_SecondKillActivityDetail)) : FKYSecondKillActivityController.class,
                      NSStringFromProtocol(@protocol(FKY_TogeterBuy)) : FKYTogeterBuyViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Togeter_Detail_Buy)) : FKYTogeterBuyDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Togeter_Search_Buy)) : FKYTogeterSearchResultVC.class,
                      NSStringFromProtocol(@protocol(FKY_RedPacket)) : FKYRedPacketViewController.class,
                      //NSStringFromProtocol(@protocol(FKY_Message_List)) : FKYMessageListViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Message_List)) : FKYStationMsgVC.class,
                      NSStringFromProtocol(@protocol(FKY_Send_Coupon_Info)) : SendCouponDetailInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_New_Product_Set_List)) : FKYNewPrdSetHisListViewController.class,
                      NSStringFromProtocol(@protocol(FKY_New_Product_Set_Detail)) : FKYNewPrdSetDeatilViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Hot_Sale_Region)) : FKYHotSaleRegionViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Preferential_Shop)) : FKYPreferentialShopsViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Package_Rate)) : FKYPackageRateViewController.class,
                      NSStringFromProtocol(@protocol(FKY_Product_Pinkage)) : FKYProductPinkageViewController.class
                      };
    }
    return self;
}

@end
