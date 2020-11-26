//
//  GLNavigationBarComponent.h
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLNavigationBarComponentEventDelegate <NSObject>

- (void)touchLeftReturnNavigationBarButton;
- (void)touchLeftCloseNavigationBarButton;
- (void)touchRightNavigationBarButton:(NSInteger)index;

@end

@class GLNavgationButton;

@interface GLNavigationBarComponent : UIView

@property (nonatomic, weak, nullable) id<GLNavigationBarComponentEventDelegate> eventDelegate;

- (void)configNavLeftButton:(nullable NSString *)imageflag;
- (void)configNavCloseButtonWithTextColor:(nullable UIColor *)textColor;

- (void)setTitle:(nullable NSString *)title;
- (void)setTitleColor:(nullable UIColor *)color;
- (void)setBottomLineVisible:(BOOL)visible;
- (void)setBottomLineColor:(nullable UIColor *)color;

- (void)configNavRightButtonWithIndex:(NSInteger)index imgUrl:(nullable NSString *)imgUrl title:(nullable NSString *)title;

@end
