//
//  Target_home.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_home.h"

@implementation Target_home

- (id)Action_jsUniversalRouterToHomeViewController:(NSDictionary *)params
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
        destinationViewController.index = 0;
    }];
    return nil;
}

- (id)Action_nativeFetchHomeViewController:(NSDictionary *)params
{
    int versionNumCode = [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] intValue];
    int random = (arc4random() % versionNumCode) + 1;
    // <H5>首页
    GLWebVC *vc1 = [[GLWebVC alloc] init];
    vc1.urlPath = [NSString stringWithFormat:@"http://m.yaoex.com/experimental_index.html?v=%d", random];
    return vc1;
}

@end
