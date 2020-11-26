//
//  FKYAllOrderViewController.h
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  我的订单...<订单列表>

#import <UIKit/UIKit.h>
#import "FKYAccountSchemeProtocol.h"

typedef void(^PopToCartBlock)(void);


@interface FKYAllOrderViewController: UIViewController <FKY_AllOrderController>

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) PopToCartBlock popToCartBlock;

@end
