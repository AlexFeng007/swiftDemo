//
//  GLMediator+EnterpriseActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【店铺】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (EnterpriseActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_enterpriseViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_enterpriseListViewControllerWithParams:(NSDictionary *)params;

@end
