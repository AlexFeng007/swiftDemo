//
//  FKYVipDetailModel.h
//  FKY
//
//  Created by hui on 2019/3/21.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"

@interface FKYVipDetailModel : FKYBaseModel

@property (nonatomic, assign) NSInteger enterpriseId;   // 客户id
@property (nonatomic, copy) NSString *memberLevel;      // 会员等级
@property (nonatomic, copy) NSString *levelName;        // 会员等级名称
@property (nonatomic, assign) NSInteger vipSymbol;      // 会员标识(0:非会员；1：会员 2:不显示会员)
@property (nonatomic, assign) NSInteger roleTypeValue;  // 企业类型(1:非公立医疗机构 2:公立医疗机构 3:单体药店 4:连锁总店 5:个体诊所 6:生产企业 7:批发企业 8:连锁加盟店)
@property (nonatomic, copy) NSString *tips;             // 会员文描
@property (nonatomic, copy) NSString *gmvGap;           // 距离会员额度
@property (nonatomic, copy) NSString *url;              // 会员专区url

@end


