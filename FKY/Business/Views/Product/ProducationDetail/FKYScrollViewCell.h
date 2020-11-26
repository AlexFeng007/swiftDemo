//
//  FKYScrollViewCell.h
//  FKY
//
//  Created by mahui on 15/9/17.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  商详之顶部轮播图cell

#import <UIKit/UIKit.h>

@interface FKYScrollViewCell : UITableViewCell

@property (nonatomic, copy) void(^clickDetailPicBlock)(void); // 点击图片回调

- (void)configCell:(NSArray *)pictureArray;
- (void)configRecommendView:(BOOL)isShow block:(void (^)(void))block;

@end
