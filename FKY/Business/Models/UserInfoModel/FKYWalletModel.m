//
//  FKYWalletModel.m
//  FKY
//
//  Created by 沈傲 on 2018/4/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYWalletModel.h"

@implementation FKYWalletModel

- (void)setStatus:(NSString *)status
{
    if (status) {
        _status = status;
        if ([status isKindOfClass:[NSString class]]) {
            if ([status isEqualToString:@"01"]) {
                _loanDesc = @"申请开通";
            }
            if ([status isEqualToString:@"02"]) {
                _loanDesc = @"审核中";
            }
            if ([status isEqualToString:@"05"]) {
                _loanDesc = @"审核通过";
            }
            if ([status isEqualToString:@"03"]) {
                _loanDesc = @"审核不通过";
            }
            if ([status isEqualToString:@"-1"]) {
                _loanDesc = @"****";
            }
        }
    }
}

- (void)setLimitOverdue:(NSString *)limitOverdue
{
    if (limitOverdue) {
        _limitOverdue = limitOverdue;
        NSInteger status = [limitOverdue integerValue];
        if (status == 1) {
            _loanDesc = @"额度过期";
            _returnUrl = STRING_FORMAT(@"%@?limitOverdue=%@", _returnUrl, limitOverdue);
        }
    }
}

- (void)setIsAudit:(NSInteger)isAudit
{
    _isAudit = isAudit;
    self.hideTag = true;
    if (_isAudit && (_isAudit == 1 || _isAudit == 5)) { // 质管审核通过或资质过期
        if (_isCheck && (_isCheck == 1 || _isCheck == 3)) { // BD状态为审核通过或变更
            if (!([_roleType isEqualToString:@"单体药店"] ||
                  [_roleType isEqualToString:@"连锁加盟店"] ||
                  [_roleType isEqualToString:@"个体诊所"] ||
                  [_roleType isEqualToString:@"连锁总店"] ||
                  [_roleType isEqualToString:@"批发企业"] ||
                  [_roleType isEqualToString:@"非公立医疗机构"])) {
                // 用户不是单体药店/个体诊所 或 连锁总店/批发企业/非公立医疗机构(1药贷-对公)
                _loanDesc = @"****";
            }else{
                //显示提示标签
                if ([self.status isEqualToString:@"01"]) {
                     self.hideTag = false;
                }
            }
        } else {
            _loanDesc = @"****";
        }
    } else {
        _loanDesc = @"****";
    }
}

@end
