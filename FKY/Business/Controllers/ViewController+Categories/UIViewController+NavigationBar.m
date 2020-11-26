//
//  UIViewController+NavigationBar.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "FKYDefines.h"
#import "FKYCore.h"
#import "FKYCategories.h"
#import <Aspects/Aspects.h>
#import "UIView+EnlargeArea.h"


@implementation UIViewController (NavigationBar)

- (void)fky_setupNavigationBar {
    [self fky_setupNavigationBarWithTitle:nil];
}

- (void)fky_setupNavigationBarWithTitle:(NSString *)title {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        [self p_createNavigationBar];
    }
    if (title) {
        if ([self p_titleLabel] == nil) {
            [self p_createTitleLabel];
        }
        [self fky_setNavigationBarTitle:title];
    }
}

- (void)fky_setupNavigationBarWithTitleView:(UIView *)titleView {
    [self fky_setupNavigationBarWithTitle:nil];
    [self fky_setNavigationBarTitleView:titleView];
}

- (void)fky_setNavigationBarTitle:(NSString *)title {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        [self p_createNavigationBar];
    }
    UILabel *titleLabel = [self p_titleLabel];
    if (titleLabel == nil) {
        titleLabel = [self p_createTitleLabel];
    }
    if (title) {
        titleLabel.text = title;
    } else {
        titleLabel.text = nil;
        titleLabel.attributedText = nil;
    }
}
- (void)fky_setNavigationBarBottomTitle:(NSString *)title {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        [self p_createNavigationBar];
    }
    UILabel *bottomTitleLabel = [self p_bottomTitleLabel];
    if (bottomTitleLabel == nil) {
        bottomTitleLabel = [self p_createNavigationBarBottomTitle];
    }
    if (title) {
        bottomTitleLabel.text = title;
        UILabel *titleLabel = [self p_titleLabel];
        if (titleLabel != nil) {
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nvBar).offset(FKYWH(46));
                make.right.equalTo(nvBar).offset(FKYWH(-46));
                make.height.mas_equalTo(29);
                make.bottom.equalTo(nvBar).offset(FKYWH(-15));
            }];
        }
    } else {
        UILabel *titleLabel = [self p_titleLabel];
        if (titleLabel != nil) {
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nvBar).offset(FKYWH(46));
                make.right.equalTo(nvBar).offset(FKYWH(-46));
                make.height.mas_equalTo(44);
                make.bottom.equalTo(nvBar).offset(FKYWH(0));
            }];
        }
        bottomTitleLabel.text = nil;
        bottomTitleLabel.attributedText = nil;
    }
}
- (void)fky_setNavigationBarTitleView:(UIView *)titleView {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        [self p_createNavigationBar];
    }
    if (titleView == nil) {
        [[self p_titleView] removeFromSuperview];
    } else {
        [nvBar addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(nvBar);
        }];
    }
    [self p_setTitleView:titleView];
}

- (void)fky_setNavigationBarBottomLineHidden:(BOOL)hidden {
    UIView *line = [self fky_NavigationBarBottomLine];
    line.hidden = hidden;
}

- (void)fky_setNavitationBarLeftButtonImage:(UIImage *)image {
    UIButton *leftButton = [self p_leftButton];
    if (leftButton == nil) {
        leftButton = [self p_createLeftButton];
    }
    [leftButton setImage:image forState:UIControlStateNormal];
}

//// umeng 统计
//- (void)fky_setNavitationBarLeftButtonImageFor_Umeng:(UIImage *)image{
//    [MobClick endEvent:@"New_onlinePay_back"];
//    [self fky_setNavitationBarLeftButtonImageFor_Umeng:image];
//}

