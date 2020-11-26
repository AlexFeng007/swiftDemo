//
//  FKYTopBar.h
//  FKY
//
//  Created by yangyouyong on 2016/9/19.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AllOrderStatusViewBlock)(NSInteger);


@interface FKYTopBar : UIView

@property (nonatomic, strong)  NSArray *titleArray;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, retain) UIColor *selectedColor;//选中颜色
@property (nonatomic, strong, readonly)  UIScrollView *scrollView;

@property (nonatomic, copy) AllOrderStatusViewBlock buttonClickBlock;

- (void)buttonClick:(UIButton *)button;
- (void)allOrderStatusViewSelectedButtonTag:(NSInteger)tag;

@end
