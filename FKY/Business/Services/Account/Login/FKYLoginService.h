//
//  FKYLoginService.h
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"
#import "FKYTranslatorHelper.h"
#import "FKYUserInfoModel.h"


@interface FKYLoginService : FKYBaseService

@property (nonatomic, strong)  FKYUserInfoModel *userInfoModel;

/**
 *  当前用户
 *
 *  @return 本地存储的登录用户
 */
+ (FKYUserInfoModel *)currentUser;

/**
 *  登录状态
 *
 *  @return 用户登录状态
 */
+ (FKYLoginStatus)loginStatus;

/**
 *  退出账户
 *
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)logoutSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

@end
