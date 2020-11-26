//
//  FKYLoginAPI.m
//  FKY
//
//  Created by yangyouyong on 15/9/18.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYLoginAPI.h"
#import <SAMKeychain/SAMKeychain.h>
#import "FKYAccountLaunchLogic.h"
#import "HJNetworkManager.h"

@interface FKYLoginAPI()

/** 网络请求logic */
@property (nonatomic, strong) FKYAccountLaunchLogic *accountLaunchLogic;

@end


@implementation FKYLoginAPI

+ (FKYLoginAPI *)shareInstance {
    static dispatch_once_t onceToken;
    static FKYLoginAPI *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
        staticInstance.accountLaunchLogic = [FKYAccountLaunchLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    });
    
    return staticInstance;
}

/**
 *  当前用户
 *
 *  @return 本地存储的登录用户
 */
+ (FKYUserInfoModel *)currentUser {
    if ([FKYLoginAPI shareInstance].loginUser != nil) {
        return [FKYLoginAPI shareInstance].loginUser;
    }
    
    id obj = UD_OB(FKYCurrentUserKey);
    if (obj) {
        [FKYLoginAPI shareInstance].loginUser = [NSKeyedUnarchiver unarchiveObjectWithData:UD_OB(FKYCurrentUserKey)];
    }
    return [FKYLoginAPI shareInstance].loginUser;
}

+ (FKYLoginStatus)loginStatus {
    if ([self currentUser] == nil) {
        return FKYLoginStatusUnlogin;
    }
    
    return FKYLoginStatusLoginComplete;
}

+ (NSString *)currentUserSessionId {
    return [self currentUser].userId;
}

+ (NSString *)currentUserId {
    id userid = [self currentUser].userId;
    if (userid && [userid isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)userid stringValue];
    }
    return userid ? userid : @"";
}

+ (NSString *)currentEnterpriseid {
    id enterpriseid = [self currentUser].ycenterpriseId;
    if (enterpriseid && [enterpriseid isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)enterpriseid stringValue];
    } else if (enterpriseid && [enterpriseid isKindOfClass:NSString.class]) {
        return enterpriseid;
    } else {
        return @"";
    }
}

+ (NSString *)currentRoleId {
    id roleId = [self currentUser].roleId;
    if (roleId && [roleId isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)roleId stringValue];
    }
    return roleId ? roleId : @"";
}

+ (NSString *)currentUserType {
    id userType = [self currentUser].userType;
    if (userType && [userType isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)userType stringValue];
    }
    return userType ? userType : @"";
}

+ (void)logoutSuccess:(FKYSuccessBlock)successBlock
              failure:(FKYFailureBlock)failureBlock {
    return [[FKYLoginService new] logoutSuccess:successBlock failure:failureBlock];
}

// 自动登录...
+ (void)autoLogin {
    if ([self currentUser] != nil) {
        NSString *username = [SAMKeychain passwordForService:@"username" account:@"admin"];
        NSString *password = [SAMKeychain passwordForService:@"password" account:@"admin"];
        if (username != nil && password != nil && [HJGlobalValue sharedInstance].token.length > 0) {
            // 登录
            [[FKYLoginAPI shareInstance].accountLaunchLogic refreshTokenWithParam:nil CompletionBlock:^(id aResponseObject, NSError *anError) {
                if (aResponseObject && !anError) {
                    NDC_POST_Notification(FKYAutoLoginSuccessNotification, nil, nil);
                }
            }];
        } else {
            // 记录退出登录时的相关信息，并上传服务器
//            NSString *userid = [FKYLoginAPI currentUserId];
//            if (userid && userid.length > 0) {
//                //
//            } else {
//                userid = @"";
//            }
            NSString *gltoken = [HJGlobalValue sharedInstance].token;
            if (gltoken && gltoken.length > 0) {
                //
            }
            else {
                gltoken = @"";
            }
            NSString *yctoken = UD_OB(@"user_token");
            if (yctoken && yctoken.length > 0) {
                //
            }
            else {
                yctoken = @"";
            }
//            NSString *note = @"App启动时(保存的用户名、密码、gltoken之一为空)自动退出登录状态";
            NSDictionary *dicInfo = @{@"gltoken":gltoken, @"yctoken":yctoken, @"params":@"", @"url":@"", @"system":@"ios"};
            NDC_POST_Notification(FKYLogoutForRequestFail, nil, dicInfo);
            
            // 注销
            [FKYLoginAPI logoutSuccess:^(BOOL mutiplyPage) {
                //
            } failure:^(NSString *reason) {
                //
            }];
            
            // 加Alert来定位自动退出登录的bug
//            NSString *infoString = @"[App启动时(保存的用户名、密码、gltoken为空)自动退出登录状态]";
//            NDC_POST_Notification(FKYLogoutForRequestFail, nil, (@{@"msg": infoString}));
        }
    }
}


#pragma mark -

+ (BOOL)checkLoginExistByModelStyle
{
    // 默认为未弹出登录界面
    __block BOOL loginFlag = NO;
    
    NSArray *arrayVC = [[FKYNavigator sharedNavigator] getAllNavControllers];
    if (arrayVC && arrayVC.count > 0) {
        [arrayVC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = (UIViewController *)obj;
            if ([vc isKindOfClass:[FKYNavigationController class]]) {
                FKYNavigationController *navVC = (FKYNavigationController *)vc;
                UIViewController *rootVC = navVC.topViewController;
                if ([rootVC isKindOfClass:[LoginController class]]) {
                    loginFlag = YES;
                    *stop = YES;
                }
            }
        }];
    }
    
    return loginFlag;
}

+ (UIViewController *)getLoginVCByModelStyle
{
    __block UIViewController *loginVC = nil;
    
    NSArray *arrayVC = [[FKYNavigator sharedNavigator] getAllNavControllers];
    if (arrayVC && arrayVC.count > 0) {
        [arrayVC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = (UIViewController *)obj;
            if ([vc isKindOfClass:[FKYNavigationController class]]) {
                FKYNavigationController *navVC = (FKYNavigationController *)vc;
                UIViewController *rootVC = navVC.topViewController;
                if ([rootVC isKindOfClass:[LoginController class]]) {
                    loginVC = rootVC;
                    *stop = YES;
                }
            }
        }];
    }
    
    return loginVC;
}


@end
