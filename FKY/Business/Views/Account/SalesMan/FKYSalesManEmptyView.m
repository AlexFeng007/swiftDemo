//
//  FKYSalesManEmptyView.m
//  FKY
//
//  Created by 寒山 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSalesManEmptyView.h"
#import <Masonry/Masonry.h>

@implementation FKYSalesManEmptyView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI{
    
    UIImageView *image = [UIImageView new];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(FKYWH(173)));
        make.height.equalTo(@(FKYWH(85)));
    }];
    image.image = [UIImage imageNamed:@"icon_account_coupon_empty"];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(image.mas_bottom).offset(FKYWH(27));
    }];
    label.text = @"很遗憾！你没有对接业务员，请去完善资料吧";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = FKYSystemFont(FKYWH(16));
    self.backgroundColor = UIColorFromRGB(0xeae9e9);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
