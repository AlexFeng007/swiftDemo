//
//  GLMediator+LoginActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【登录注册】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (LoginActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_loginViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_registerViewControllerWithParams:(NSDictionary *)params;

@end
