//
//  GLMediator+LoginActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+LoginActions.h"

NSString *const kGLMediatorTargetLogin = @"login";

NSString *const kGLMediatorActionJsFetchLoginViewController = @"jsFetchLoginViewController";
NSString *const kGLMediatorActionJsFetchRegisterViewController = @"jsFetchRegisterViewController";

@implementation GLMediator (LoginActions)

- (UIViewController *)glMediator_loginViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetLogin
                 action:kGLMediatorActionJsFetchLoginViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_registerViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetLogin
                 action:kGLMediatorActionJsFetchRegisterViewController
                 params:params
      shouldCacheTarget:NO];
}

@end
