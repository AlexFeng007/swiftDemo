//
//  FKYCartControllerURLMap.m
//  FKY
//
//  Created by yangyouyong on 15/9/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartControllerURLMap.h"
#import "FKYCartSchemeProtocol.h"
#import "FKYPaymentWebViewController.h"
//#import "FKYPaySuccessViewController.h"
#import "FKYShowSaleInfoViewController.h"
#import "FKY-Swift.h"

@implementation FKYCartControllerURLMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
                      NSStringFromProtocol(@protocol(FKY_CheckOrder)) : CheckOrderController.class,
                      NSStringFromProtocol(@protocol(FKY_SelectOnlinePay)) : COSelectOnlinePayController.class,
                      NSStringFromProtocol(@protocol(FKY_COFollowQualificaViewController)) : COFollowQualificaViewController.class,
                      
                      NSStringFromProtocol(@protocol(FKY_CartPaymentWebView)) : FKYPaymentWebViewController.class,
//                      NSStringFromProtocol(@protocol(FKY_PaySuccess)) : FKYPaySuccessViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CheckCoupon)) : UseCouponController.class,
                      NSStringFromProtocol(@protocol(FKY_HuaBeiController)) : SelectHuaBeiController.class,
                      NSStringFromProtocol(@protocol(FKY_BillTypeController)) : SelectInvoiceViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CartController)) : SelectInvoiceViewController.class,
                      NSStringFromProtocol(@protocol(FKY_ShowSaleInfoViewController)) : FKYShowSaleInfoViewController.class,
                      NSStringFromProtocol(@protocol(FKY_CartZhongJinUserSubmitSuccess)) : ZJPaySuccessViewController.class,
                      NSStringFromProtocol(@protocol(FKY_YQGCartController)) : YQGCartViewController.class,
                      NSStringFromProtocol(@protocol(FKY_OfflinePayInfo)) : COOfflinePayDetailController.class,
                      NSStringFromProtocol(@protocol(FKY_COProductsListController)) : COProductsListController.class,
                      NSStringFromProtocol(@protocol(FKY_OrderPayStatus)) : FKYOrderPayStatusVC.class,
                      NSStringFromProtocol(@protocol(FKY_QuickPayOrderPayStatus)) : QuickPOrderWaitPayVC.class,
                      NSStringFromProtocol(@protocol(FKY_AddBankCard)) : FKYAddBankCardVC.class,
                      NSStringFromProtocol(@protocol(FKY_AddBankCardVerificationCode)) : FKYAddBankCardVerificationCodeVC.class,
                      NSStringFromProtocol(@protocol(FKY_ApplyWalfareTable)) : FKYApplyWalfareTableVC.class,
                      
                      };
    }
    return self;
}

@end
