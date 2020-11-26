//
//  UIViewController+ToastOrLoading.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ToastOrLoading)

@property (nonatomic, strong) NSDictionary *toastDictionary;

// toast
- (void)toast:(NSString *)msg;
- (void)toast:(NSString *)msg time:(CGFloat)time;
- (void)toast:(NSString *)msg andImage:(UIImage *)image;
- (void)toast:(NSString *)msg delay:(CGFloat)delay numberOfLines:(NSInteger)numberOfLines;

// loading
- (void)showLoading;
- (void)dismissLoading;
- (void)dismissLoadingWithoutAnimate;

@end
