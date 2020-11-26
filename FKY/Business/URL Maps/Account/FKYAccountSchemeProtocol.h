//
//  FKYAccountSchemeProtocol.h
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#ifndef FKY_FKYAccountSchemeProtocol_h
#define FKY_FKYAccountSchemeProtocol_h


@protocol FKY_Account <NSObject>

@end


@protocol FKY_MySalesMan <NSObject>

@end

@protocol FKY_ShopAllProductController <NSObject>
@property (nonatomic, copy) NSString *shopId;      // 店铺ID
@end

@protocol FKY_ShopCouponProductController <NSObject>
@property (nonatomic, copy) NSString *shopId;      // 店铺ID
@property (nonatomic, copy) NSString *couponTemplateId; //优惠券ID
@property (nonatomic, copy) NSString *couponName; //优惠券描述
@end

@protocol FKY_PDLowPriceNoticeVC<NSObject>
@property (nonatomic, strong) FKYProductObject *productObject; //商品信息
@end
 
@protocol FKY_ArrivalProductNoticeVC<NSObject>
@property (nonatomic, copy) NSString *productId;      // 商品编码
@property (nonatomic, copy) NSString *venderId; //商家编码
@property (nonatomic, copy) NSString *productUnit; // 商品包装
@end

@protocol FKY_MyCoupon <NSObject>

@end


@protocol FKY_MyRebate <NSObject>

@end


@protocol FKY_FKYRebateDetailViewController <NSObject>

@end

@protocol FKY_FKYRebateDetailVC <NSObject>

@end

@protocol FKY_MyFavShop <NSObject>

@end


@protocol FKY_Login <NSObject>

@end

@protocol FKY_AuthCodeLogin <NSObject>

@end

@protocol FKY_FindPassword <NSObject>

@end


@protocol FKY_SetPassword <NSObject>

@end

//确认输入验证码
@protocol FKY_CertainCode <NSObject>

@end


@protocol FKY_SetUpController <NSObject>

@end


@protocol FKY_CredentialsController <NSObject>

@property (nonatomic, assign) NSInteger needJumpToDrugScope; // 0-(默认)不自动跳转 1-需要自动跳转
@property (nonatomic, copy) NSString *fromType; //优惠券描述 // 0-(默认)不自动跳转 1-需要自动跳转

@end

@protocol FKY_ExpiredTipsMessageVC <NSObject>

@end

@protocol FKY_HomePromotionMsgListInfoVC <NSObject>

@end

@protocol FKY_OrderLogisticsMsgVC <NSObject>

@end

@protocol FKY_PriceChangeNoticeVC <NSObject>

@end

@protocol FKY_FKYInvoiceViewController <NSObject>

@end


@protocol FKY_InvoiceQualificationViewController <NSObject>

@end


@protocol FKY_CredentialsAddressManageController <NSObject>

@end


@protocol FKY_CredentialsAddressSendViewController <NSObject>

@end


@protocol FKY_AboutUsController <NSObject>

@end


@protocol  FKY_RefuseOrder <NSObject>

@property (nonatomic, assign) NSInteger exceptionType;

@end


@protocol FKY_AllOrderController <NSObject>

@property (nonatomic, assign) BOOL popToCartController;

@end

//订单状态列表
@protocol FKY_OrderStatusController<NSObject>

@end

@protocol FKY_OrderDetailController <NSObject>

@end


@protocol FKY_OrderDetailMoreInfoController <NSObject>

@end


@protocol FKY_SearchOrderController <NSObject>

@end


@protocol FKY_OrderSearchResultController <NSObject>

@property (nonatomic, strong)  NSString *providerText;

@end


@protocol FKY_InviteViewController <NSObject>

@property (nonatomic, copy) void(^completeBlock)(void);

@end


@protocol FKY_RegisterController <NSObject>

@end


@protocol FKY_BatchController <NSObject>

@end


@protocol FKY_LogisticsController <NSObject>

@end


@protocol FKY_LogisticsDetailController <NSObject>

@end


@protocol FKY_AddAddressController <NSObject>

@end


@protocol FKY_JSOrderDetailController <NSObject>

@end


@protocol FKY_ReceiveController <NSObject>

@end


@protocol FKY_JSBUApplyController <NSObject>

@end


@protocol FKY_EidtBaseInfo <NSObject>

@end


@protocol FKY_UploadQualitication <NSObject>

@end


@protocol FKY_BusniessScope <NSObject>

@end


@protocol FKY_AddressInfoController <NSObject>

@end


// 基本资料
@protocol FKY_QualiticationBaseInfo <NSObject>

@end


// 填写基本信息
//@protocol FKY_CredentialsBaseInfo <NSObject>
//
//@end


// 资料管理...<包括企业信息、收货人信息>
@protocol FKY_RITextController <NSObject>

@end


