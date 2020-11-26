//
//  UIViewController+NavigationBar.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

// web容器原生导航栏供H5调用支持的风格
typedef NS_ENUM(NSUInteger, FKYWebBarStyle) {
    FKYBarStyleNotVisible, // 默认不展示
    FKYBarStyleRed, // 红背景，白色返回按钮，白色标题
    FKYBarStyleWhite, // 白背景，红色返回按钮，深灰标题
};


@interface UIViewController (NavigationBar)

- (void)fky_setupNavigationBar;
- (void)fky_setupNavigationBarWithTitle:(NSString *)title;
- (void)fky_setupNavigationBarWithTitleView:(UIView *)titleView;

- (void)fky_setNavigationBarTitle:(NSString *)title;
- (void)fky_setNavigationBarTitleView:(UIView *)titleView;
- (void)fky_setNavigationBarBottomTitle:(NSString *)title ;

- (void)fky_setNavitationBarLeftButtonImage:(UIImage *)image;
- (void)fky_addNavitationBarLeftButtonTaget:(id)taget action:(SEL)action;
- (void)fky_addNavitationBarLeftButtonEventHandler:(void (^)(id sender))handler;
- (void)fky_addNavitationBarBackButtonTaget:(id)taget action:(SEL)action;
- (void)fky_addNavitationBarBackButtonEventHandler:(void (^)(id sender))handler;
- (void)fky_addNavitationBarRightButtonEventHandler:(void (^)(id sender))handler;

- (void)fky_setNavitationBarRightButtonImage:(UIImage *)image;
- (void)fky_setNavitationBarRightButtonTitle:(NSString *)title;
- (void)fky_addNavitationBarRightButtonTaget:(id)taget action:(SEL)action;

- (UIView *)fky_NavigationBar;
- (CGFloat)fky_NavigationBarHeight;
- (void)fky_setNavigationBarHeight:(CGFloat)height;
- (UIButton *)fky_NavigationBarRightBarButton;
- (void)fky_setTitleColor:(UIColor *)titleColor;
//- (void)fky_setTitleFont:(UIFont *)titleFont;
- (void)fky_setRightBttonTitleColor:(UIColor *)titleColr andFont:(UIFont *)titleFont;
- (void)fky_setNavigationBarBottomLineHidden:(BOOL)hidden;

@end
