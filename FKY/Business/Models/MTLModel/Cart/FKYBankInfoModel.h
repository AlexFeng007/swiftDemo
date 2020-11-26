//
//  FKYBankInfoModel.h
//  FKY
//
//  Created by mahui on 2017/1/10.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYBankInfoModel : FKYBaseModel

@property (nonatomic, copy) NSString *accountName;    // 企业名称
@property (nonatomic, copy) NSString *account;        // 银行账户
@property (nonatomic, copy) NSString *bankName;       // 银行名称

@end
