//
//  FKYToast.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYToast : UIView

// 配置全局Toast样式
+ (void)configBackgroundColor:(UIColor *)color;
+ (void)configTextColor:(UIColor *)color;
+ (void)configTextFont:(UIFont *)font;
+ (void)configPaddingEdgeInsets:(UIEdgeInsets)edgeInsets;

/**
 *  Toast
 *
 *  @param title 主标题
 */
+ (void)showToast:(NSString *)title;
+ (void)showToast:(NSString *)title withTime:(CGFloat)time;
+ (void)showToast:(NSString *)title delay:(CGFloat)delay numberOfLines:(NSInteger)numberOfLines;
+ (void)showToast:(NSString *)title withImage:(UIImage *)image;

@end
