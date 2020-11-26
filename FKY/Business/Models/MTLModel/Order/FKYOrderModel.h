//
//  FKYOrderModel.h
//  FKY
//
//  Created by mahui on 15/12/1.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"
@class FKYPersonModel;


static NSString *const orderStatus_compelited = @"已完成";
static NSString *const orderStatus_unpay      = @"待付款";
static NSString *const orderStatus_receive    = @"待收货";
static NSString *const orderStatus_cancle     = @"已取消";
static NSString *const orderStatus_all        = @"全部";
static NSString *const orderStatus_ship       = @"待发货";
static NSString *const orderStatus_rejected   = @"拒收中";
static NSString *const orderStatus_replenishment = @"补货中";
static NSString *const orderStatus_unconfirm = @"待确认";
static NSString *const orderStatus_closed = @"已关闭";
static NSString *const orderStatus_refund = @"退款中";

static NSString *const orderStatus_JSBU = @"拒收&补货中";


static NSString *const deliveryMethod_own = @"自有物流";
static NSString *const deliveryMethod_third = @"第三方物流";

static NSString *const payType_xxzz = @"线下支付";
static NSString *const payType_pc_xszf = @"PC线上支付";
static NSString *const payType_zfb = @"支付宝支付";
static NSString *const payType_upay = @"银联支付";
static NSString *const payType_yiloan = @"1药贷支付";
static NSString *const payType_xszf = @"线上支付";
static NSString *const payType_wx = @"微信支付";
static NSString *const payType_zrdf = @"找人代付";



@interface FKYOrderModel : FKYBaseModel

/**
 *  供应商联系方式
 */
@property (nonatomic, strong)  NSString *qq;
@property (nonatomic, strong)  NSString *enterpriseTelephone;
@property (nonatomic, strong)  NSString *enterpriseCellphone;
@property (nonatomic, strong)  NSString *bdName;   // 招商经理姓名
@property (nonatomic, strong)  NSString *bdPhone;  // 招商经理电话
/**
 *  支付方式
 */
@property (nonatomic, strong)  NSString *orderPayType;
/**
 *  支付方式 1、线上支付 2、账期支付 3、线下支付
 */
@property (nonatomic, strong)  NSString *payType;
@property (nonatomic, copy) NSString *payName; // 支付方式
/**
 *  支付方式 1 1 在线支付 chinaPayService 银联B2C支付
 2 2 账期支付 PaymentTerm 账期支付
 3 3 线下支付 DownLine 线下转账
 4 1 在线支付 chinaPayService 银联无卡支付
 5 1 在线支付 cmbPayService 招商银行支付
 6 1 在线支付 chinaPayService 银联B2B支付
 7 1 在线支付 aliPayService 支付宝WEB
 8 1 在线支付 aliPayService 支付宝APP
 9 1 在线支付 chinaPayService 银联手机支付
 10 1 在线支付 cmbEPlusPayService 招行E+支付
 找人代付???
 */
@property (nonatomic, strong)  NSNumber *payTypeId;
/**
 *  配送方式
 */
@property (nonatomic, strong)  NSString *deliveryMethod;
/**
 *  发票类型
 */
@property (nonatomic, strong)  NSString *billType;
/**
 *  电子发票代码详情
 */
@property (nonatomic, strong)  NSArray *invoiceDtoList;
/**
 *  电子随货同行单（数组中存放图片链接字符串）
 */
@property (nonatomic, strong)  NSArray *picurlList;
/**
 *  总金额
 */
@property (nonatomic, strong)  NSNumber *orderTotal;
/**
 *  优惠券
 */
@property (nonatomic, strong)  NSNumber *couponMoney;
/**
 *  支付金额
 */
@property (nonatomic, strong)  NSNumber *finalPay;
/**
 *  订单异常编码
 */
@property (nonatomic, strong)  NSString *exceptionOrderId;
/**
 *  申请时间
 */
@property (nonatomic, strong)  NSString *applyTime;
/**
 *  申请说明
 */
@property (nonatomic, strong)  NSString *returnDesc;
/**
 *  商家回复
 */
@property (nonatomic, strong)  NSString *merchantDesc;
/**
 *  商品数量
 */
