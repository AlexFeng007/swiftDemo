//
//  FKYTimeView.m
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYWarnView.h"
#import <Masonry/Masonry.h>

@interface FKYWarnView ()

@property (nonatomic, strong)  UILabel *warnLabel;

@end


@implementation FKYWarnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xfeefb8);
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    _warnLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(FKYWH(15));
            make.right.equalTo(self).offset(FKYWH(-15));
            make.centerY.equalTo(self.mas_centerY);
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0x333333);
        label.text = @"温馨提示: 账期支付和线下支付订单请去电脑上查看";
        label;
    });
}

- (void)configViewWithType:(FKYWarnViewType)type
{
    if (type == FKYWarnViewTypeNomal) {
        _warnLabel.text = @"温馨提示：账期支付订单、商品的首营资质和质检报告请去电脑上查看";
        _warnLabel.adjustsFontSizeToFitWidth = YES;
    }
    if (type == FKYWarnViewTypeJSBU) {
        _warnLabel.text = @"温馨提示: 请对剩余未确认收货商品作拒收或补货处理";
    }
}


@end
