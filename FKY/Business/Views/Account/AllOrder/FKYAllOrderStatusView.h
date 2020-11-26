//
//  FKYAllOrderStatusView.h
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单列表之订单分类视图

#import <UIKit/UIKit.h>

typedef void(^AllOrderStatusViewBlock)(NSInteger);


@interface FKYAllOrderStatusView : UIView

@property (nonatomic, strong, readonly)  NSMutableArray *titleArray;
@property (nonatomic, strong)  UIScrollView *scrollView;

@property (nonatomic, copy) AllOrderStatusViewBlock buttonClickBlock;

- (void)buttonClick:(UIButton *)button;
- (void)allOrderStatusViewSelectedButtonTag:(NSInteger)tag;

@end
