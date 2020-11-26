//
//  FKYOrderDetailCell.h
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单详情之基本cell

#import <UIKit/UIKit.h>
#import "FKYOrderDetailManage.h"

@class FKYOrderModel;
@class FKYMoreInfoModel;
typedef void(^MoreInfoButtonClickBlock)(void);
typedef void(^TapBlock)(CellType);

//复制订单号
typedef void(^CopyOrderIdHandler)(void);

@interface FKYOrderDetailCell : UITableViewCell

@property (nonatomic, copy)  MoreInfoButtonClickBlock moreInfoButtonClickBlock;
@property (nonatomic, copy)  TapBlock tapBlock;

@property (nonatomic, copy) CopyOrderIdHandler copyHandler;


//- (void)configCellWithModel:(FKYOrderModel *)model;
- (void)configCellWithModel:(FKYOrderModel *)model andCellType:(CellType)cellType;
- (void)configCancelCellWithModel:(FKYMoreInfoModel *)model andCellType:(CellType)cellType;
@end
