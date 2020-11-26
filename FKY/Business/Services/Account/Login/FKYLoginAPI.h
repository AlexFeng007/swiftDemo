//
//  FKYLoginAPI.h
//  FKY
//
//  Created by yangyouyong on 15/9/18.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYUserInfoModel.h"
#import "FKYLoginService.h"


@interface FKYLoginAPI : NSObject

@property (nonatomic, strong) FKYUserInfoModel *loginUser;
@property (nonatomic, copy) NSString *bdShardId;//bd工具分享佣金ID
/**
 *  单例对象
 *
 *  @return FKYLoginAPI
 */
+ (FKYLoginAPI *)shareInstance;

/**
 *  当前用户
 *
 *  @return 本地存储的登录用户
 */
+ (FKYUserInfoModel *)currentUser;

/**
 *  判断登录状态
 *
 *  @return 登录状态
 */
+ (FKYLoginStatus)loginStatus;

/**
 *  本地已有帐号自动登录
 */
+ (void)autoLogin;

+ (void)logoutSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

+ (NSString *)currentUserSessionId;
+ (NSString *)currentUserId;
+ (NSString *)currentEnterpriseid;
+ (NSString *)currentRoleId;
+ (NSString *)currentUserType;


///**
// *  判断登录界面是否已弹出
// */
//+ (BOOL)checkLoginExist;
//
///**
// *  返回登录vc
// */
//+ (UIViewController *)getLoginVC;

/**
 *  判断登录界面是否已弹出
 */
+ (BOOL)checkLoginExistByModelStyle;

/**
 *  返回登录vc
 */
+ (UIViewController *)getLoginVCByModelStyle;

@end
