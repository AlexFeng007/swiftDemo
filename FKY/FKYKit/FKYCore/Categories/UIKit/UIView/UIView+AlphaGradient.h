//
//  UIView+AlphaGradient.h
//  FKY
//
//  Created by 夏志勇 on 2018/8/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AlphaGradient)

// 增加白色透明渐变效果...<从右到左>
- (void)changeAlpha:(CGRect)rect;

// 增加白色透明渐变效果...<从左到右>
- (void)changeAlphaHorizontal:(CGRect)rect;

@end
