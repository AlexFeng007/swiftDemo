//
//  Target_login.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_login.h"

@implementation Target_login

- (id)Action_jsFetchLoginViewController:(NSDictionary *)params
{
    // 登录
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
    return nil;
}

- (id)Action_jsFetchRegisterViewController:(NSDictionary *)params
{
    RegisterController *vc = [[RegisterController alloc] init];
    return vc;
}

@end
