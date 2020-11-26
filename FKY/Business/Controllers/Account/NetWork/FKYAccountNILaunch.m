//
//  FKYAccountNILaunch.m
//  FKY
//
//  Created by Lily on 2018/2/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYAccountNILaunch.h"

@implementation FKYAccountNILaunch

#pragma mark - 发送短信验证码
+ (HJOperationParam *)sendSmsWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"sendSms" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 注册
+ (HJOperationParam *)registWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"regist" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 登录
+ (HJOperationParam *)loginWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"login" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 刷新token
+ (HJOperationParam *)refreshTokenWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"refresh_token" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 切换用户
+ (HJOperationParam *)changeUserWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"change_user" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 用户详细信息
+ (HJOperationParam *)checkDetailInfoAndCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ycapp" methodName:@"baseInfo" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 版本检查
+ (HJOperationParam *)checkAppVersionWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ycapp/mobile" methodName:@"getUpgrade" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 手机关键日志上传
+ (HJOperationParam *)addAppLogWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ypassport" methodName:@"add_log" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取站点列表
+ (HJOperationParam *)getStationListCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api" methodName:@"mainProvince" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取常用工具列表
+ (HJOperationParam *)getCommonToolsListCompletionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"mobile/home" methodName:@"userCenter/tools" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

@end
