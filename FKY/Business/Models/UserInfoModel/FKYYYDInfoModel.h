//
//  FKYYYDInfoModel.h
//  FKY
//
//  Created by 寒山 on 2019/4/17.
//  Copyright © 2019 yiyaowang. All rights reserved.
// 医药贷模型

#import <Foundation/Foundation.h>

@interface FKYYYDInfoModel : FKYBaseModel

/**
 *  质管审核状态（0：未审核，1：审核通过，2：审核未通过，3：待发货审核，4：变更待发货审核，5：资质过期）
 */
@property (nonatomic, assign) NSInteger isAudit;
/**
 *  BD审核状态 （0:待电子审核,1:审核通过,2:审核不通过,3:变更,5:变更待电子审核,7:变更审核不通过）
 */
@property (nonatomic, assign) NSInteger isCheck;
/**
 1药贷是否过期
 1：过期 0：没过期
 */
@property (nonatomic, copy) NSString *limitOverdue;
/**
 跳转到h5或复兴的ur
 */
@property (nonatomic, copy) NSString *returnUrl;
/**
 *  企业类型
 */
@property (nonatomic, copy) NSString *roleType;
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
 本地字段判断是否显示提示new
 */
@property (nonatomic, assign) BOOL hideTag;

/**
 1药贷可用余额
 */
@property (nonatomic, copy) NSString *remainAmount;
/**
 本地字段判断是否显示提示new  接口返回 0不显示，1显示
 */
@property (nonatomic, assign) NSInteger yydShow;
/**
显示1药贷还是1药贷对公 接口返回
 */
@property (nonatomic, copy) NSString *yydTitle;
/**
 1药贷标签
 1即将过期，0距离过期一月以上
 */
@property (nonatomic, copy) NSString *aboutToExpire;
@end

