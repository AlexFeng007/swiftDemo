//
//  FKYUserInfoModel.h
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYUserInfoModel : NSObject <NSCoding>

/** 
 用户id
 */
@property (nonatomic, copy)  NSString *userId;

/**
 企业ID
 */
@property (nonatomic, strong) NSString *ycenterpriseId;

/**
用户名
 */
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *gltoken;
/** 
 用户类型  20:未认证买卖家, 31:认证单体买家 , 32:认证连锁买家 , 41:卖家
 用户类型  21:单体药店  -1:未认证买卖家
 */
@property (nonatomic, copy) NSString *curUserType;
@property (nonatomic, copy) NSString *serviceType;
/**
 客户id
 */
@property (nonatomic, copy) NSString *custId;
/**
 所在地
 */
@property (nonatomic, copy) NSString *province __deprecated_msg("use substationCode");
@property (nonatomic, copy) NSString *substationCode;
@property (nonatomic, copy) NSString *substationName;
/**
 最后登陆时间
 */
@property (nonatomic, copy) NSString *lastLoginDate;
/**
 注册手机号
 */
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *custAddr; // 用户地址
@property (nonatomic, copy) NSString *custName; // 用户名
@property (nonatomic, copy) NSString *fileUrl;  // 头像
@property (nonatomic, copy) NSString *enterpriseName;  // 企业名称

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *station;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *roleId;

// 当前账号包含的企业列表...<用户可切换企业>
@property (nonatomic, copy) NSArray *nameList;

@property (nonatomic, copy) NSString *ycuserinfo; // 写入cookie供h5调用

@end

