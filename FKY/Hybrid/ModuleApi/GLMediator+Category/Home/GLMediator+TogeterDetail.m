//
//  GLMediator+TogeterDetail.m
//  FKY
//
//  Created by hui on 2018/12/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "GLMediator+TogeterDetail.h"
NSString *const kGLMediatorTargetTogeterDetail = @"togeterDetail";
NSString *const kGLMediatorActionJsUniversalRouterToTogeterDetailViewController = @"jsUniversalRouterToTogeterDetailViewController";

@implementation GLMediator (TogeterDetail)
-(void)glMediator_togeterDetailViewControllerWithParams:(NSDictionary *)params{
    [self performTarget:kGLMediatorTargetTogeterDetail
                 action:kGLMediatorActionJsUniversalRouterToTogeterDetailViewController
                 params:params
      shouldCacheTarget:NO];
}
@end
