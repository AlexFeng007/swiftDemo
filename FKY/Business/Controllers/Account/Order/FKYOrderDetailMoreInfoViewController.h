//
//  FKYOrderDetailMoreInfoViewController.h
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  更多详情

#import <UIKit/UIKit.h>
#import "FKYAccountSchemeProtocol.h"

@class FKYOrderModel;

@interface FKYOrderDetailMoreInfoViewController : UIViewController

@property (nonatomic, strong) FKYOrderModel *orderModel;

@end
