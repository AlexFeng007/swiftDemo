//
//  FKYReceiveProductViewController.h
//  FKY
//
//  Created by mahui on 16/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp确认收货

#import <UIKit/UIKit.h>

@interface FKYReceiveProductViewController : UIViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *supplyId;
@property (nonatomic, copy) NSString *selectDeliveryAddressId;
@property (nonatomic, assign) NSInteger  isZiYingFlag;//   1：自营   0：非自营
@property (nonatomic, strong) void(^clickAllProudct)(void);
@end
