//
//  FKYAccountBaseInfoModel.h
//  FKY
//
//  Created by 寒山 on 2019/4/17.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  个人中心 资料聚合接口模型

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"
#import "FKYAccountToolsModel.h"
#import "FKYYYDInfoModel.h"

@interface FKYAccountBaseInfoModel : FKYBaseModel

/**
 用户资产     createTime
 */
@property (nonatomic, copy) NSString *accountRemain;
/**
优惠券
 */
@property (nonatomic, copy) NSString *couponCount;
/**
 创建时间
 */
@property (nonatomic, copy) NSString *createTime;

/**
 待发货  数量
 */
@property (nonatomic, assign) int deliverNumber;

/**
企业审核状态
 */
@property (nonatomic, assign) int enterpriseAuditStatus;
/**
 企业id
 */
@property (nonatomic, assign) NSInteger enterpriseId;
/**
 企业名字
 */
@property (nonatomic, copy) NSString * enterpriseName;

/**
 上次登录时间
 */
@property (nonatomic, copy) NSString * lastLoginTime;
/**
 手机号码
 */
@property (nonatomic, copy) NSString * mobile;

/**
 资质数量
 */
@property (nonatomic, assign) int qualificationCount;

/**
 待收货 数量
 */
@property (nonatomic, assign) int reciveNumber;
/**
 用户显示名称
 */
@property (nonatomic, copy) NSString *showName;
/**
 用户id
 */
@property (nonatomic, copy) NSString *uid;
/**
 待付款 数量
 */
@property (nonatomic, assign) int unPayNumber;
/**
  拒收/补货 数量
 */
@property (nonatomic, assign) int unRejRep;//5.7.0版本开始不在使用
/**
退换货/售后数量
 */
@property (nonatomic, assign) int rmaCount;

/**
 用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 vip模型
 */
@property (nonatomic, strong) FKYVipDetailModel *vipInfo;
/**
 工具列表
 */
@property (nonatomic, strong) NSArray<FKYAccountToolsModel *> * tools; 
/**
 医药贷模型
 */
@property (nonatomic, strong) FKYYYDInfoModel *yydInfo;
/**
 待到账金额
 */
@property (nonatomic, copy) NSString *rebatePendingAmount;



@end


