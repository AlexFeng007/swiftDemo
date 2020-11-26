//
//  Target_order.m
//  FKY
//
//  Created by Rabe on 18/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "Target_order.h"
#import "NSDictionary+GLParam.h"

@implementation Target_order

- (id)Action_jsFetchOrderListViewController:(NSDictionary *)params
{
    NSString *type = [params paramForKey:@"type" defaultValue:nil class:NSString.class];
    FKYAllOrderViewController *vc = [[FKYAllOrderViewController alloc] init];
    vc.status = type.length ? type : @"0";
    return vc;
}

@end
