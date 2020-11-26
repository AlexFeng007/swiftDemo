//
//  GLMediator+UserActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+UserActions.h"

NSString *const kGLMediatorTargetUserCenter = @"userCenter";

NSString *const kGLMediatorActionJsUniversalRouterToAccountViewController = @"jsUniversalRouterToAccountViewController";
NSString *const kGLMediatorActionJsFetchKeepListViewController = @"jsFetchKeepListViewController";

@implementation GLMediator (UserActions)

- (void)glMediator_accountViewControllerWithParams:(NSDictionary *)params
{
    [self performTarget:kGLMediatorTargetUserCenter
                 action:kGLMediatorActionJsUniversalRouterToAccountViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_keepListViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetUserCenter
                        action:kGLMediatorActionJsFetchKeepListViewController
                        params:params
             shouldCacheTarget:NO];
}

@end
