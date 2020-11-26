//
//  FKYCouponModel.h
//  FKY
//
//  Created by mahui on 15/12/11.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYCouponModel : FKYBaseModel

@property (nonatomic, strong) NSString *customerCouponId; // 优惠券id

@property (nonatomic, strong) NSString *couponNumber; // 优惠券编号

@property (nonatomic, strong) NSString *couponName;   // 优惠券名称

@property (nonatomic, strong) NSString *couponAmount; // 优惠券面值

@property (nonatomic, strong) NSString *couponIcon;   // 优惠券图标

@property (nonatomic, strong) NSString *useMinAmount; // 多少可使用

@property (nonatomic, strong) NSString *useScope; // 使用范围  默认null，所有商品可以使用

@property (nonatomic, strong) NSString *useStatus;// 使用状态，1、未使用2、已使用3、过期

@property (nonatomic, strong) NSString *couponSouce; // 优惠券来源

@property (nonatomic, strong) NSString *startTime;   // 生效期

@property (nonatomic, strong) NSString *endTime;     // 生效期

@property (nonatomic, strong) NSString *useTime;     // 使用时间

@property (nonatomic, strong) NSString *remark;      // 备注

@property (nonatomic, assign) BOOL selectedCoupon;   // 选中的优惠劵

@property (nonatomic, strong) NSString *couponPrinciple;//券使用原则

@property (nonatomic, strong) NSString *couponType;//券类型


@end
