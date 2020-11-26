//
//  GLMediator+TogeterAction.m
//  FKY
//
//  Created by hui on 2018/12/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "GLMediator+TogeterAction.h"
NSString *const kGLMediatorTargetTogeter = @"togeter";
NSString *const kGLMediatorActionJsUniversalRouterToTogeterViewController = @"jsUniversalRouterToTogeterViewController";

@implementation GLMediator (TogeterAction)
-(void)glMediator_togeterViewControllerWithParams:(NSDictionary *)params{
    [self performTarget:kGLMediatorTargetTogeter
                 action:kGLMediatorActionJsUniversalRouterToTogeterViewController
                 params:params
      shouldCacheTarget:NO];
}
@end
