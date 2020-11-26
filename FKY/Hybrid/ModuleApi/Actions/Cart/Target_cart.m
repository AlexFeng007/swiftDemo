//
//  Target_cart.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_cart.h"

@implementation Target_cart

- (id)Action_jsUniversalRouterToCartViewController:(NSDictionary *)params
{
    if ([params[@"canBack"] isEqualToString:@"1"]) {
        // 可返回的购物车
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopCart) setProperty:^(id<FKY_ShopCart> destinationViewController) {
            destinationViewController.canBack = true;
        } isModal:false];
    }
    else {
        // tab购物车
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
            destinationViewController.index = 3;
        }];
    }
    return nil;
}

@end
