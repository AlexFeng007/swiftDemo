//
//  GLMediator+EnterpriseActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+EnterpriseActions.h"

NSString *const kGLMediatorTargetEnterprise = @"enterprise"; 

NSString *const kGLMediatorActionJsFetchEnterpriseViewController = @"jsFetchEnterpriseViewController";
NSString *const kGLMediatorActionJsFetchEnterpriseListViewController = @"jsFetchEnterpriseListViewController";

@implementation GLMediator (EnterpriseActions)

- (UIViewController *)glMediator_enterpriseViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetEnterprise
                 action:kGLMediatorActionJsFetchEnterpriseViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_enterpriseListViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetEnterprise
                 action:kGLMediatorActionJsFetchEnterpriseListViewController
                 params:params
      shouldCacheTarget:NO];
}

@end
