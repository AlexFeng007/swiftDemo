//
//  GLMediator+CategoryActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+CategoryActions.h"

NSString *const kGLMediatorTargetCategory = @"category";

NSString *const kGLMediatorActionJsUniversalRouterToCategoryViewController = @"jsUniversalRouterToCategoryViewController";
NSString *const kGLMediatorActionNativeFetchCategoryViewController = @"nativeFetchCategoryViewController";

@implementation GLMediator (HomeActions)

- (void)glMediator_categoryViewControllerWithParams:(NSDictionary *)params
{
    [self performTarget:kGLMediatorTargetCategory
                 action:kGLMediatorActionJsUniversalRouterToCategoryViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_fetchNativeCategoryViewController
{
    return [self performTarget:kGLMediatorTargetCategory
                        action:kGLMediatorActionNativeFetchCategoryViewController
                        params:nil
             shouldCacheTarget:NO];
}

@end
