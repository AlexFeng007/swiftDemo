//
//  UIView+AlphaGradient.m
//  FKY
//
//  Created by 夏志勇 on 2018/8/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "UIView+AlphaGradient.h"

@implementation UIView (AlphaGradient)

- (void)changeAlpha:(CGRect)rect
{
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    NSArray *colors = @[(id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:1] CGColor]];
    [gradLayer setColors:colors];
    [gradLayer setStartPoint:CGPointMake(1.0f, 0.0f)];
    [gradLayer setEndPoint:CGPointMake(0.85f, 0.0f)];
    //[gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
    //[gradLayer setFrame:self.bounds];
    [gradLayer setFrame:rect];
    [self.layer setMask:gradLayer];
}

// 增加白色透明渐变效果...<从左到右>
- (void)changeAlphaHorizontal:(CGRect)rect
{
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    NSArray *colors = @[(id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:1] CGColor]];
    [gradLayer setColors:colors];
    [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [gradLayer setEndPoint:CGPointMake(0.5f, 0.0f)];
    [gradLayer setFrame:rect];
    [self.layer setMask:gradLayer];
}

@end
