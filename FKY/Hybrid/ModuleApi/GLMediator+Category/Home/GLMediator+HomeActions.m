//
//  GLMediator+HomeActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+HomeActions.h"

NSString *const kGLMediatorTargetHome = @"home";

NSString *const kGLMediatorActionJsUniversalRouterToHomeViewController = @"jsUniversalRouterToHomeViewController";
NSString *const kGLMediatorActionNativeFetchHomeViewController = @"nativeFetchHomeViewController";

@implementation GLMediator (HomeActions)

- (void)glMediator_homeViewControllerWithParams:(NSDictionary *)params
{
    [self performTarget:kGLMediatorTargetHome
                 action:kGLMediatorActionJsUniversalRouterToHomeViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_fetchNativeHomeViewController
{
    return [self performTarget:kGLMediatorTargetHome
                 action:kGLMediatorActionNativeFetchHomeViewController
                 params:nil
      shouldCacheTarget:NO];
}

@end
