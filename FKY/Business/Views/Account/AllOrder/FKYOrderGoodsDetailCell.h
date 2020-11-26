//
//  FKYOrderGoodsDetailCell.h
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单详情之商品信息cell

#import <UIKit/UIKit.h>

@class FKYOrderModel;
@class FKYOrderProductModel;
@class FKYBatchModel;


@interface FKYOrderGoodsDetailCell : UITableViewCell
//点击协议奖励金
@property (nonatomic, copy) void(^agreeRebateBlock)(void);

- (void)configCellWithModel:(FKYOrderProductModel *)detailModel andOrderModel:(FKYOrderModel *)model ;

- (void)configcellWithProductModel:(FKYOrderProductModel *)model andBatchModel:(FKYBatchModel *)batch;

@end
