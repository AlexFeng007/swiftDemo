//
//  FKYUmengConfig.m
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "FKYUmengConfig.h"
#import <UMCommon/UMCommon.h>            // 公共组件是所有友盟产品的基础组件，必选
#import <UMCommon/MobClick.h>      // 统计组件
#import <Aspects/Aspects.h>


@implementation FKYUmengConfig

#pragma mark - life cycle

+ (void)load
{
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *_Nonnull note) {
//#if FKY_ENVIRONMENT_MODE == 1 // 线上环境(正式版)
//    #if FKY_BUGLY_MODE == 1 // 提审版
        /* SDK初始化 */
        [self setup];
        /* 统计详细功能 */
        [self hook]; // 页面统计
        [self crashReport]; // 错误收集
        [self profileSignIn]; // 账号统计
//    #endif
//#endif
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        observer = nil;
    }];
}

#pragma mark - delegate

#pragma mark - ui

#pragma mark - public

#pragma mark - action

#pragma mark - private

+ (void)setup
{
    // 配置友盟SDK产品并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    
#ifdef FKY_ENVIRONMENT_MODE
    #if FKY_ENVIRONMENT_MODE != 1   // 非线上环境
        [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    #endif
#endif
    
    [UMConfigure initWithAppkey:@"5ac481f5a40fa360ac00012a" channel:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"]];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 统计组件配置
    // [MobClick setScenarioType:E_UM_GAME];  // optional: 仅适用于游戏场景，应用统计不用设置
    // [MobClick setAppVersion:XcodeAppVersion]; // optional: 设置使用shortversion，默认为buildversion
}

+ (void)hook
{
    /*
     页面统计
     在ViewController类的viewWillAppear: 和 viewWillDisappear:中配对调用如下方法：
     */
    [[UIViewController class] aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
         UIViewController *instance = aspectInfo.instance;
//         NSString *pagename = [instance ViewControllerPageType];
//         if (pagename.length) {
//             [MobClick beginLogPageView:pagename];
//         }
        if ([instance respondsToSelector:@selector(ViewControllerPageCode)]) {
            NSString *pageCode = [instance ViewControllerPageCode];
            if (pageCode && pageCode.length > 0) {
                [MobClick beginLogPageView:pageCode];
            }
        }
     }
     error:nil];
    
    [[UIViewController class] aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        UIViewController *instance = aspectInfo.instance;
//        NSString *pagename = [instance ViewControllerPageType];
//        if (pagename.length) {
//            [MobClick endLogPageView:pagename];
//        }
        if ([instance respondsToSelector:@selector(ViewControllerPageCode)]) {
            NSString *pageCode = [instance ViewControllerPageCode];
            if (pageCode && pageCode.length > 0) {
                [MobClick endLogPageView:pageCode];
            }
        }
    }
    error:nil];
}

+ (void)crashReport
{
    // 统计SDK默认是开启Crash收集机制的，如果开发者需要关闭Crash收集机制则设置如下：
    // [MobClick setCrashReportEnabled:NO];   // 关闭Crash收集
}

+ (void)profileSignIn
{
    // 友盟在统计用户时以设备为标准，若需要统计应用自身的账号，下述两种API任选其一接口：
    
    // PUID：用户账号ID.长度小于64字节
    // Provider：账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节 ;
    
//    [MobClick profileSignInWithPUID:@"UserID"];
//    [MobClick profileSignInWithPUID:@"UserID" provider:@"WB"];
}

#pragma mark - property

@end
