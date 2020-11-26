//
//  GLMediator+VenderActions.m
//  FKY
//
//  Created by Rabe on 30/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "GLMediator+VenderActions.h"

NSString *const kGLMediatorTargetVenders = @"venders";

NSString *const kGLMediatorActionFetchDeviceIdentifierInAboutUsPage = @"nativeFetchDeviceIdentifierInAboutUsPage";

@implementation GLMediator (VenderActions)

- (NSString *)glMediator_deviceIdentifierInAboutUsPage
{
    return [self performTarget:kGLMediatorTargetVenders
                        action:kGLMediatorActionFetchDeviceIdentifierInAboutUsPage
                        params:nil
             shouldCacheTarget:NO];
}

@end
