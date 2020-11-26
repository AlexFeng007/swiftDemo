//
//  FKYProtocolRebateModel.h
//  FKY
//
//  Created by 夏志勇 on 2019/9/11.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之协议返利金model

#import "FKYBaseModel.h"


@interface FKYProtocolRebateModel : FKYBaseModel

@property (nonatomic, copy) NSString *desc;                 // 协议返利活动描述
@property (nonatomic, copy) NSString *protocolCode;         // 协议编码
@property (nonatomic, copy) NSString *protocolName;         // 协议名称
@property (nonatomic, assign) BOOL protocolRebate;          // 是否协议返利品
@property (nonatomic, strong) NSNumber *protocolRebateId;   // 协议返利id
@property (nonatomic, copy) NSString *protocolUrl;          // 协议详情

@end