@property (nonatomic, strong)  NSNumber *productNumber;
/**
 *  分类
 */
@property (nonatomic, strong)  NSNumber *varietyNumber;
/**
 *  支付剩余时间
 */
@property (nonatomic, strong)  NSString *residualTime;
/**
 *  订单Id
 */
@property (nonatomic, strong)  NSString *orderId;
/**
 *  订单type 1：一起购订单 3：一起拼订单 
 */
@property (nonatomic, strong)  NSString *orderType;
/**
 *  订单状态
 */
@property (nonatomic, strong)  NSString *orderStatus;
/**
 订单状态文描
 */
@property (nonatomic, copy) NSString *orderStatusName;
/**
 *  供应商
 */
@property (nonatomic, strong)  NSString *supplyName;
/**
 *  下单时间
 */
@property (nonatomic, strong)  NSString *createTime;
/**
 *  收货地址
 */
@property (nonatomic, strong)  FKYPersonModel *address;
/**
 *  订单中商品数组
 */
@property (nonatomic, strong)  NSArray *productList;
/**
 *  留言
 */
@property (nonatomic, strong) NSString *leaveMsg;

/**
 *  延期次数
 */
@property (nonatomic, strong) NSString *delayTimes;
/**
 *  能延期次数
 */
@property (nonatomic, strong) NSString *postponeTime;
/**
 *  销售顾问名称
 */
@property (nonatomic, strong) NSString *adviserName;
/**
 *  销售顾问电话
 */
@property (nonatomic, strong) NSString *adviserPhoneNumber;
/**
 *  供应商id
 */
@property (nonatomic, assign) int supplyId;
/**
 *  判断是否自营(1表示自营)
 */
@property (nonatomic, assign) NSInteger isZiYingFlag; 
/**
 *  是否包含留言
 */
@property (nonatomic, assign)NSInteger hasSellerRemark;
/**
 *  卖家给买家留言
 */
@property (nonatomic, strong) NSString *sellerToBuyerRemark;
/**
 *  部分发货剩余商品状态 1,补发，2退款，否则null
 */
@property (nonatomic, strong) NSNumber *partDeliveryType;
/**
 *  是否部分发货 1:YES   0:NO
 */
@property (nonatomic, strong) NSNumber *portionDelivery;

//部分发货剩余商品补货订单id
@property (nonatomic, strong) NSString *originalDeliveryId;
//收货补货ID
@property (nonatomic, strong) NSString *originalReceiveId;

// 立减金额
@property (nonatomic, strong) NSNumber *orderFullReductionMoney;

// 积分
@property (nonatomic, strong) NSNumber *orderFullReductionIntegration;

// 赠品
@property (nonatomic, strong) NSString *orderPromotionGift;

// 赠品
@property (nonatomic, strong) NSString *freight;
// 包邮规则
@property (nonatomic, strong) NSArray *ruleList;
// 包邮规则文字描述（根据包邮规则计算文字描述）
@property (nonatomic, strong) NSArray *ruleStrList; //自定义字段

//加价购 加价换购赠品的订单的父订单id
@property (nonatomic, strong) NSNumber *parentOrderId;
//是否参与换购
@property (nonatomic, strong) NSNumber *isPromotionChange;

//是否展示以及销售合同是否随货
@property (nonatomic, strong) NSNumber *isPrintContract;
@property (nonatomic, strong) NSNumber *viewPrintContract;

//小能settingid，长度大于0显示按钮
//@property (nonatomic, strong) NSString *xiaoNengId;
// 分享链接
@property (nonatomic, copy) NSString *sharePayUrl; // 找人代付需求新增字段

// 优惠券相关...<接口新增>
@property (nonatomic, strong) NSNumber *orderCouponMoney;           // 店铺劵
@property (nonatomic, strong) NSNumber *orderPlatformCouponMoney;   // 平台劵

@property (nonatomic, strong) NSNumber *shopRechargeMoney;      // 使用的购物金（6.7.2开始使用）

