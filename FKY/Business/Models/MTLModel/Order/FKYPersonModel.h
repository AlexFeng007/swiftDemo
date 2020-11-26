//
//  FKYPersonModel.h
//  FKY
//
//  Created by mahui on 15/12/2.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYPersonModel : FKYBaseModel

@property (nonatomic, strong) NSString *addressType;        // 发货地址类型
@property (nonatomic, strong) NSString *addressId;          // 发货地址ID
@property (nonatomic, strong) NSString *deliveryName;       // 收货人
@property (nonatomic, strong) NSString *deliveryPhone;      // 联系方式
@property (nonatomic, strong) NSString *addressProvince;    // 省id
@property (nonatomic, strong) NSString *addressCity;        // 市id
@property (nonatomic, strong) NSString *addressCounty;      // 区id
@property (nonatomic, strong) NSString *addressDetail;      // 收货地址
@property (nonatomic, strong) NSString *printAddress;       // 打印地址
@property (nonatomic, strong) NSString *addressInfo;        // 地址全称

@end
