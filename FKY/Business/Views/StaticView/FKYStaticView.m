//
//  FKYStaticView.m
//  FKY
//
//  Created by yangyouyong on 2016/9/21.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYStaticView.h"
#import <Masonry/Masonry.h>
#import "UILabel+FKYKit.h"
#import "UIButton+FKYKit.h"

@interface FKYStaticView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation FKYStaticView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.bgView) {
        [self setupView];
    }
}

- (void)setupView {
    self.bgView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        view;
    });
    
    self.iconView = ({
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"icon_cart_add_empty"];
        [self.bgView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(@(FKYWH(45)));
            make.width.height.equalTo(@(FKYWH(77.5)));
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.centerY.equalTo(self.bgView.mas_centerY).offset(-SCREEN_HEIGHT/5);
        }];
        icon;
    });
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        [self.bgView addSubview:label];
        label.fontTuble = T23;
        label.text = @"购物车还是空的";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(FKYWH(15));
            make.height.equalTo(@(FKYWH(20)));
            make.centerX.equalTo(self.bgView.mas_centerX);
        }];
        label;
    });
    
    self.actionBtn = ({
        UIButton *actionBtn = [UIButton new];
        [self.bgView addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(FKYWH(30));
            make.centerX.equalTo(self.bgView.mas_centerX);
        }];
        actionBtn.btnStyle = BTN11;
        [actionBtn setTitle:@"去首页逛逛"
                   forState:UIControlStateNormal];
        @weakify(self);
        [[actionBtn
          rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             safeBlock(self.actionBlock);
         }];
        actionBtn;
    });
}

- (void)configView:(NSString *)iconName
             title:(NSString *)title
          btnTitle:(NSString *)btnTitle {
    self.iconView.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = title;
    [self.actionBtn setTitle:btnTitle forState:UIControlStateNormal];
}

@end
