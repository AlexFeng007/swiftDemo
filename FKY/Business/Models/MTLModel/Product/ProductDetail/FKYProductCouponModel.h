//
//  FKYProductCouponModel.h
//  FKY
//
//  Created by 夏志勇 on 2018/1/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之优惠券model

#import "FKYBaseModel.h"

@interface FKYProductCouponModel : FKYBaseModel

/*********************************************/
// 接口返回字段

// 接口返回的两种优惠券model共用...<可领取与已领取两个接口返回的优惠券model对应的字段不完全一致>
@property (nonatomic, strong) NSNumber *id;                 // id
@property (nonatomic, copy) NSString *enterpriseId;         // 企业id
@property (nonatomic, copy) NSString *couponName;           // 优惠券名称
@property (nonatomic, strong) NSNumber *denomination;       // 优惠券面值
@property (nonatomic, strong) NSNumber *limitprice;         // 使用限制金额
@property (nonatomic, strong) NSNumber *begindate;          // 开始时间
@property (nonatomic, strong) NSNumber *endDate;            // 结束时间
@property (nonatomic, strong) NSNumber *isLimitProduct;     // 是否限制商品 <0-不限制 1-限制>

// CouponTempDto...<可领取>
@property (nonatomic, copy) NSString *templateCode;         // 优惠券模板编号
@property (nonatomic, strong) NSNumber *couponType;         // 优惠券类型
@property (nonatomic, strong) NSNumber *couponStartTime;    // 领券开始时间
@property (nonatomic, strong) NSNumber *couponEndTime;      // 领券结束时间

// CouponDto...<已领取> & <领券>
@property (nonatomic, copy) NSString *couponCode;           // 优惠券号
@property (nonatomic, strong) NSNumber *couponTempId;       // 优惠券模板id
@property (nonatomic, copy) NSString *couponTempCode;       // 优惠券模板编号
@property (nonatomic, strong) NSNumber *status;             // 优惠券状态
@property (nonatomic, strong) NSNumber *useTime;            // 使用时间
@property (nonatomic, copy) NSString *useOrderNo;           // 使用订单
@property (nonatomic, strong) NSNumber *createTime;         // 优惠券领取时间
@property (nonatomic, copy) NSString *tempEnterpriseId;     // 优惠券企业id
@property (nonatomic, copy) NSString *tempEnterpriseName;   // 优惠券企业名称
@property (nonatomic, strong) NSNumber *repeatAmount;       // 每个用户可以领取张数

/*********************************************/
// 非接口返回字段...<本地新增业务字段>


@end
