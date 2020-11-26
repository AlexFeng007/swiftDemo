//
//  FKYReCheckCouponModel.h
//  FKY
//
//  Created by zengyao on 2018/1/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"


@interface FKYReCheckCouponModel : FKYBaseModel

@property (nonatomic) NSInteger denomination; // 优惠券面值
@property (nonatomic, copy) NSString *useTimeStr; // 使用时间
@property (nonatomic)NSInteger isLimitProduct; // 0-不限制 1-限制
@property (nonatomic) NSInteger limitprice; // 使用限制金额，满。。可用
@property (nonatomic ,strong)NSNumber *useProductPrice; //使用的商品金额
@property (nonatomic)NSInteger lessMoneyStyleType; // 0-满足使用金额 1-不满足使用金额
@property (nonatomic, copy) NSString *limitShowText;  //
@property (nonatomic) NSInteger isCheckCoupon; // 是否选中，0-未选中 1-已选中 2-不可选
@property (nonatomic) NSInteger isUseCoupon; // 是否可用，0-不可用 1-可用
@property (nonatomic, copy) NSString *noCheckReason; // 优惠券不可使用原因
@property (nonatomic, copy) NSString *couponCode;
@property (nonatomic, assign) NSInteger tempType;  // 0 店铺券 1 平台券  
@property (nonatomic, copy) NSString *tempEnterpriseName; // 店铺券显示店铺名称，平台券显示 可跨多个店铺使用  都是这个字段
@property (nonatomic, copy) NSString *templateId; // 查看可用商品的链接所需入参
@property (nonatomic, copy) NSString *sellerCode; // 查看可用商品的链接所需入参
@property (nonatomic, copy) NSArray *couponDtoShopList; // 可用店铺列表
@property (nonatomic, assign) BOOL isShowUseShopList; //是否已展示平台券的可用店铺
@property (nonatomic, copy) NSString *couponName; // 优惠券名称
/// 优惠券限制详细描述
@property (nonatomic, copy) NSString *couponDescribe;

-(NSString *)getCouponFullName;//自定义优惠券名称
@end
