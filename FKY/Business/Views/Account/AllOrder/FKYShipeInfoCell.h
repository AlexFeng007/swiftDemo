//
//  FKYShipeInfoCell.h
//  FKY
//
//  Created by mahui on 15/10/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单详情之地址（收货）信息

#import <UIKit/UIKit.h>

@class FKYOrderModel;

@interface FKYShipeInfoCell : UITableViewCell

- (void)configCellWithModel:(FKYOrderModel *)infoModel;

@end