- (void)fky_addNavitationBarLeftButtonTaget:(id)taget action:(SEL)action {
    UIButton *leftButton = [self p_leftButton];
    if (leftButton == nil) {
        leftButton = [self p_createLeftButton];
    }
    [leftButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)fky_addNavitationBarLeftButtonEventHandler:(void (^)(id sender))handler {
    UIButton *leftButton = [self p_leftButton];
    if (leftButton == nil) {
        leftButton = [self p_createLeftButton];
    }
    [leftButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
//    [leftButton aspect_hookSelector:NSSelectorFromString(@"invoke:") withOptions:AspectPositionAfter usingBlock:<#(id)#> error:nil];
}

- (void)fky_addNavitationBarBackButtonTaget:(id)taget action:(SEL)action {
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_white_normal"]];
    [self fky_addNavitationBarLeftButtonTaget:taget action:action];
}

- (void)fky_addNavitationBarBackButtonEventHandler:(void (^)(id sender))handler {
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_white_normal"]];
    [self fky_addNavitationBarLeftButtonEventHandler:handler];
}

- (void)fky_setNavitationBarRightButtonImage:(UIImage *)image {
    UIButton *rightButton = [self p_rightButton];
    if (rightButton == nil) {
        rightButton = [self p_createRightButton];
    }
    [rightButton setImage:image forState:UIControlStateNormal];
}

- (void)fky_setNavitationBarRightButtonTitle:(NSString *)title {
    UIButton *rightButton = [self p_rightButton];
    if (rightButton == nil) {
        rightButton = [self p_createRightButton];
    }
    [rightButton setTitle:title forState:UIControlStateNormal];
}

- (void)fky_addNavitationBarRightButtonTaget:(id)taget action:(SEL)action {
    UIButton *rightButton = [self p_rightButton];
    if (rightButton == nil) {
        rightButton = [self p_createRightButton];
    }
    [rightButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)fky_addNavitationBarRightButtonEventHandler:(void (^)(id sender))handler {
    UIButton *rightButton = [self p_rightButton];
    if (rightButton == nil) {
        rightButton = [self p_createRightButton];
    }
    [rightButton bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)fky_NavigationBar{
    if (objc_getAssociatedObject(self, FKYNavigationBarKey) == nil) {
        [self p_createNavigationBar];
    }
    return objc_getAssociatedObject(self, FKYNavigationBarKey);
}

- (UIView *)fky_NavigationBarBottomLine {
    if (objc_getAssociatedObject(self, FKYNavigationBarBottomLineKey) == nil) {
        [self p_createNavigationBarBottomLine];
    }
    return objc_getAssociatedObject(self, FKYNavigationBarBottomLineKey);
}

- (CGFloat)fky_NavigationBarHeight {
    CGFloat navBarHeight = [self p_NavigationBarHeight];
    if (navBarHeight <= 1.0) {
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                return FKYWH(iPhoneX_SafeArea_TopInset);
            } else {
                return FKYWH(64);
            }
        } else {
            return FKYWH(64);
        }
    }
    return navBarHeight;
}

- (void)fky_setNavigationBarHeight:(CGFloat)height {
    [self p_setNavigationBarHeight:height];
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return;
    }
    [nvBar mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                make.height.equalTo(@(FKYWH(iPhoneX_SafeArea_TopInset)));
            } else {
                make.height.equalTo(@(FKYWH(64)));
            }
        } else {
            make.height.equalTo(@(FKYWH(64)));
        }
    }];
    
}

- (UIButton *)fky_NavigationBarRightBarButton {
    return [self p_rightButton];
}

#pragma mark - Private

- (UIView *)p_createNavigationBar {
    UIView *nvBar = UIView.new;
    nvBar.backgroundColor = UIColorFromRGB(0xf54b41);
    [self.view addSubview:nvBar];
    [nvBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@([self fky_NavigationBarHeight]));
    }];
    [self p_setNavigationBar:nvBar];
    return nvBar;
}

- (UIView *)p_createNavigationBarBottomLine {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return nil;
    }
    UIView *line = [UIView new];
    [nvBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(nvBar);
        make.height.equalTo(@(1));
    }];
    line.backgroundColor = UIColorFromRGB(0xebedec);
    [self p_setNavigationBarBottomLine:line];
    return line;
}

- (UILabel *)p_createTitleLabel {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return nil;
    }
    UILabel *titleLabel = ({
        UILabel *label = UILabel.new;
        [nvBar addSubview:label];
        label.numberOfLines = 1;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:FKYWH(18)];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nvBar).offset(FKYWH(46));
            make.right.equalTo(nvBar).offset(FKYWH(-46));
            make.height.mas_equalTo(44);
            make.bottom.equalTo(nvBar).offset(FKYWH(0));
//            make.centerX.equalTo(nvBar.mas_centerX);
//            if (@available(iOS 11, *)) {
//                UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
//                if (insets.bottom > 0) {
//                    make.bottom.equalTo(nvBar).offset(FKYWH(-10));
//                } else {
//                    make.centerY.equalTo(nvBar.mas_centerY).offset(FKYWH(10));
//                }
//            } else {
//                make.centerY.equalTo(nvBar.mas_centerY).offset(FKYWH(10));
//            }
        }];
        label;
    });
    [self p_setTitleLabel:titleLabel];
    return titleLabel;
}

- (UIButton *)p_createLeftButton {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return nil;
    }
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nvBar addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(NVFromSizeWH(FKYWH(44), FKYWH(44)));
        make.bottom.equalTo(nvBar).offset(FKYWH(0));
        make.left.equalTo(nvBar).offset(FKYWH(0));
    }];
    [self p_setLeftButton:leftButton];
    return leftButton;
}
- (UILabel *)p_createNavigationBarBottomTitle {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return nil;
    }
    UILabel *bottomTitleLabel = UILabel.new;
    [nvBar addSubview:bottomTitleLabel];
    bottomTitleLabel.numberOfLines = 1;
    bottomTitleLabel.textColor = [UIColor blackColor];
    bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    bottomTitleLabel.font = [UIFont systemFontOfSize:FKYWH(10)];
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nvBar).offset(FKYWH(46));
        make.right.equalTo(nvBar).offset(FKYWH(-46));
        make.height.mas_equalTo(FKYWH(10));
        make.bottom.equalTo(nvBar).offset(FKYWH(-5));
        
    }];
   [self p_bottomTitleLabel:bottomTitleLabel];
   return bottomTitleLabel;
}

