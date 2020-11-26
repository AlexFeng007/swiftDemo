//
//  GLMediator+CategoryActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【分 类】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (CategoryActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (void)glMediator_categoryViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_fetchNativeCategoryViewController;

@end
