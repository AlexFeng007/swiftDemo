//
//  FKYLogisticsDetailViewController.h
//  FKY
//
//  Created by zengyao on 2017/6/6.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  第三方物流

#import <UIKit/UIKit.h>
#import "FKYDeliveryHeadModel.h"


@interface FKYLogisticsDetailViewController : UIViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *expresssID;
@property (nonatomic, copy) NSString *expresssName;
@property (nonatomic, copy) NSString *expressState;
@property (nonatomic, strong) NSArray *expressList;
@property (nonatomic, assign) BOOL isRCType;

@end
