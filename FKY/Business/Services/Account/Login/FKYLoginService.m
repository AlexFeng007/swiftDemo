//
//  FKYLoginService.m
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYLoginService.h"
//#import "FKYCartProductMO.h"
//#import "FKYCartProductPromoteMO.h"
//#import "FKYCartProductUnitMO.h"
//#import "FKYCartModel.h"


// 登录
static NSString *loginApi = @"user/userLogin";
// 切换用户
static NSString *switchUserApi = @"passport/api/user/changeUser";


@implementation FKYLoginService

+ (FKYUserInfoModel *)currentUser
{
    return [FKYLoginAPI currentUser];
}

+ (FKYLoginStatus)loginStatus
{
    return [FKYLoginAPI loginStatus];
}

/**
 *  退出账户
 *
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)logoutSuccess:(FKYSuccessBlock)successBlock
              failure:(FKYFailureBlock)failureBlock
{
    // 登出当前账户
    UD_RM_OB(FKYCurrentUserKey);
    UD_RM_OB(FKYLocationKey);
    UD_RM_OB(@"currentStation");
    UD_RM_OB(@"currentStationName");
    UD_RM_OB(FKYCurrentAddressKey);
    UD_RM_OB(FKYMarkAuditStatusForHomeWebPage);
    UD_RM_OB(@"user_token");
    UD_RM_OB(@"isHandelUserGuideMask");
    UD_RM_OB(@"FKY.CredentialsQCListInfo");
    UD_RM_OB(@"FKY.CredentialsInfo");
    UD_RM_OB(@"user_mobile");
    [UD synchronize];
    
    // 清token
    [HJGlobalValue sharedInstance].token = nil;
    // 清用户信息
    [FKYLoginAPI shareInstance].loginUser = nil;
    // 清cookie
    [[GLCookieSyncManager sharedManager] updateAllCookies];
    
    // 发通知
    NDC_POST_Notification(FKYLogoutCompleteNotification, nil, nil);
    
    // 配置监控日志
    [[WUMonitorConfiguration defaultConfiguration] setUserId:@""];
    
    // block
    safeBlock(successBlock,NO);
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
//         [FKYCartProductMO MR_truncateAllInContext:localContext];
//         [FKYCartProductPromoteMO MR_truncateAllInContext:localContext];
//         [FKYCartProductUnitMO MR_truncateAllInContext:localContext];
//     } completion:^(BOOL contextDidSave, NSError *error) {
//         if (error == nil) {
//             safeBlock(successBlock,NO);
//         }
//         else {
//             safeBlock(failureBlock,error.domain);
//         }
//         [[FKYCartModel shareInstance] initilizeLocalProduct];
//         NDC_POST_Notification(FKYLogoutCompleteNotification, nil, nil);
//     }];
}

@end

