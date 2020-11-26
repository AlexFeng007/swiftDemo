//
//  Target_category.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_category.h"

@implementation Target_category

- (id)Action_jsUniversalRouterToCategoryViewController:(NSDictionary *)params
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
        destinationViewController.index = 1;
    }];
    return nil;
}

- (id)Action_nativeFetchCategoryViewController:(NSDictionary *)params
{
    int versionNumCode = [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] intValue];
    int random = (arc4random() % versionNumCode) + 1;
    
    FKYCategoryWebViewController *vc2 = [[FKYCategoryWebViewController alloc] init];
    vc2.urlPath = [NSString stringWithFormat:@"https://m.yaoex.com/classify.html?v=%d", random];
    
    return vc2;
}

@end
