//
//  GLMediator+ProductActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+ProductActions.h"

NSString *const kGLMediatorTargetProduct = @"product";

NSString *const kGLMediatorActionFetchProductViewController = @"jsFetchProductViewController";

@implementation GLMediator (ProductActions)

- (UIViewController *)glMediator_productDetailViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetProduct
                 action:kGLMediatorActionFetchProductViewController
                 params:params
      shouldCacheTarget:NO];
}

@end
