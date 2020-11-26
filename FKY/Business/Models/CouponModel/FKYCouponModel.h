//
//  FKYCouponModel.h
//  FKY
//
//  Created by zhangxuewen on 2018/1/10.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  优惠券model
#import <Foundation/Foundation.h>

@property (nonatomic, strong) NSString *couponID;//券号
@property (nonatomic, strong) NSString *couponTitle;//券名称
@property (nonatomic, strong) NSString *couponMoney;//券面额
@property (nonatomic, strong) NSString *couponRule;//券使用规则
@property (nonatomic, strong) NSString *couponType;//券类型
@property (nonatomic, strong) NSString *couponShop;//发放券的商家
@property (nonatomic, strong) NSString *couponPrinciple;//券使用原则
@property (nonatomic, strong) NSString *couponRange;//券使用范围

@end;