- (UIButton *)p_createRightButton {
    UIView *nvBar = [self fky_NavigationBar];
    if (nvBar == nil) {
        return nil;
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [nvBar addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(nvBar).offset(FKYWH(-5));
//        make.right.equalTo(nvBar).offset(FKYWH(-10));
        make.size.equalTo(NVFromSizeWH(FKYWH(44), FKYWH(44)));
        make.bottom.equalTo(nvBar).offset(FKYWH(0));
        make.right.equalTo(nvBar).offset(FKYWH(0));
    }];
    //[rightButton setEnlargeEdgeWithTop:FKYWH(5) right:FKYWH(8) bottom:FKYWH(5) left:FKYWH(3)];
    [self p_setRightButton:rightButton];
    return rightButton;
}

- (void)fky_setTitleColor:(UIColor *)titleColor
{
    UILabel *label = [self p_titleLabel];
    label.textColor = titleColor;
}
//- (void)fky_setTitleFont:(UIColor *)titleColor  andFont:(UIFont *)titleFont{
//{
//    UILabel *label = [self p_titleLabel];
//     label.textColor = titleColor;
//    label.font = titleFont;
//}

- (void)fky_setRightBttonTitleColor:(UIColor *)titleColr andFont:(UIFont *)titleFont{
    UIButton *button = [self p_rightButton];
    [button setTitleColor:titleColr forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
}

static const void *FKYNavigationBarHeight_Key = &FKYNavigationBarHeight_Key;
static const void *FKYNavigationBarKey = &FKYNavigationBarKey;
static const void *FKYNavigationBarBottomLineKey = &FKYNavigationBarBottomLineKey;
static const void *FKYNavigationBarTitleLabelKey = &FKYNavigationBarTitleLabelKey;
static const void *FKYNavigationBarTitleViewKey = &FKYNavigationBarTitleViewKey;
static const void *FKYNavigationBarLeftButtonKey = &FKYNavigationBarLeftButtonKey;
static const void *FKYNavigationBarRightButtonKey = &FKYNavigationBarRightButtonKey;
static const void *FKYNavigationBarBottomTitleKey = &FKYNavigationBarBottomTitleKey;

- (void)p_setNavigationBarHeight:(CGFloat)height {
    objc_setAssociatedObject(self, FKYNavigationBarHeight_Key, @(height), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)p_NavigationBarHeight {
    return ((NSNumber *)objc_getAssociatedObject(self, FKYNavigationBarHeight_Key)).floatValue;
}
- (void)p_setNavigationBar:(UIView *)navigationBar {
    objc_setAssociatedObject(self, FKYNavigationBarKey, navigationBar, OBJC_ASSOCIATION_ASSIGN);
}

- (void)p_setNavigationBarBottomLine:(UIView *)line {
    objc_setAssociatedObject(self, FKYNavigationBarBottomLineKey, line, OBJC_ASSOCIATION_RETAIN);
}
- (UIView *)p_NavigationBarBottomLine {
    return objc_getAssociatedObject(self, FKYNavigationBarBottomLineKey);
}

- (UILabel *)p_titleLabel {
    return objc_getAssociatedObject(self, FKYNavigationBarTitleLabelKey);
}
- (void)p_setTitleLabel:(UILabel *)titleLabel {
    objc_setAssociatedObject(self, FKYNavigationBarTitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
}

- (UILabel *)p_bottomTitleLabel {
    return objc_getAssociatedObject(self, FKYNavigationBarBottomTitleKey);
}
- (void)p_bottomTitleLabel:(UILabel *)titleLabel {
    return objc_setAssociatedObject(self, FKYNavigationBarBottomTitleKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)p_titleView {
    return objc_getAssociatedObject(self, FKYNavigationBarTitleViewKey);
}

- (void)p_setTitleView:(UIView *)titleView {
    objc_setAssociatedObject(self, FKYNavigationBarTitleViewKey, titleView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIButton *)p_leftButton {
    return objc_getAssociatedObject(self, FKYNavigationBarLeftButtonKey);
}

- (void)p_setLeftButton:(UIButton *)leftButton {
    objc_setAssociatedObject(self, FKYNavigationBarLeftButtonKey, leftButton, OBJC_ASSOCIATION_ASSIGN);
}

- (UIButton *)p_rightButton {
    return objc_getAssociatedObject(self, FKYNavigationBarRightButtonKey);
}

- (void)p_setRightButton:(UIButton *)rightButton {
    objc_setAssociatedObject(self, FKYNavigationBarRightButtonKey, rightButton, OBJC_ASSOCIATION_ASSIGN);
}

@end
