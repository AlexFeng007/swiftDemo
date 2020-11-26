//
//  GLMediator+ProductActions.h
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  模块【商品】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (ProductActions)

/**
 跳转业务ViewController
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_productDetailViewControllerWithParams:(NSDictionary *)params;

@end
