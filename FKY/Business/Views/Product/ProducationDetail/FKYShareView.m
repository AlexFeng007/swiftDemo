//
//  FKYShareView.m
//  FKY
//
//  Created by mahui on 15/9/22.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYShareView.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UIImage+FKYKit.h"


@interface FKYShareView ()

@property (nonatomic, strong) UILabel *wechatName;
@property (nonatomic, strong) UILabel *wechatFriendName;
@property (nonatomic, strong) UILabel *QQName;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *friendButton;
@property (nonatomic, strong) UIButton *QQButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *separaterView;
@property (nonatomic, strong) UIView *btnSeparaterView;

@end
@implementation FKYShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setUI];
        @weakify(self);
        self.appearBlock = ^{
            @strongify(self);
            self.userInteractionEnabled = YES;
          [UIView animateWithDuration:0.35 animations:^{
               @strongify(self);
             self.backgroundColor =  UIColorFromRGBA(0x000000,0.3f);
              self.bgView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - FKYWH(120)/ 2.0);
          } completion:^(BOOL finished) {
              
          }];
        };
        self.dismissBlock = ^{
            @strongify(self);
            self.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.35 animations:^{
                 @strongify(self);
                self.backgroundColor =  UIColorFromRGBA(0x000000,0.0f);
                self.bgView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT + FKYWH(120)/ 2.0);
            } completion:^(BOOL finished) {
                
            }];
        };
    }
    return self;
}


- (void)setUI
{
    self.bgView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@(FKYWH(120)));
        }];
        view.backgroundColor = UIColorFromRGBA(0x0, 0.8);
        view;
    });
//    self.separaterView = ({
//        UIView *view = [[UIView alloc] init];
//        [self.bgView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.bgView.mas_left);
//            make.right.equalTo(self.bgView.mas_right);
//            make.bottom.equalTo(self.bgView.mas_top);
//            make.height.equalTo(@(FKYWH(1)));
//        }];
//        view.backgroundColor = UIColorFromRGB(0xcccccc);
//        view;
//    });
    
    self.friendButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(FKYWH(15));
            make.top.equalTo(self.bgView.mas_top).offset(FKYWH(12));
            make.width.equalTo(@(FKYWH(38)));
            make.height.equalTo(@(FKYWH(38)));
        }];
        if ([WXApi isWXAppInstalled]) {
            [button setImage:[UIImage imageNamed:@"icon_production_wxfriend_normal"] forState:UIControlStateNormal];
            button.enabled = YES;
        }else{
            [button setImage:[UIImage imageNamed:@"icon_production_wxfriend_uninstall"] forState:UIControlStateNormal];
            button.enabled = NO;
            button.userInteractionEnabled = NO;
        }
        [button addTarget:self action:@selector(WXFriendShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.wechatFriendName = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.friendButton);
            make.top.equalTo(self.friendButton.mas_bottom).offset(FKYWH(5));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0xFFFFFF);
        label.text = @"朋友圈";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    self.wechatBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.friendButton.mas_right).offset(FKYWH(32.5));
            make.top.equalTo(self.bgView.mas_top).offset(FKYWH(12));
            make.width.equalTo(@(FKYWH(38)));
            make.height.equalTo(@(FKYWH(38)));
        }];
        if ([WXApi isWXAppInstalled]) {
            
            [button setImage:[UIImage imageNamed:@"icon_production_wx_normal"] forState:UIControlStateNormal];
            button.enabled = YES;
        }else{
            [button setImage:[UIImage imageNamed:@"icon_production_wx_uninstall"] forState:UIControlStateNormal];
            button.enabled = NO;
            button.userInteractionEnabled = NO;
        }
        [button addTarget:self action:@selector(wechatShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
        
    });
    
    self.wechatName = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.wechatBtn);
            make.top.equalTo(self.wechatBtn.mas_bottom).offset(FKYWH(5));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0xFFFFFF);
        label.text = @"微信好友";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    self.QQButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wechatBtn.mas_right).offset(FKYWH(32.5));
            make.top.equalTo(self.bgView.mas_top).offset(FKYWH(12));
            make.width.equalTo(@(FKYWH(38)));
            make.height.equalTo(@(FKYWH(38)));
        }];
        if ([QQApiInterface isQQInstalled]) {
            
            [button setImage:[UIImage imageNamed:@"icon_production_qq_normal"] forState:UIControlStateNormal];
            button.enabled = YES;
        }else{
            [button setImage:[UIImage imageNamed:@"icon_production_qq_uninstall"] forState:UIControlStateNormal];
            button.enabled = NO;
            button.userInteractionEnabled = NO;
        }
        [button addTarget:self action:@selector(QQShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.QQName = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.QQButton);
            make.top.equalTo(self.QQButton.mas_bottom).offset(FKYWH(5));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0xFFFFFF);
        label.text = @"QQ";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    self.cancelBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.right.equalTo(self.bgView.mas_right);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.height.equalTo(@(FKYWH(40)));
        }];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        button.titleLabel.font = FKYSystemFont(FKYWH(15));
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.dismissBlock);
        } forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = UIColorFromRGBA(0x0, 0.9);
        [button setBackgroundImage:[UIImage FKY_imageWithColor:UIColorFromRGBA(0x0, 1.0) size:CGSizeMake(SCREEN_WIDTH, FKYWH(40))] forState:UIControlStateHighlighted];
        button;
    });
    self.btnSeparaterView = ({
        UIView *view = [[UIView alloc] init];
        [self.cancelBtn addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_left);
            make.right.equalTo(self.cancelBtn.mas_right);
            make.top.equalTo(self.cancelBtn.mas_top);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view;
    });
    
}


- (void)wechatShareButtonClick{
    
    safeBlock(self.WXShareBlock);
}

- (void)WXFriendShareButtonClick{
    safeBlock(self.WXFriendShareBlock);
}

- (void)QQShareButtonClick{
    safeBlock(self.QQShareBlock);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        safeBlock(self.dismissBlock);
    }
}


@end
