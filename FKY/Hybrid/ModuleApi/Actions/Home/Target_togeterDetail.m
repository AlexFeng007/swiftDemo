//
//  Target_togeterDetail.m
//  FKY
//
//  Created by hui on 2018/12/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "Target_togeterDetail.h"

@implementation Target_togeterDetail
//一起购详情
- (id)Action_jsUniversalRouterToTogeterDetailViewController:(NSDictionary *)params
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Togeter_Detail_Buy) setProperty:^(FKYTogeterBuyDetailViewController * destinationViewController) {
        destinationViewController.productId = params[@"productId"];
        destinationViewController.typeIndex = params[@"typeIndex"];
    }];
    return nil;
}
@end