// 资料管理...<上传资质图片>
@protocol FKY_RIImageController <NSObject>

@end


// 返利金详情
@protocol FKY_RebateInfoController <NSObject>

@end

// 药福利介绍页面
@protocol FKY_FKYYflIntroDetailViewController <NSObject>

@end


//待返回返利金详情列表
@protocol FKY_DelayRebateDetailController <NSObject>

@end


// 常购商家
@protocol FKY_OftenSellerListViewController <NSObject>

@end


// 我的收藏
@protocol FKY_MyFavShopController <NSObject>

@end

// 
@protocol FKY_RebateDetailController <NSObject>

@end

// 找人代付
@protocol FKY_FindPeoplePay <NSObject>

@property (nonatomic, copy) NSString *enterpriseId; // 供应商id
@property (nonatomic, copy) NSString *orderid;      // 订单id
@property (nonatomic, assign) float orderMoney;     // 订单金额
@property (nonatomic, assign) BOOL flagFromCO;      // 判断是否从检查订单界面跳转过来

@end


@protocol FKY_OfftenProductList <NSObject>

@end


#pragma mark - 售后工单

// 售后工单 一级列表
@protocol FKY_AfterSaleListController <NSObject>
 
@end

// 售后工单之错漏发
@protocol FKY_ASProductNumWrongController <NSObject>

@end

// 售后工单之选中药检报告服务or选择首营资质服务
@protocol FKY_ASCredentialsAndReportViewController <NSObject>

@end

// 售后工单之随行单据
@protocol FKY_ASAttachmentController <NSObject>

@end

//// 售后工单详情
//@protocol FKY_ASApplyDetailController <NSObject>
//
//@end


#pragma mark - 退换货

//// 退换货列表
//@protocol FKY_ReturnChangeListController <NSObject>
//
//@property (nonatomic, copy) NSString *soNo;  // 订单ID
//@property (nonatomic, assign) int paytype;  // 支付类型
// 
//@end

//// 退换货详情
//@protocol FKY_ReturnChangeDetailController <NSObject>
//
//@end

// 填写退款信息
@protocol FKY_RCBankInfoController <NSObject>

@end

// 选择退换货
@protocol FKY_RCTypeSelController <NSObject>

@end

// 退换货之回寄信息...<提交>
@protocol FKY_RCSendInfoController <NSObject>

@property (nonatomic, copy) NSString *applyId;  // 退换货申请ID
//@property (nonatomic, assign) ReturnChangeType sendType;     // 退货 or 换货
@property (nonatomic, assign) BOOL returnFlag;  // YES-退货 NO-换货
@property (nonatomic, assign) BOOL onlineFlag;  // 是否为线上订单

@property (nonatomic, copy) NSString *addressName;      // 收货地址之名称
@property (nonatomic, copy) NSString *addressPhone;     // 收货地址之手机号
@property (nonatomic, copy) NSString *addressContent;   // 收货地址之地址内容
@property (nonatomic, copy) NSString *addressProvince;  // 收货地址之省名称
@property (nonatomic, copy) NSString *addressCity;      // 收货地址之市名称

@end

// 退货or换货...<提交>
@protocol FKY_RCSubmitInfoController <NSObject>

@property (nonatomic, assign) BOOL returnFlag;      // YES-退货 NO-换货
@property (nonatomic, copy) NSString *orderId;      // 子订单id
@property (nonatomic, strong) NSArray *productList; // 订单中的商品列表

@end


#pragma mark - 投诉商家

// 投诉商家详情和输入
@protocol FKY_BuyerComplainController <NSObject>

@end

@protocol FKY_BuyerComplainDetailController <NSObject>

@end

#pragma mark - 扫码搜索

// 扫码界面
@protocol FKY_ScanVC <NSObject>

@end

// 新品登记页面
@protocol FKY_NewProductRegisterVC <NSObject>

@end


#pragma mark - 购物金余额

/// 购物金余额VC
@protocol FKY_ShoppingMoneyBalanceVC <NSObject>

@end

/// 购物金充值弹窗
@protocol FKY_ShoppingMoneyRechargeVC <NSObject>

@end

#pragma mark - 直播
/// 直播页面
@protocol FKY_FKYLiveViewController <NSObject>

@end

/// 点播页面
@protocol FKY_FKYVodPlayerViewController <NSObject>

@end

//普通视频播放详情
@protocol FKY_FKYVideoPlayerDetailVC <NSObject>

@end

/// 直播列表
@protocol FKY_LiveContentListViewController <NSObject>

@end
/// 直播结束
@protocol FKY_LiveEndViewController <NSObject>

@end

/// 直播预告详情
@protocol FKY_LiveNticeDetailViewController <NSObject>

@end

/// 直播间主页
@protocol FKY_LiveRoomInfoVIewController <NSObject>

@end

#endif



