//
//  FKYJSOrderDetailViewController.h
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  拒收补货详情

#import <UIKit/UIKit.h>

@class FKYOrderModel;


@interface FKYJSOrderDetailViewController : UIViewController

@property (nonatomic, strong)  FKYOrderModel *orderModel;
// @"900" - 补货, @"800"-拒收
@property (nonatomic, copy)    NSString *statusCode;

@end
