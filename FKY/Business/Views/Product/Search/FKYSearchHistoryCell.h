//
//  FKYSearchHistoryCell.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  搜索界面之搜索历史ccell

#import <UIKit/UIKit.h>
#import "FKYSearchHistoryModel.h"

@interface FKYSearchHistoryCell : UICollectionViewCell

- (void)configCell:(NSString *)text;
- (void)configCellWithModel:(FKYSearchHistoryModel *)model;
- (void)hiddenBottomline:(BOOL)hidden;
- (void)layerApper:(BOOL)hidden;

@property (nonatomic, copy) void(^deleteSigleHistoryBlock)(void);
@end
