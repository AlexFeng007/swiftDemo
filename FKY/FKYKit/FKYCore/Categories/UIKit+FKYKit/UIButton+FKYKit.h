//
//  UIButton+FKYKit.h
//  FKY
//
//  Created by yangyouyong on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FKYKit)

// 设置button 点击区域
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
// button 的1药城style
@property (nonatomic, strong) NSDictionary *btnStyle;

// 设置文字居左 图片居右
- (void)setTitleLeftAndImageRightWithSpace:(CGFloat)space;

@end
