//
//  Target_product.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_product.h"
#import "NSDictionary+GLParam.h"
#import "FKYProductionDetailViewController.h"

@implementation Target_product

- (id)Action_jsFetchProductViewController:(NSDictionary *)params
{
    NSString *productId = [params paramForKey:@"productId" defaultValue:nil class:NSString.class];
    NSString *enterpriseId = [params paramForKey:@"enterpriseId" defaultValue:nil class:NSString.class];
    FKYProductionDetailViewController *vc = [[FKYProductionDetailViewController alloc] init];
    vc.productionId = productId;
    vc.vendorId = enterpriseId;
    return vc;
}

@end
