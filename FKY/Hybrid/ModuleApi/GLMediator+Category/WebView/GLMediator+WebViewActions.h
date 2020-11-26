//
//  GLMediator+WebViewActions.h
//  YYW
//
//  Created by Rabe on 23/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//  模块【容 器】供其他模块调用的api

#import "GLMediator.h"

@interface GLMediator (WebViewActions)

/**
 容器模块ViewController，由调用方决定push或present或自定义转场动画
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_webviewViewControllerWithParams:(NSDictionary *)params;

/**
 hybrid测试界面，由调用方决定push或present或自定义转场动画
 */
- (UIViewController *)glMediator_hybridTestPage;

@end
