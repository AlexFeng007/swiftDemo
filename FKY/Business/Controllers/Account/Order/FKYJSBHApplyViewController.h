//
//  FKYJSBHApplyViewController.h
//  FKY
//
//  Created by mahui on 16/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp申请拒收/补货

#import <UIKit/UIKit.h>

@interface FKYJSBHApplyViewController : UIViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *paraString;
@property (nonatomic, copy) NSString *supplyId;
@property (nonatomic, copy) NSString *selectDeliveryAddressId;
@property (nonatomic, assign) NSInteger  isZiYingFlag;//   1 ：自营   0： 非自营
@end
