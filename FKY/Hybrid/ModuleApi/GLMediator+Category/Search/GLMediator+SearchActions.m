//
//  GLMediator+SearchActions.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLMediator+SearchActions.h"

NSString *const kGLMediatorTargetSearch = @"search";

NSString *const kGLMediatorActionJsFetchSearchResultViewController = @"jsFetchSearchResultViewController";
NSString *const kGLMediatorActionJsPushSearchViewController = @"jsPushSearchViewController";

@implementation GLMediator (SearchActions)

- (UIViewController *)glMediator_searchResultViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetSearch
                 action:kGLMediatorActionJsFetchSearchResultViewController
                 params:params
      shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_selfSearchResultViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetSearch
                        action:kGLMediatorActionJsFetchSearchResultViewController
                        params:params
             shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_spuSearchResultViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetSearch
                        action:kGLMediatorActionJsFetchSearchResultViewController
                        params:params
             shouldCacheTarget:NO];
}

- (void)glMediator_searchViewControllerWithParams:(NSDictionary *)params
{
    [self performTarget:kGLMediatorTargetSearch
                 action:kGLMediatorActionJsPushSearchViewController
                 params:params
      shouldCacheTarget:NO];
}

@end
