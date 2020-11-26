//
//  FKYCartSchemeProtocol.h
//  FKY
//
//  Created by yangyouyong on 15/9/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#ifndef FKYCartSchemeProtocol_h
#define FKYCartSchemeProtocol_h

#import "FKYCartAddressModel.h"
#import "FKYCouponModel.h"
#import "FKYCartSubmitService.h"


// MARK: - CheckOrder

// [新版]检查订单
@protocol FKY_CheckOrder <NSObject>

@property (nonatomic, assign) int fromWhere;            // 来源 "1":立即认购 "2":购物车
@property (nonatomic, strong) NSArray *shoppingCartIds; // 购物车商品id列表
@property (nonatomic, strong) NSArray *productArray;    // 用于判断是否是从一起购进来的...[若当前数组不为空，则为普通订单；反之则为一起购订单]
@property (nonatomic, strong) NSArray *orderProductArray;    // 立即下单 商品列表
 
@end

// [新版]检查订单- 选择首营资料
@protocol FKY_COFollowQualificaViewController <NSObject>
@end
// [新版]选择在线支付方式...<支付界面>
@protocol FKY_SelectOnlinePay <NSObject>

@property (nonatomic, copy) NSString *supplyId;     // 供应商id
@property (nonatomic, copy) NSString *orderId;      // 订单id
@property (nonatomic, copy) NSString *orderMoney;   // 订单金额
@property (nonatomic, copy) NSString *orderType;    // 订单类型
@property (nonatomic, copy) NSString *countTime;    // 订单失效时间间隔...<订单入口会传时间间隔>
@property (nonatomic, copy) NSString *invalidTime;  // 订单失效时间...<购物车/检查订单入口只传失效时间戳,需手动取手机时间来计算时间闹中间隔>
@property (nonatomic, assign) BOOL flagFromCO;      // 判断是否从检查订单界面跳转过来
@property (nonatomic, strong) NSArray  *supplyIdList;
@end


// [新版]线下支付详情
@protocol FKY_OfflinePayInfo <NSObject>

@property (nonatomic, copy) NSString *supplyId;     // 供应商id
@property (nonatomic, copy) NSString *orderId;      // 订单id
@property (nonatomic, copy) NSString *orderMoney;   // 订单金额
@property (nonatomic, copy) NSString *orderType;    // 订单类型
@property (nonatomic, assign) BOOL flagFromCO;      // 判断是否从检查订单界面跳转过来

@end


// MARK: -

@protocol FKY_CartZhongJinUserSubmitSuccess <NSObject>

@end


@protocol FKY_CartPaymentWebView <NSObject>

@property (nonatomic, strong) NSString *webHTMLString;
@property (nonatomic, strong) NSString *schemeString;

@end


//@protocol FKY_PaySuccess <NSObject>
//
//@end

/// 药店福利社申请单
@protocol FKY_ApplyWalfareTable <NSObject>

@end

/// 添加绑定银行卡
@protocol FKY_AddBankCard <NSObject>

@end

/// 绑定银行卡发送验证码页面
@protocol FKY_AddBankCardVerificationCode <NSObject>

@end


/// 订单支付状态界面
@protocol FKY_OrderPayStatus <NSObject>

@end

///  快捷支付 等待支付的页面
@protocol FKY_QuickPayOrderPayStatus <NSObject>

@end

/**
 *  检查订单页商品优惠劵
 */
@protocol FKY_CheckCoupon <NSObject>

@end



@protocol FKY_HuaBeiController <NSObject>

@end


@protocol FKY_BillTypeController <NSObject>

@end


@protocol FKY_ShowSaleInfoViewController <NSObject>

@end


@protocol FKY_CartController <NSObject>


@end

@protocol FKY_YQGCartController<NSObject>

@end


@protocol FKY_COProductsListController <NSObject>

@end


#endif /* FKYCartSchemeProtocol_h */
