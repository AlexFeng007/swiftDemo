//
//  FKYOrderCell.h
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单列表之订单信息cell

#import <UIKit/UIKit.h>

@class FKYOrderModel;

typedef void(^SettingBtnBlock)(NSString *supplyId);

@interface FKYOrderCell : UITableViewCell

@property (nonatomic, copy) SettingBtnBlock settingBtnBlock;

- (void)configCellWithModel:(FKYOrderModel *)model;

@end
