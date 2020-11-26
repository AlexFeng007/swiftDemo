//
//  FKYWalletModel.h
//  FKY
//
//  Created by 沈傲 on 2018/4/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYWalletModel : NSObject

/**
 用户资产
 */
@property (nonatomic, copy) NSString *accountCount;

/**
 用户资质
 */
@property (nonatomic, copy) NSString *aptitudeCount;

/**
 用户名优惠券
 */
@property (nonatomic, copy) NSString *couponCount;

/**
 企业名称
 */
@property (nonatomic, copy) NSString *enterpriseName;

/**
 1药贷可用余额  accountRemain
 */
@property (nonatomic, copy) NSString *remainAmount;

/**
 1药贷申请状态
 01未开通 02审批中 05审核通过 03审核不通过 -1异常
 */
@property (nonatomic, copy) NSString *status;

/**
 1药贷状态描述
 */
@property (nonatomic, copy) NSString *loanDesc;

/**
 跳转URL
 */
@property (nonatomic, copy) NSString *returnUrl;

/**
 1药贷是否过期
 1：过期 0：没过期
 */
@property (nonatomic, copy) NSString *limitOverdue;

/**
 流水号
 */
@property (nonatomic, copy) NSString *limitAppId;

/**
 *  企业类型
 */
@property (nonatomic, copy) NSString *roleType;

/**
 *  BD审核状态 （0:待电子审核,1:审核通过,2:审核不通过,3:变更,5:变更待电子审核,7:变更审核不通过）
 */
@property (nonatomic, assign) NSInteger isCheck;

/**
 *  质管审核状态（0：未审核，1：审核通过，2：审核未通过，3：待发货审核，4：变更待发货审核，5：资质过期）
 */
@property (nonatomic, assign) NSInteger isAudit;
@property (nonatomic, assign) BOOL hideTag;//本地字段判断是否显示提示new
@property (nonatomic, strong) FKYVipDetailModel *vipModel;//vip模型

@end
