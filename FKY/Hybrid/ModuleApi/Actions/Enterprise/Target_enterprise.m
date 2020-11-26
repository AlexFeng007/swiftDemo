//
//  Target_enterprise.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_enterprise.h"
#import "NSDictionary+GLParam.h"

@implementation Target_enterprise

- (id)Action_jsFetchEnterpriseViewController:(NSDictionary *)params
{
    NSString *enterpriseId = [params paramForKey:@"enterpriseId" defaultValue:nil class:NSString.class];
    NSString *keyword = [params paramForKey:@"keyword" defaultValue:nil class:NSString.class];
    FKYNewShopItemViewController *vc = [[FKYNewShopItemViewController alloc] init];
    
    if (keyword.length > 0) {
//        vc.keyword = keyword;
    }
    if (enterpriseId.length > 0) {
        vc.shopId = enterpriseId;
    }
    return vc;
}

- (id)Action_jsFetchEnterpriseListViewController:(NSDictionary *)params
{
    FKYShopListViewController *vc = [[FKYShopListViewController alloc] init];
    return vc;
}

@end
