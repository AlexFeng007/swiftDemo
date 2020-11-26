//
//  GLMediator+CartActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+CartActions.h"

NSString *const kGLMediatorTargetCart = @"cart";
NSString *const kGLMediatorTargetCartSubmit = @"cartSubmit";

NSString *const kGLMediatorActionJsUniversalRouterToCartViewController = @"jsUniversalRouterToCartViewController";
NSString *const kGLMediatorActionJsFetchYiQiGouCartSubmitViewController = @"jsFetchYiQiGouCartSubmitViewController";

@implementation GLMediator (CartActions)

- (void)glMediator_cartViewControllerWithParams:(NSDictionary *)params
{
    [self performTarget:kGLMediatorTargetCart
                 action:kGLMediatorActionJsUniversalRouterToCartViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_yqgCartSubmitViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetCartSubmit
                        action:kGLMediatorActionJsFetchYiQiGouCartSubmitViewController
                        params:params
             shouldCacheTarget:NO];
}

@end
