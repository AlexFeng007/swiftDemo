//
//  GLMediator+UserActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【用户中心】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (UserActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (void)glMediator_accountViewControllerWithParams:(NSDictionary *)params;
- (UIViewController *)glMediator_keepListViewControllerWithParams:(NSDictionary *)params;

@end
