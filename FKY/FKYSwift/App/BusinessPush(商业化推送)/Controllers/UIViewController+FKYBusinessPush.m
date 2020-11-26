//
//  UIViewController+FKYBusinessPush.m
//  FKY
//
//  Created by 油菜花 on 2020/11/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

#import "UIViewController+FKYBusinessPush.h"
#import <objc/runtime.h>


@implementation UIViewController (FKYBusinessPush)



+ (void)load

{
    [super load];
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        Method origMethod =class_getInstanceMethod([self class],@selector(viewWillDisappear:));
        Method swizMethod=class_getInstanceMethod([self class],@selector(FKY_viewWillDisappear:));
        method_exchangeImplementations(origMethod, swizMethod);
        
        Method viewDidLoadOrigMethod = class_getInstanceMethod([self class],@selector(viewDidLoad));
        Method viewDidLoadSwizMethod = class_getInstanceMethod([self class],@selector(FKY_viewDidLoad));
        method_exchangeImplementations(viewDidLoadOrigMethod, viewDidLoadSwizMethod);
        
        Method deallocOrigMethod = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
        Method deallocSwizMethod = class_getInstanceMethod(self.class, @selector(FKY_dealloc));
        method_exchangeImplementations(deallocOrigMethod,deallocSwizMethod);
        
    });
}

-(void)FKY_dealloc{
    if  ([[FKYPush sharedInstance].pushEntryVCName isEqualToString:self.className]){
        [self upLoadPushIdStatus:2];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self FKY_dealloc];
}

- (void)FKY_viewWillDisappear:(BOOL)animated{
    
    [self FKY_viewWillDisappear:animated];
}

- (void)FKY_viewDidLoad{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:FKYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOutSuccess) name:FKYLogoutCompleteNotification object:nil];
    
    [self FKY_viewDidLoad];
}

/// 向后台更新pushid的状态
/// @param status 1就是有效  2就是失效
-(void)upLoadPushIdStatus:(int)status{
    
    /// pushId为空不上报
    if ([FKYPush sharedInstance].pushID == nil || [[FKYPush sharedInstance].pushID isEqual:[NSNull null]] || [FKYPush sharedInstance].pushID.length < 1) { //pushID为空
        return;
    }
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin && status == 1) {
        NSDictionary *param = @{@"pushId":[FKYPush sharedInstance].pushID,@"buyerCode":[FKYLoginAPI currentUserId],@"status":@(status)};
        [[NSUserDefaults standardUserDefaults] setObject:[FKYPush sharedInstance].pushID forKey:@"BUSINESS_PUSH_ID"];
        [[FKYRequestService sharedInstance] upLoadPushIdStatus:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
            
        }];
    }else if (status == 2) {
        NSDictionary *param = @{@"pushId":[FKYPush sharedInstance].pushID,@"buyerCode":[FKYLoginAPI currentUserId],@"status":@(status)};
        [[FKYRequestService sharedInstance] upLoadPushIdStatus:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
            
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BUSINESS_PUSH_ID"];
        [FKYPush sharedInstance].pushID = @"";
        [FKYPush sharedInstance].pushEntryVCName = @"";
    }
    
}

/// 用户登录成功
- (void)userLoginSuccess{
    [self upLoadPushIdStatus:1];
}

/// 用户推出登陆
- (void)userLogOutSuccess{
    [self upLoadPushIdStatus:2];
}

@end
