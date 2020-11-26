//
//  FKYYYDInfoModel.m
//  FKY
//
//  Created by 寒山 on 2019/4/17.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYYYDInfoModel.h"

@implementation FKYYYDInfoModel
- (void)setLimitOverdue:(NSString *)limitOverdue
{
    if (limitOverdue) {
        _limitOverdue = limitOverdue;
        NSInteger status = [limitOverdue integerValue];
        if (status == 1) {
            _loanDesc = @"额度过期";
        }
    }
}
- (void)setStatus:(NSString *)status
{
    if (status) {
        _status = status;
        if(_limitOverdue &&([_limitOverdue integerValue] == 1)){
             _loanDesc = @"额度过期";
        }else {
            if ([status isKindOfClass:[NSString class]]) {
                if ([status isEqualToString:@"01"]) {
                    _loanDesc = @"暂停申请"; //@"申请开通";
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

}
- (void)setIsAudit:(NSInteger)isAudit
{
    _isAudit = isAudit;
    self.hideTag = true;
    if (_isAudit && (_isAudit == 1 || _isAudit == 5)) { // 质管审核通过或资质过期
        if (_isCheck && (_isCheck == 1 || _isCheck == 3)) { // BD状态为审核通过或变更
            if (_yydShow == 0) {
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
