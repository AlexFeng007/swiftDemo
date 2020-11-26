//
//  FKYLoginURLMap.m
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYAccountURLMap.h"
#import "FKYAccountSchemeProtocol.h"
#import "FKYSetUpViewController.h"
#import "FKYAllOrderViewController.h"
#import "FKYOrderDetailViewController.h"
#import "FKYAboutUsViewController.h"
#import "FKYOrderDetailMoreInfoViewController.h"
#import "FKYInviteViewController.h"
#import "FKY-Swift.h"
//#import "FKYBatchViewController.h"
#import "FKYLogisticsViewController.h"
#import "FKYLogisticsDetailViewController.h"
#import "FKYRefuseListViewController.h"
#import "FKYJSOrderDetailViewController.h"
#import "FKYReceiveProductViewController.h"
#import "FKYFindPeoplePayViewController.h"
#import "FKYJSBHApplyViewController.h"
//#import "FKYRebateViewController.h"
#import "FKYSalesManViewController.h"
//#import "FKYRebateDetailViewController.h"
#import "FKYOrderStatusViewController.h"

@implementation FKYAccountURLMap
    
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
                      NSStringFromProtocol(@protocol(FKY_MyCoupon)) : MyCouponController.class,
                      //NSStringFromProtocol(@protocol(FKY_MySalesMan)) : FKYSalesManViewController.class,
                      NSStringFromProtocol(@protocol(FKY_MySalesMan)) : FKYSalesManVC.class,
                      //NSStringFromProtocol(@protocol(FKY_MyRebate)) : FKYRebateViewController.class,
                      //NSStringFromProtocol(@protocol(FKY_FKYRebateDetailViewController)) :  FKYRebateDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_FKYRebateDetailVC)) :  FKYRebateDetailVC.class,
                      NSStringFromProtocol(@protocol(FKY_Login)) : LoginController.class,
                      NSStringFromProtocol(@protocol(FKY_FindPassword)) : FKYFindPasswordViewController.class,
                      NSStringFromProtocol(@protocol(FKY_SetPassword)) : FKYSetPasswordViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CertainCode)) : FKYGetCodeAfterFindPassViewController.class,
                      NSStringFromProtocol(@protocol(FKY_SetUpController)) : FKYSetUpViewController.class,
                      NSStringFromProtocol(@protocol(FKY_AboutUsController)) : FKYAboutUsViewController.class,
                      NSStringFromProtocol(@protocol(FKY_AllOrderController)) : FKYAllOrderViewController.class,
                      NSStringFromProtocol(@protocol(FKY_OrderStatusController)) : FKYOrderStatusViewController.class,
                      NSStringFromProtocol(@protocol(FKY_OrderDetailController)) : FKYOrderDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_OrderDetailMoreInfoController)) : FKYOrderDetailMoreInfoViewController.class,
                      NSStringFromProtocol(@protocol(FKY_RegisterController)) : RegisterController.class,
                      NSStringFromProtocol(@protocol(FKY_InviteViewController)) : FKYInviteViewController.class,
                     // NSStringFromProtocol(@protocol(FKY_BatchController)) : FKYBatchViewController.class,
                      NSStringFromProtocol(@protocol(FKY_RefuseOrder)) : FKYRefuseListViewController.class,
                      NSStringFromProtocol(@protocol(FKY_LogisticsController)) : FKYLogisticsViewController.class,
                      NSStringFromProtocol(@protocol(FKY_LogisticsDetailController)) : FKYLogisticsDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_JSOrderDetailController)) : FKYJSOrderDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_ReceiveController)) : FKYReceiveProductViewController.class,
                      NSStringFromProtocol(@protocol(FKY_JSBUApplyController)) : FKYJSBHApplyViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CredentialsController)) : CredentialsViewController.class,
                      NSStringFromProtocol(@protocol(FKY_InvoiceQualificationViewController)) : InvoiceQualificationViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CredentialsAddressManageController)) : CredentialsAddressManageController.class,
                      NSStringFromProtocol(@protocol(FKY_CredentialsAddressSendViewController)) : CredentialsAddressSendViewController.class,
                      NSStringFromProtocol(@protocol(FKY_EidtBaseInfo)) : QualiticationEidtBaseInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_BusniessScope)) : QualiticationBusniessScopeController.class,
                      NSStringFromProtocol(@protocol(FKY_QualiticationBaseInfo)) : QualificationBaseInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_RITextController)) : RITextController.class,
                      NSStringFromProtocol(@protocol(FKY_RIImageController)) : RIImageController.class,
                      NSStringFromProtocol(@protocol(FKY_FindPeoplePay)): FKYFindPeoplePayViewController.class,
                      NSStringFromProtocol(@protocol(FKY_OfftenProductList)): OftenBuyProductListController.class,
                      NSStringFromProtocol(@protocol(FKY_OftenSellerListViewController)): OftenBuySellerListController.class,
                      NSStringFromProtocol(@protocol(FKY_MyFavShopController)): FKYMyFavShopController.class,
                      NSStringFromProtocol(@protocol(FKY_AfterSaleListController)): AfterSaleListController.class,
                      //NSStringFromProtocol(@protocol(FKY_ASApplyDetailController)): ASApplyDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_ASCredentialsAndReportViewController)): ASCredentialsAndReportViewController.class,
                      NSStringFromProtocol(@protocol(FKY_ASProductNumWrongController)): ASProductNumWrongController.class,
                      NSStringFromProtocol(@protocol(FKY_ASAttachmentController)): ASAttachmentController.class,
                      //NSStringFromProtocol(@protocol(FKY_ReturnChangeListController)): ReturnChangeListController.class,
                      //NSStringFromProtocol(@protocol(FKY_ReturnChangeDetailController)): ReturnChangeDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_RCSendInfoController)): RCSendInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_RCSubmitInfoController)): RCSubmitInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_RCTypeSelController)): RCTypeSelController.class,
                      NSStringFromProtocol(@protocol(FKY_BuyerComplainDetailController)): BuyerComplainDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_BuyerComplainController)): BuyerComplainInputController.class,
                      NSStringFromProtocol(@protocol(FKY_RebateInfoController)): RebateInfoController.class,
                      NSStringFromProtocol(@protocol(FKY_FKYYflIntroDetailViewController)): FKYYflIntroDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_DelayRebateDetailController)): DelayRebateDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_RCBankInfoController)): RCSubmitBankViewController.class,
                      NSStringFromProtocol(@protocol(FKY_AuthCodeLogin)): AuthCodeLoginController.class,
                      NSStringFromProtocol(@protocol(FKY_RebateDetailController)): RebateDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_ShopAllProductController)): ShopAllProductViewController.class,
                      NSStringFromProtocol(@protocol(FKY_ShopCouponProductController)): CouponProductListViewController.class,
                      NSStringFromProtocol(@protocol(FKY_PDLowPriceNoticeVC)): PDLowPriceNoticeVC.class,
                      NSStringFromProtocol(@protocol(FKY_ArrivalProductNoticeVC)): ArrivalProductNoticeVC.class,
                      NSStringFromProtocol(@protocol(FKY_FKYInvoiceViewController)): FKYInvoiceViewController.class,
                      NSStringFromProtocol(@protocol(FKY_HomePromotionMsgListInfoVC)):HomePromotionMsgListInfoVC.class,
                      NSStringFromProtocol(@protocol(FKY_OrderLogisticsMsgVC)):OrderLogisticsMsgVC.class,
                      NSStringFromProtocol(@protocol(FKY_ExpiredTipsMessageVC)):ExpiredTipsMessageVC.class,
                      NSStringFromProtocol(@protocol(FKY_PriceChangeNoticeVC)):PriceChangeNoticeVC.class,
                      NSStringFromProtocol(@protocol(FKY_ScanVC)):FKYScanVC.class,
                      NSStringFromProtocol(@protocol(FKY_NewProductRegisterVC)):FKYNewProductRegisterVC.class,
                      NSStringFromProtocol(@protocol(FKY_ShoppingMoneyBalanceVC)):FKYshoppingMoneyBalanceVC.class,
                      NSStringFromProtocol(@protocol(FKY_ShoppingMoneyRechargeVC)):FKYShoppingMoneyRechargeVC.class,
                      NSStringFromProtocol(@protocol(FKY_FKYLiveViewController)):FKYLiveViewController.class,
                      NSStringFromProtocol(@protocol(FKY_FKYVodPlayerViewController)):FKYVodPlayerViewController.class,
                      NSStringFromProtocol(@protocol(FKY_FKYVideoPlayerDetailVC)):FKYVideoPlayerDetailVC.class,
                      NSStringFromProtocol(@protocol(FKY_LiveContentListViewController)):LiveContentListViewController.class,
                      NSStringFromProtocol(@protocol(FKY_LiveEndViewController)):LiveEndViewController.class,
                      NSStringFromProtocol(@protocol(FKY_LiveNticeDetailViewController)):LiveNticeDetailViewController.class,
                      NSStringFromProtocol(@protocol(FKY_LiveRoomInfoVIewController)):LiveRoomInfoVIewController.class,
                      };
    }
    return self;
}
    
@end

