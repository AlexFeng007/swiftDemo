//
//  UILabel+EdgeInsets.h
//  FKY
//
//  Created by 夏志勇 on 2018/9/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  设置内边距

#import <UIKit/UIKit.h>

@interface UILabel (EdgeInsets)

/**
 和UIbutton相似，内边距属性，控制字体与控件边界的间隙
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@end
