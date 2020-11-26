//
//  FKYOrderDetailViewController.h
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单详情

#import <UIKit/UIKit.h>
#import "FKYMoreInfoModel.h"

@class FKYOrderModel;

@interface FKYOrderDetailViewController : UIViewController

@property (nonatomic, strong) FKYOrderModel *orderModel;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) void (^changeBtnBlock)(BOOL ischange);
@end
