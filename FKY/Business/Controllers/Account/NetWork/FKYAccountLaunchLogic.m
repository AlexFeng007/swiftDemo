//
//  FKYAccountLaunchLogic.m
//  FKY
//
//  Created by Lily on 2018/2/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYAccountLaunchLogic.h"
#import "FKYAccountNILaunch.h"
#import <SAMKeychain/SAMKeychain.h>
#import "FKYAccountPicCodeModel.h"
#import "FKYWalletModel.h"
#import "FKYAccountToolsModel.h"

@implementation FKYAccountLaunchLogic

#pragma mark - 发送短信验证码
- (void)sendSmsWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch sendSmsWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject,anError);
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 数据处理...<注册、登录、切换账号>
// data: 返回值
// param: 入参
// flagChange: 是否为切换账号
+ (void)handleResponseData:(NSDictionary *)data forRequest:(NSDictionary *)param withFlag:(BOOL)flagChange
{
    // 保存用户登录后的相关信息...<手动解析用户model>
    FKYUserInfoModel *userModel = [FKYUserInfoModel new];
    userModel.loginName = param[@"username"]; // 用户名
    if (!flagChange) {
        userModel.password = param[@"password"]; // 密码
    }
    userModel.userType = data[@"ycuserType"];
    userModel.token = data[@"yctoken"];
    userModel.userName = data[@"ycusername"];
    userModel.nameList = data[@"ycnameList"];
    userModel.avatarUrl = data[@"ycavatarUrl"];
    userModel.gltoken = data[@"ycgltoken"];
    userModel.enterpriseName = data[@"ycenterpriseName"];// 企业名
    userModel.userId = data[@"ycuserId"];
    userModel.sessionId = data[@"yctoken"];
    userModel.mobile = data[@"mobile"];
    userModel.substationCode = data[@"ycstation"];
    userModel.substationName = data[@"ycstationName"];
    userModel.city_id = data[@"ycstation"];
    userModel.ycenterpriseId = data[@"ycenterpriseId"];
    userModel.stationName = data[@"ycstationName"];
    userModel.roleId = data[@"ycroleId"];
    
    // 单独对ycenterpriseId进行优化处理
    id ycenterpriseId = data[@"ycenterpriseId"];
    if (ycenterpriseId) {
        // 不为空
        if ([ycenterpriseId isKindOfClass:[NSString class]]) {
            // string
            userModel.ycenterpriseId = ycenterpriseId;
        }
        else if ([ycenterpriseId isKindOfClass:[NSNumber class]]) {
            // number
            NSNumber *ycid = (NSNumber *)ycenterpriseId;
            userModel.ycenterpriseId = [NSString stringWithFormat:@"%d", ycid.intValue];
        }
        else {
            // others
            userModel.ycenterpriseId = @"";
        }
    }
    else {
        // 为空
        userModel.ycenterpriseId = @"";
    }
    
    if (userModel.gltoken.length > 0) {
        [HJGlobalValue sharedInstance].token = userModel.gltoken;
    }
    
    // 加Alert来定位自动退出登录的bug
//    NSString *infoString = [NSString stringWithFormat:@"[(注册)更新gltoken:%@]", userModel.gltoken];
//    NDC_POST_Notification(FKYLogoutForRequestFail, nil, (@{@"msg": infoString}));
    
    if (!flagChange) {
        // Keychain保存用户登录时的账号和密码  手机号
        if ([param objectForKey:@"loginMobile"]) {
             [SAMKeychain setPassword:param[@"loginMobile"] forService:@"loginMobile" account:@"admin"];
        }else{
            [SAMKeychain setPassword:param[@"password"] forService:@"password" account:@"admin"];
            [SAMKeychain setPassword:param[@"username"] forService:@"username" account:@"admin"];
        }
    }
 
    // 配置监控日志
    [[WUMonitorConfiguration defaultConfiguration] setUserId:userModel.userId];
    
    // 保存用户信息
    [FKYLoginAPI shareInstance].loginUser = userModel;
    
    // 保存手机号
    if (data[@"mobile"] && data[@"mobile"] != [NSNull null]) {
        UD_ADD_OB(data[@"mobile"] ? data[@"mobile"] : @"", @"user_mobile");
    }
    
    // 先删除
    UD_RM_OB(FKYCurrentUserKey);
    [UD synchronize];
    // 保存用户登录信息
    NSData *userInfo = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    UD_ADD_OB(userInfo, FKYCurrentUserKey);
    // 保存token
    UD_ADD_OB(userModel.token, @"user_token");
    if (flagChange) {
        // 移除收货地址缓存，防止切换企业后，收货地址没有及时切换
        UD_RM_OB(FKYCurrentAddressKey);
    }
    [UD synchronize];
    
    // 同步用户分站
    FKYLocationModel *lm = [[FKYLocationModel alloc] init];
    lm.substationName = [data[@"ycstationName"] length] ? data[@"ycstationName"] : @"默认";
    lm.substationCode = [data[@"ycstation"] length] ? data[@"ycstation"] : @"000000";
    lm.showIndex = @(1);
    lm.isCommon = @(0);
    [[FKYLocationService new] setCurrentLocation:lm];
    
    // 更新cookie
    [[GLCookieSyncManager sharedManager] updateAllCookies];
}

