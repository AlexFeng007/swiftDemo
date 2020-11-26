//
//  GLMediator+SearchActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【搜索】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (SearchActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_searchResultViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_selfSearchResultViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_spuSearchResultViewControllerWithParams:(NSDictionary *)params;
- (void)glMediator_searchViewControllerWithParams:(NSDictionary *)params;

@end
