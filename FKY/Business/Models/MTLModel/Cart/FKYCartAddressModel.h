//
//  FKYCartAddressModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  检查订单之地址model

#import "FKYBaseModel.h"

@interface FKYCartAddressModel : FKYBaseModel<NSCoding>

/*
 "id": 81565,
 "enterpriseId": "95436",
 "receiverName": "测试收货人188",
 "provinceCode": "120000",
 "cityCode": "120100",
 "districtCode": "120103",
 "provinceName": "天津",
 "cityName": "天津市",
 "districtName": "河西区",
 "address": "阿里咯与阿土里",
 "print_address": "天津天津市河西区阿里咯与阿土里",
 "contactPhone": "18939368528",
 "defaultAddress": 0,
 "createUser": "95436",
 "createTime": 1523442646000,
 "updateUser": "95436",
 "updateTime": 1523442646000,
 "purchaser": "测试采购22",
 "purchaser_phone": "18752845558"
 */

@property (nonatomic, assign) NSInteger adId;             // 地址id
@property (nonatomic, copy) NSString *enterpriseId;       //
@property (nonatomic, copy) NSString *receiverName;       // 姓名
@property (nonatomic, copy) NSString *provinceCode;       // 省id
@property (nonatomic, copy) NSString *cityCode;           // 市id
@property (nonatomic, copy) NSString *districtCode;       // 区id
@property (nonatomic, copy) NSString *avenu_code;         // 镇id
@property (nonatomic, copy) NSString *provinceName;       // 省份名称
@property (nonatomic, copy) NSString *cityName;           // 城市名称
@property (nonatomic, copy) NSString *districtName;       // 地区名称
@property (nonatomic, copy) NSString *avenu_name;         // 镇名称
@property (nonatomic, copy) NSString *address;            // 详细地址
@property (nonatomic, copy) NSString *print_address;      // 打印地址(销售单上的仓库地址)...<新增>
@property (nonatomic, copy) NSString *contactPhone;       // 手机号or固话
@property (nonatomic, assign) NSInteger defaultAddress;   // 是否默认收货地址 1:是 0:不是
@property (nonatomic, copy) NSString *purchaser;          // 采购员姓名
@property (nonatomic, copy) NSString *purchaser_phone;    // 采购员联系电话

@property (nonatomic, assign) BOOL isSelected;             // 选择收货地址页，选中

- (NSString *)wholeAddress;
- (BOOL)isLegal;

@end

