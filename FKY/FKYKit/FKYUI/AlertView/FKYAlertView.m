//
//  FKYAlertView.m
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAlertView.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>

@interface FKYAlertView ()

@property (nonatomic, copy) NSArray *addressArray;
@property (copy, nonatomic) void (^handler)(FKYAlertView *alertView, BOOL isRight);

#pragma mark Layout
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;

@property (nonatomic) BOOL hasBuildLayout;

@end

@implementation FKYAlertView

+(instancetype)showAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                              handler:(void (^)(FKYAlertView *, BOOL))handler {
    FKYAlertView *alert = [FKYAlertView new];
    alert.title = title;
    alert.message = message;
    alert.handler = handler;
    [alert show];
    return alert;
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYAlertView *alertView, BOOL isRight))handler {
    FKYAlertView *alert = [FKYAlertView new];
    alert.title = title;
    alert.message = message;
    alert.handler = handler;
    alert.leftTitle = leftTitle;
    alert.rightTitle = rightTitle;
    [alert show];
    return alert;
}

- (void)dealloc {
    self.handler = nil;
}

- (void)show {
    if (self.title.length == 0) {
        return;
    }
    
    [self fky_layoutSubviews];
    [super show];
}

- (void)dismiss {
    [super dismiss];
}

- (void)fky_layoutSubviews {
    if (self.hasBuildLayout) {
        return;
    }
    [super fky_layoutSubviews];
    [_forgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(FKYWH(240)));
    }];
    
    UIView *upperView = _titleLabel;
    
    if (self.title) {
        self.titleView = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColorFromRGB(0xdf4138);
            [_forgroundView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self->_forgroundView);
                make.height.equalTo(@(FKYWH(44)));
            }];
            view;
        });
        
        if (self.title) {
            [_titleLabel removeFromSuperview];
            _titleLabel = ({
                UILabel *l = UILabel.new;
                l.backgroundColor = UIColor.clearColor;
                l.textColor = [UIColor whiteColor];
                l.numberOfLines = 1;
                l.textAlignment = NSTextAlignmentCenter;
                [self.titleView addSubview:l];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.titleView.mas_centerY);
                    make.left.equalTo(self.titleView).offset(FKYWH(FKYPopViewEdgesLeft));
                    make.right.equalTo(self.titleView).offset(FKYWH(-FKYPopViewEdgesRight));
                }];
                l;
            });
            _titleLabel.text = self.title;
        }
        upperView = self.titleView;
    }
    
    if (self.message) {
        _messageLabel = ({
            UILabel *label = [UILabel new];
            [_forgroundView addSubview:label];
            label.numberOfLines = 0;
            if ([self.message rangeOfString:@"\n"].location != NSNotFound) {
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.textAlignment = NSTextAlignmentCenter;
            }
            
            label.font = FKYSystemFont(FKYWH(14));
            label.text = self.message;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self->_forgroundView.mas_left).offset(FKYWH(30));
                make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-30));
                make.top.equalTo(upperView.mas_bottom).offset(FKYWH(30));
            }];
            label;
        });
        upperView = _messageLabel;
    }
    
    self.leftBtn = ({
        UIButton *btn = [UIButton new];
        [_forgroundView addSubview:btn];
        btn.backgroundColor = UIColorFromRGB(0xdf4138);
        btn.titleLabel.font = FKYSystemFont(FKYWH(14));
        [btn setTitleColor:UIColorFromRGB(0xffffff)
                  forState:UIControlStateNormal];
        if (self.leftTitle) {
            [btn setTitle:self.leftTitle forState:UIControlStateNormal];
        }else{
         [btn setTitle:@"确定" forState:UIControlStateNormal];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(FKYWH(12)));
            make.width.equalTo(@(FKYWH(100)));
            make.height.equalTo(@(FKYWH(39)));
            make.top.equalTo(upperView.mas_bottom).offset(FKYWH(30));
        }];
        @weakify(self);
        [btn bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.handler,self,NO);
            [self dismiss];
        } forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = FKYWH(3);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        btn.layer.borderWidth = FKYWH(0.5);
        btn;
    });
    
    self.rightBtn = ({
        UIButton *btn = [UIButton new];
        [_forgroundView addSubview:btn];
        btn.backgroundColor = UIColorFromRGB(0xffffff);
        btn.titleLabel.font = FKYSystemFont(FKYWH(14));
        [btn setTitleColor:UIColorFromRGB(0x333333)
                  forState:UIControlStateNormal];
        if (self.rightTitle) {
            [btn setTitle:self.rightTitle forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftBtn.mas_right).offset(FKYWH(16));
            make.width.equalTo(@(FKYWH(100)));
            make.height.equalTo(@(FKYWH(39)));
            make.top.equalTo(upperView.mas_bottom).offset(FKYWH(30));
        }];
        @weakify(self);
        [btn bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.handler,self,YES);
            [self dismiss];
        } forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = FKYWH(3);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        btn.layer.borderWidth = FKYWH(0.5);
        btn;
    });
    
    
    [_forgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo()
        make.bottom.equalTo(self.leftBtn.mas_bottom).offset(FKYWH(12));
    }];
    
    self.hasBuildLayout = YES;
}

@end