#pragma mark - 注册
- (void)registWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch registWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)aResponseObject;
            [FKYAccountLaunchLogic handleResponseData:data forRequest:param withFlag:NO];
        }
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject,anError);
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 登录
- (void)loginWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch loginWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)aResponseObject;
            [FKYAccountLaunchLogic handleResponseData:data forRequest:param withFlag:NO];
        }
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject,anError);
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 切换账户
- (void)changeUserWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch changeUserWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)aResponseObject;
            [FKYAccountLaunchLogic handleResponseData:data forRequest:param withFlag:YES];
        }
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject,anError);
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 刷新token
- (void)refreshTokenWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch refreshTokenWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if ([aResponseObject isKindOfClass:[NSString class]] && anError == nil) {
            if (((NSString *)aResponseObject).length>0) {
                FKYUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:UD_OB(FKYCurrentUserKey)];
                userModel.gltoken = (NSString *)aResponseObject;
                
                // 先删除
                UD_RM_OB(FKYCurrentUserKey);
                // 保存用户登录信息
                NSData *userInfo = [NSKeyedArchiver archivedDataWithRootObject:userModel];
                UD_ADD_OB(userInfo, FKYCurrentUserKey);
                [UD synchronize];
                
                [HJGlobalValue sharedInstance].token = (NSString *)aResponseObject;
                
                // 刷新token后更新cookie
                [[GLCookieSyncManager sharedManager] updateAllCookies];
            }
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
        }
        
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject,anError);
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 获取用户信息
- (void)getUserInfoCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch checkDetailInfoAndCompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && aResponseObject && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            // date
            NSDictionary *data = (NSDictionary *)aResponseObject;
            
            // 保存手机号
            if (data[@"mobile"] && data[@"mobile"] != [NSNull null]) {
                UD_ADD_OB(data[@"mobile"] ? data[@"mobile"] : @"", @"user_mobile");
            }
            
            // 保存企业名称
            NSString *enterpriseName = data[@"enterpriseName"];
            if (enterpriseName && enterpriseName.length > 0) {
                // 用户model
                FKYUserInfoModel *userModel = [FKYLoginAPI currentUser];
                if (userModel) {
                    // 保存企业名...<用户在资质审核通过前无企业名称>
                    userModel.enterpriseName = enterpriseName;
                    // 保存用户信息
                    [FKYLoginAPI shareInstance].loginUser = userModel;
                    
                    // 先删除
                    UD_RM_OB(FKYCurrentUserKey);
                    // 保存用户登录信息
                    NSData *userInfo = [NSKeyedArchiver archivedDataWithRootObject:userModel];
                    UD_ADD_OB(userInfo, FKYCurrentUserKey);
                    [UD synchronize];
                }
            }
            
            FKYWalletModel *walletModel = [[FKYWalletModel alloc] init];
            walletModel.accountCount = data[@"accountRemain"];
            walletModel.aptitudeCount = data[@"qualificationCount"];
            walletModel.couponCount = data[@"couponCount"];
            walletModel.enterpriseName = data[@"enterpriseName"];
            
            NSDictionary *yydInfo = data[@"yydInfo"];
            walletModel.remainAmount = yydInfo[@"remainAmount"];
            walletModel.status = yydInfo[@"status"];
            walletModel.returnUrl = yydInfo[@"returnUrl"];
            walletModel.limitAppId = yydInfo[@"limitAppId"];
            walletModel.limitOverdue = yydInfo[@"limitOverdue"];
            walletModel.roleType = yydInfo[@"roleType"];
            id isCheck = yydInfo[@"isCheck"];
            if (isCheck && isCheck != [NSNull null]) {
                walletModel.isCheck = ((NSNumber *)isCheck).integerValue;
            }
            id isAudit = yydInfo[@"isAudit"];
            if (isAudit && isAudit != [NSNull null]) {
                walletModel.isAudit = ((NSNumber *)isAudit).integerValue;
            } else {
                walletModel.isAudit = 0;
            }
            //vip模型
            NSDictionary *vipInfo = data[@"vipInfo"];
            walletModel.vipModel = [FKYVipDetailModel yy_modelWithDictionary: vipInfo];
            if (aCompletionBlock) {
                aCompletionBlock(walletModel, nil);
            }
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 版本检查
- (void)checkAppVersionWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch checkAppVersionWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock((NSDictionary *)aResponseObject, nil);
            }
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 手机关键日志上传
- (void)addLogWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch addAppLogWithParam:param CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock((NSDictionary *)aResponseObject, nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 获取站点列表
- (void)getStationListCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch getStationListCompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError) {
            if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
                // dic
                if (aCompletionBlock) {
                    aCompletionBlock((NSDictionary *)aResponseObject, nil);
                }
            }
            else if ([aResponseObject isKindOfClass:[NSArray class]]) {
                // arr
                if (aCompletionBlock) {
                    aCompletionBlock((NSArray *)aResponseObject, nil);
                }
            }
            else {
                if (aCompletionBlock) {
                    aCompletionBlock(nil, anError);
                }
            }
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 获取常用工具列表
- (void)getCommonToolsListCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYAccountNILaunch getCommonToolsListCompletionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSArray class]]) {
            if (aCompletionBlock) {
                aCompletionBlock([NSArray yy_modelArrayWithClass:[FKYAccountToolsModel class] json:aResponseObject], nil);
            }
        }
        else {
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

@end
