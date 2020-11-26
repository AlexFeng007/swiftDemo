//
//  FKYAddressAlertView.m
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductAlertView.h"
#import <Masonry/Masonry.h>
#import "FKYCartAddressModel.h"
#import <BlocksKit/UIControl+BlocksKit.h>

@interface FKYProductAlertView ()

@property (copy, nonatomic) void (^handler)(FKYProductAlertView *alertView, BOOL isRight);

#pragma mark Layout

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;




@property (nonatomic) BOOL hasBuildLayout;

@end

BOOL isDismiss = YES;
BOOL isNew = NO;
@implementation FKYProductAlertView

+ (instancetype)showAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle message:(NSString *)message  dismiss:(BOOL)dismiss handler:(void (^)(FKYProductAlertView *, BOOL))handler{
   FKYProductAlertView *v = [FKYProductAlertView showAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:message handler:handler];
    isDismiss = !dismiss;
    return v;
}
+ (instancetype)showNewAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle message:(NSString *)message  dismiss:(BOOL)dismiss handler:(void (^)(FKYProductAlertView *, BOOL))handler{
    FKYProductAlertView *v = [FKYProductAlertView showNewAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:message handler:handler];
    isDismiss = !dismiss;
    return v;
}
+ (instancetype)showAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle message:(NSString *)message titleColor:(UIColor *)messageColor handler:(void (^)(FKYProductAlertView *, BOOL))handler{
   FKYProductAlertView *v = [FKYProductAlertView showAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:message  handler:handler];
    v.messageLabel.textColor = messageColor;
    return v;
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftColor:(UIColor *)leftColor rightTitle:(NSString *)rightTitle rightColor:(UIColor *)rightColor message:(NSString *)message titleColor:(UIColor *)messageColor handler:(void (^)(FKYProductAlertView *, BOOL))handler{
    FKYProductAlertView *v = [FKYProductAlertView showAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:message  handler:handler];
    v.messageLabel.textColor = messageColor;
    if (nil != leftColor) {
        [v.leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    }
    if (nil != rightColor) {
        [v.rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    }
    return v;
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftColor:(UIColor *)leftColor rightTitle:(NSString *)rightTitle rightColor:(UIColor *)rightColor attributeMessage:(NSAttributedString *)attributeMessage  handler:(void (^)(FKYProductAlertView *, BOOL))handler {
    FKYProductAlertView *v = [FKYProductAlertView showAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:attributeMessage.string  handler:handler];
    v.messageLabel.text = nil;
    v.messageLabel.attributedText = attributeMessage;
    if (nil != leftColor) {
        [v.leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    }
    if (nil != rightColor) {
        [v.rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    }
    return v;
}
+ (instancetype)showsSeriousAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler {
    FKYProductAlertView *v = [FKYProductAlertView showAlertViewWithTitle:title leftTitle:leftTitle rightTitle:rightTitle message:message  handler:handler];
    [v.rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[v.rightBtn setBackgroundColor:[UIColor redColor]];
    return v;
}


+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler {
    isNew = NO;
    FKYProductAlertView *v = [FKYProductAlertView new];
    v.title = title;
    v.message = message;
    v.leftTitle = leftTitle;
    v.rightTitle = rightTitle;
    v.handler = handler;
    [v show];
    return v;
}
+ (instancetype)showNewAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler {
    isNew = YES;
    FKYProductAlertView *v = [FKYProductAlertView new];
    v.title = title;
    v.message = message;
    v.leftTitle = leftTitle;
    v.rightTitle = rightTitle;
    v.handler = handler;
    [v show];
    return v;
}

- (void)dealloc {
    self.handler = nil;
}

- (void)show {
    
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
        if(isNew){
             make.width.equalTo(@(FKYWH(270)));
        }else{
             make.width.equalTo(@(FKYWH(250)));
        }
       
    }];
    
    UIView *upperView = _titleLabel;
    
    if (self.title) {
        self.titleView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
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
                l.textColor = UIColorFromRGB(0x333333);
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
            
            UIView *separator = [UIView new];
            if (isNew){
                separator.hidden = YES;
            }else{
                separator.hidden = NO;
            }
            separator.backgroundColor = UIColorFromRGB(0xebedec);
            [self.titleView addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.titleView);
                make.height.equalTo(@(1));
                make.top.equalTo(self.titleView.mas_bottom).offset(-1);
            }];
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
            if(isNew){
                label.font = FKYBoldSystemFont(FKYWH(15));
            }else{
                label.font = FKYSystemFont(FKYWH(14));
            }
            
            label.text = self.message;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self->_forgroundView.mas_left).offset(FKYWH(15));
                make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-15));
                if (upperView) {
                    make.top.equalTo(upperView.mas_bottom).offset(FKYWH(30));
                }else{
                    make.top.equalTo(self->_forgroundView.mas_top).offset(FKYWH(25));
                }
            }];
            label;
        });
        upperView = _messageLabel;
    }
    
    UIView *separator = [UIView new];
    if (isNew){
        separator.hidden = YES;
    }else{
        separator.hidden = NO;
    }
    separator.backgroundColor = UIColorFromRGB(0xebedec);
    [_forgroundView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_forgroundView);
        make.height.equalTo(@(1));
        make.top.equalTo(upperView.mas_bottom).offset(FKYWH(25));
    }];
    
    self.leftBtn = ({
        UIButton *btn = [UIButton new];
        [_forgroundView addSubview:btn];
        if(isNew){
            btn.backgroundColor = UIColorFromRGB(0xFF2D5C );
            btn.titleLabel.font = FKYSystemFont(FKYWH(14));
            btn.layer.cornerRadius = FKYWH(3);
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:UIColorFromRGB(0xFFFFFF)
                      forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = UIColorFromRGB(0xffffff);
            btn.titleLabel.font = FKYSystemFont(FKYWH(13));
            [btn setTitleColor:UIColorFromRGB(0x666666)
                      forState:UIControlStateNormal];
        }
       
        if (self.leftTitle) {
            [btn setTitle:self.leftTitle forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(isNew){
                make.left.equalTo(@(FKYWH(26)));
                if (self.rightTitle) {
                    make.width.equalTo(@(FKYWH(100)));
                }else{
                    if (self.rightTitle == nil &&isNew) {
                        make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-26));
                    }else{
                        make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-10));
                    }
                }
               
                make.height.equalTo(@(FKYWH(36)));
                make.top.equalTo(separator.mas_bottom);
            }else{
                make.left.equalTo(@(FKYWH(5)));
                if (self.rightTitle) {
                    make.width.equalTo(@(FKYWH(120)));
                }else{
                    make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-10));
                }
                make.height.equalTo(@(FKYWH(45)));
                make.top.equalTo(separator.mas_bottom);
            }
          
        }];
        btn;
    });
    
    @weakify(self);
    [self.leftBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        safeBlock(self.handler,self,NO);
        if (isDismiss) {
            [self dismiss];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    if (self.rightTitle) {
        UIView *sep = [UIView new];
        sep.backgroundColor = UIColorFromRGB(0xebedec);
        if (isNew){
            sep.hidden = YES;
        }else{
            sep.hidden = NO;
        }
        [_forgroundView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self->_forgroundView);
            make.width.equalTo(@(1));
            make.top.equalTo(separator.mas_bottom);
        }];
        
        self.rightBtn = ({
            UIButton *btn = [UIButton new];
            [_forgroundView addSubview:btn];
            if(isNew){
                btn.backgroundColor = UIColorFromRGB(0xffffff);
                btn.titleLabel.font = FKYSystemFont(FKYWH(14));
                btn.layer.cornerRadius = FKYWH(3);
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth = FKYWH(0.5);
                btn.layer.borderColor = UIColorFromRGB(0xFF2D5C).CGColor;
                [btn setTitleColor:UIColorFromRGB(0xFF2D5C)
                          forState:UIControlStateNormal];
            }else{
                btn.backgroundColor = UIColorFromRGB(0xffffff);
                btn.titleLabel.font = FKYSystemFont(FKYWH(13));
                [btn setTitleColor:UIColorFromRGB(0x666666)
                          forState:UIControlStateNormal];
            }
           
            if (self.rightTitle) {
                [btn setTitle:self.rightTitle forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"确定" forState:UIControlStateNormal];
            }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if(isNew){
                     make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-26));
                }else{
                     make.right.equalTo(self->_forgroundView.mas_right).offset(FKYWH(-5));
                }
                make.width.height.equalTo(self.leftBtn);
                make.top.equalTo(separator.mas_bottom);
            }];
            
            btn;
        });
        @weakify(self);
        [self.rightBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.handler,self,YES);
            [self dismiss];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [_forgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(isNew){
            make.bottom.equalTo(self.leftBtn.mas_bottom).offset(FKYWH(21));
        }else{
            make.bottom.equalTo(self.leftBtn.mas_bottom).offset(FKYWH(5));
        }
        
    }];
    
    self.hasBuildLayout = YES;

}

@end