// 是否中金支付，"Y" 是，"N" 否，中金支付新增字段
@property (nonatomic, copy) NSString *zhongJinPayFlag;
@property (nonatomic, assign) BOOL isZhongjin; // 非api字段
//退换货
@property (nonatomic, assign) BOOL selfHasReturnOrder;//订单详情 判断有无退换货
@property (nonatomic, assign) BOOL selfCanReturn;//订单列表 判断可不可以退换货
@property (nonatomic, assign) BOOL selfReturnApplyStatus;//订单列表判断是否可以点击退换货 0 可 1不可
// 返利金抵扣金额
//@property (nonatomic, strong) NSString *orderRebateDeductibleMoney;
@property (nonatomic, strong) NSNumber *useEnterpriseRebateMoney; ///订单使用的商家返利金
@property (nonatomic, strong) NSNumber *usePlatformRebateMoney; ///订单使用的平台返利金
// 获得返利金金额
@property (nonatomic, strong) NSString *orderRebateObtainMoney;

@property (nonatomic, assign) NSInteger inventoryStatus; //0：组货中    1组货成功
@property (nonatomic, strong) NSString *arrivalTime;//调拨预计到货时间
@property (nonatomic, strong) NSString *arrivalTips;//调拨预计到货文字描述

// 订单地址id...<选择补货的发货地址id>
@property (nonatomic, copy) NSString *selectDeliveryAddressId;

// 本地新增字段
@property (nonatomic, copy)  NSString *offlineDescribe4Mp;      // 7天未付款则自动取消
@property (nonatomic, copy)  NSString *offlineDescribe4Self;    // 48小时未付款则自动取消


// 子订单列表
@property (nonatomic, strong) NSArray *childOrderBeans;
@property (nonatomic, assign) NSInteger parentOrderFlag; //1:是 合并支付未支付的单子  0：不是
//按钮字段
@property (nonatomic, strong) NSNumber *isCanPay;//是否可立即支付,1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isCanOffline;//是否可线下转账，1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isRepurchase;//再次购买，1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isCanOtherPay;//是否可找人代付，1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isCanSharePay;//是否可分享支付信息，1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isCanCancel;//是否可取消,1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isSupportIM;//是否支持IM(客服),1-不支持，0-支持
@property (nonatomic, strong) NSNumber *isQueryLogistic;//查看物流, 1-不可以， 0-可以
@property (nonatomic, strong) NSNumber *isReceive;//确认收货，1-不可以，0-可以；
@property (nonatomic, strong) NSNumber *isCanReturn;//自营订单 申请售后,1-不可以， 0-可以
@property (nonatomic, strong) NSNumber *isdelayReceive;//延期收货,1-不可以，0-可以；
@property (nonatomic, strong) NSNumber *isEvaluate;//去评价,-1-不展示， 1-已评价，0-去评价
@property (nonatomic, copy) NSString *complaintFlag;//-1:不展示投诉入口；0:-“投诉商家”,1-“查看投诉”
@property (nonatomic, strong) NSNumber *isHasReject;//查看拒收,1-不可以，0-可以
@property (nonatomic, strong) NSNumber *isHasReplenishment;//查看补货,1-不可以，0-可以
@property (nonatomic, assign) NSInteger mpCanReturn; //mp退货，1--可以，0--不行
// 父订单 中子订单供应商的合集
@property (nonatomic, strong) NSArray *supplyIds;

/// cellType 1是订单类型  2是商品类型
@property (nonatomic,assign)NSInteger cellType;

/// 订单是否支付 1已支付 0未支付
@property (nonatomic,assign)NSInteger isPay;

//是否是换购子弹-用于订单列表的换购标签的显示和隐藏
- (BOOL)isHuanGouSonOrder;

- (NSString *)getBillType;
- (NSString *)getPayType;
- (NSString *)getDeliveryMethod;
- (NSString *)getOrderStatus;

// 判断商品底部的操作栏是否显示
- (BOOL)getHandleBarShowStatus;

@end


/*
 订单状态（orderStatus）说明：
 0: 全部订单
 1: 待付款
 2: 待发货
 3: 待收货
 7: 已完成
 10: 已取消
 800: 拒收中
 850: 拒收&补货中
 900: 补货中
 */

/*
 补货：
 901: 待确认
 902: 待发货
 903: 待收货
 904: 已关闭
 905: 已完成
 */

/*
 拒收：
 801: 待确认
 802: 退款中
 803: 已关闭
 804: 已完成
 */
