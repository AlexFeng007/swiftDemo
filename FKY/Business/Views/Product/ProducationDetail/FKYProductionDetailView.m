//
//  FKYProducationDetailView.m
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductionDetailView.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "FKYLoginAPI.h"

@interface FKYProductionDetailView ()

@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong)  UIView *lineView;
@property (nonatomic, strong)  UILabel *titleLabel;

@end

@implementation FKYProductionDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(FKYWH(49)));
        }];
        view;
    });
    self.bottomWhiteView = ({
        UIView *view = [[UIView alloc] init];
        [self.bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView.mas_left);
            make.width.equalTo(@(FKYWH(75)));
            make.bottom.equalTo(self.bottomView.mas_bottom);
            make.height.equalTo(self.bottomView.mas_height);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view;
        
    });
    
    self.jionButton = ({
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomWhiteView.mas_right);
            make.right.equalTo(self.bottomView.mas_right);
            make.bottom.equalTo(self.bottomView.mas_bottom);
            make.height.equalTo(self.bottomView.mas_height);
        }];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
                safeBlock(self.showLoginBlock);
                return ;
            }
            self.jionBlock();
        } forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"加入购物车" forState:UIControlStateNormal];
//        button.backgroundColor = UIColorFromRGB(0xdf4138);
        button.titleLabel.font = [UIFont systemFontOfSize:FKYWH(14)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button;
    });
    
    self.bottomRedView = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomWhiteView.mas_centerX);
            make.centerY.equalTo(self.bottomWhiteView.mas_centerY).offset(-FKYWH(5));
            make.width.equalTo(@(FKYWH(30)));
            make.height.equalTo(@(FKYWH(30)));
        }];
        [button setImage:[UIImage imageNamed:@"icon_cart_tabbar_normal"] forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.cartBlock();
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomRedView.mas_bottom);
            make.centerX.equalTo(self.bottomWhiteView.mas_centerX);
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.text = @"购物车";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    self.lineView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.bottomView.mas_top);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xcccccc);
        view;
    });
    
    self.badgeView = ({
        JSBadgeView *view = [[JSBadgeView alloc] initWithParentView:self.bottomRedView alignment:JSBadgeViewAlignmentTopRight];
        view.badgePositionAdjustment = CGPointMake(FKYWH(1), FKYWH(6));
        view.badgeTextFont = FKYSystemFont(FKYWH(11));
        view;
    });
}


@end
