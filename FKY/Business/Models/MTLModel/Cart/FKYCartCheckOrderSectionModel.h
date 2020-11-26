//
//  FKYCartCheckOrderSectionModel.h
//  FKY
//
//  Created by airWen on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  检查订单接口返回model...<shopCartList中的单个订单model>

#import "FKYBaseModel.h"
#import "FKYHuaBeiInstallmentModel.h"

@class FKYCartCheckOrderProductModel;


@interface FKYCartCheckOrderSectionModel : FKYBaseModel

@property (nonatomic, assign)int supplyId;
@property (nonatomic, assign) NSInteger isZiYingFlag;//判断是否是自营
//@property (nonatomic, assign) NSInteger supplyType;//判断是否是自营
@property (nonatomic, copy) NSString *supplyName;
@property (nonatomic, assign) double productPriceCount; // 商品金额
@property (nonatomic, assign) double orderFullReductionMoney; // 满减优惠金额
@property (nonatomic, assign) BOOL showCouponText;  // 是否显示优惠码
@property (nonatomic, copy) NSString *allOrderShareCouponMoneyTotal;//金额满减
@property (nonatomic, copy) NSString *couponSum;//金额满减
@property (nonatomic, copy) NSString *orderCouponShareMoney; // 当前订单优惠券均摊金额
@property (nonatomic, copy) NSString *flagUniquePromotionChange; // 统一单的主单和子弹该标志符是一致的
@property (nonatomic, assign) NSInteger masterOrderFlag; //主单标志：1-主单， 0-子单
@property (nonatomic, assign) NSInteger changeProductFlag; //是否参与换购：1-参与， 0-不参与
@property (nonatomic, assign) double orderPayMoney; // 满减优惠金额
@property (nonatomic, assign) float orderFullReductionIntegration; // 满送积分
@property (nonatomic, assign) NSInteger giftFlag;

@property (nonatomic, copy) NSString *orderFreight;//总邮费
@property (nonatomic, copy) NSString *freight;//分单邮费 24.65

@property (nonatomic, assign) BOOL isOnlyZhongJinPay; // 是否是中金支付
@property (nonatomic, copy) NSString *orderUuid;//拆单标示
@property (nonatomic, copy) NSString *payTypeId;
@property (nonatomic, copy) NSString *payType; // 支付类型 paytype 1：在线支付 3：线下支付
@property (nonatomic, copy) NSString *payTypeDesc;//支付方式名称

@property (nonatomic, copy) SalesModel *adviser; // 销售顾问
@property (nonatomic, copy) NSString *msg; // 留言

@property (nonatomic, assign) double orderCouponMoney; // 新增，该订单已选的优惠券优惠总金额
@property (nonatomic, copy) NSString *checkCouponCodeStr; // 新增，已选优惠券
@property (nonatomic, copy) NSString *orderChangeFlag; // 新增，标记当前订单是否是换购品订单， 1 是，0 不是
@property (nonatomic, copy) NSString *checkPlatformCoupon; // 新增，是否使用平台优惠券，1 是，0 不是，
@property (nonatomic, copy) NSString *showCouponCode; // 新增，新增，已输入的优惠券码
@property (nonatomic, assign) BOOL hasAvailableCoupon;  // 是否有可用优惠券
@property (nonatomic, copy) NSString *noAvailableCouponTxt;// 无可用优惠券
@property (nonatomic, assign) NSInteger checkCouponNum;  // 已用优惠券数量

@property (nonatomic, copy) NSString *couponType;//0是要使用优惠券， 1是优惠券码
@property (nonatomic, copy) NSString *couponCode;//优惠券码
//从“购物车”的商品列表数据而来
@property (nonatomic, assign) double fullReductionMoney;//满减金额

@property (nonatomic, assign) double orderRebateMoney;        //订单可使用的返利金抵扣金额  BigDecimal
@property (nonatomic, assign) double orderUseRebateMoney;          //用户输入的返利金抵扣    BigDecimal
@property (nonatomic, assign) double orderCanGetRebateMoney;  // 订单完成可获得的返利金   BigDecimal

// 2018.05.03 加入
@property (nonatomic, assign) float freeFreightAmount;             // 供应商的免运费金额标准（包邮门槛）
@property (nonatomic, assign) float needAmount;                   //订单起售金额差额（= 起售金额 - 商品总额 + 满减金额）
//@property (nonatomic, assign) float freight;  // 实际运费（等于 0 或者 supplyFreight）
@property (nonatomic, assign) float minScalePrice;                     // 商家起售金额
@property (nonatomic, copy) NSString *buyerProvinceName;                     // 买家省份
@property (nonatomic, copy) NSString *rebateLimitPercent;        //该商家设置的可用返利金比例(只返回比例的值  如：8 代表8%)

// 订单中的商品数组
@property (nonatomic, strong) NSArray<FKYCartCheckOrderProductModel *> *products;

@property (nonatomic, assign) BOOL isAllMutexTeJia;//":1,   //订单中是否全是与优惠券互斥特价商品   1：是   0：不是
@property (nonatomic, copy) NSString *noSelectCoupon4MutexTeJia;//":"",  //由于订单中全是优惠券互斥特价商品导致优惠券无法选择的原因
@property (nonatomic, copy) NSString *noSelectCouponCode4MutexTeJia;//":"",  //由于订单中全是优惠券互斥特价商品导致优惠码无法选择的原因

// 花呗分期
@property (nonatomic, assign) BOOL isSelectHuaBei;
@property (nonatomic, assign) NSInteger installmentIndex;
@property (nonatomic, strong) NSArray<FKYSubInstallmentModel *> * hbInstalmentInfoDtoList;                    // 花呗分期费率列表

@end



