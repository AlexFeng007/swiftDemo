//
//  Target_userCenter.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_userCenter.h"

@implementation Target_userCenter

- (id)Action_jsUniversalRouterToAccountViewController:(NSDictionary *)params
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
        destinationViewController.index = 4;
    }];
    return nil;
}

- (id)Action_jsFetchKeepListViewController:(NSDictionary *)params
{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        if ([FKYLoginAPI checkLoginExistByModelStyle] == NO) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }
        return nil;
    }
    else {
        OftenBuyProductListController *vc = [[OftenBuyProductListController alloc] init];
        return vc;
    }
}

@end
