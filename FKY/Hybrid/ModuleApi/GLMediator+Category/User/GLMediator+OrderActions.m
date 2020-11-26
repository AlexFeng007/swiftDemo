//
//  GLMediator+OrderActions.m
//  FKY
//
//  Created by Rabe on 18/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "GLMediator+OrderActions.h"

NSString *const kGLMediatorTargetOrder = @"order";

NSString *const kGLMediatorActionJsFetchOrderListViewController = @"jsFetchOrderListViewController";

@implementation GLMediator (OrderActions)

- (UIViewController *)glMediator_orderListViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetOrder
                 action:kGLMediatorActionJsFetchOrderListViewController
                 params:params
      shouldCacheTarget:NO];
}

@end
