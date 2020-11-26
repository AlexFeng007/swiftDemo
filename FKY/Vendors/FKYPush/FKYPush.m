//
//  FKYPush.m
//  FKY
//
//  Created by 张斌 on 2017/7/27.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYPush.h"

#import "GeTuiSdk.h"
#import "NSString+DictionaryValue.h"
#import "UIWindow+Hierarchy.h"
#import <EBBannerView/EBBannerView.h>
#import <EBBannerView/EBCustomBannerView.h>
#import "FKYRequestService.h"

#if FKY_ENVIRONMENT_MODE == 1   // 线上环境

#define kGtAppId           @"lbqOHcVihz6J60vHTgSPq8"
#define kGtAppKey          @"IWn7lnz6CAA4yTmnqtPpT7"
#define kGtAppSecret       @"NfUA7VvEMM99mIJRFiQqv8"

#elif FKY_ENVIRONMENT_MODE == 2 // 开发环境XCODE调试用这个项目

#define kGtAppId           @"vRxfj30x9uAAJuwk2orEf3"
#define kGtAppKey          @"G085y2OOTK8SbEzNPx1yN5"
#define kGtAppSecret       @"1qGCqckJ3a7PZwIZ4on6R7"

#elif FKY_ENVIRONMENT_MODE == 3 // 测试环境（给测试打包用这个环境）

#define kGtAppId           @"wDAlq5hFdHAGw22Et6s4X1"
#define kGtAppKey          @"0zRL5GuMOU8yz8tUSYKqt3"
#define kGtAppSecret       @"Fa2es7BsVJ9uL2RnOtcH33"



#endif


@interface FKYPush()<GeTuiSdkDelegate>

@property (nonatomic, assign) BOOL isReady;

@property (nonatomic, strong) UIAlertController * alertC;
@property (nonatomic, strong) UIAlertAction * sureAction;
@property (nonatomic, strong) UIAlertAction * cancleAction;
@property (nonatomic, copy) void (^pushTo) (void);

@end


@implementation FKYPush

DEF_SINGLETON(FKYPush);

- (void)setup
{
    // [ GTSdk ]：是否允许APP后台运行
    //    [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    //    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNs - custom method - 开发者自定义的方法
    [self registerRemoteNotification];
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *hexToken = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
          if (![deviceToken isKindOfClass:[NSData class]]) return;
             const unsigned *tokenBytes = [deviceToken bytes];
          hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
    } else {
        hexToken = [[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""];
        hexToken = [hexToken stringByReplacingOccurrencesOfString: @">" withString: @""] ;
        hexToken = [hexToken stringByReplacingOccurrencesOfString: @" " withString: @""];
        
    }
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", hexToken);
    
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:hexToken];
    
    self.deviceToken = hexToken;
    if (self.isReady) {
        NDC_POST_Notification(FKYPushReadyNotification, nil, nil);
    }
    self.isReady = YES;
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    [GeTuiSdk resetBadge];
    [GeTuiSdk setBadge:0];
    
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    
    [self dealWithInfoStr:userInfo[@"payload"] isAlert:NO];
    
    completionHandler(UIBackgroundFetchResultNewData);
    [self popPushViewWithNotify_downiOS10:userInfo];
    
}


/// 测试的弹窗方法
/// @param count 弹窗次数
- (void)testPushDataWithCount:(NSInteger) count withDration:(NSInteger) duration{
    if (count > 20) {
        return;
    }
    FKYCustomPushPopView *popView = [[FKYCustomPushPopView alloc]init];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat marginHeight = FKYWH(20);
    CGFloat pushViewHeight = FKYWH(90);
    [popView showTestData];
    EBCustomBannerView *banner = [EBCustomBannerView showCustomView:popView block:^(EBCustomBannerViewMaker *make) {
        make.portraitFrame = CGRectMake(FKYWH(10), statusHeight+marginHeight, FKYWH(355), pushViewHeight);
        make.portraitMode = EBCustomViewAppearModeTop;
        make.soundID = 1312;
        //make.stayDuration = duration;
        make.stayDuration = 0;
    }];
    popView.receiveNowCallBack = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.pushBoxClickAction = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.popManager = banner;
    [banner show];
    __block NSInteger count_t = count+1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self testPushDataWithCount:count_t withDration:duration];
        //[banner hide];
    });
}

/// 在应用内收到推送弹窗 （iOS10以上含iOS10）
- (void)popPushViewWithNotify_upiOS10:(UNNotification *) notify{
    FKYCustomPushPopView *popView = [[FKYCustomPushPopView alloc]init];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat marginHeight = FKYWH(20);
    CGFloat pushViewHeight = FKYWH(90);
    [popView showNotifData_upiOS10WithNotify:notify];
    
    EBCustomBannerView *banner = [EBCustomBannerView showCustomView:popView block:^(EBCustomBannerViewMaker *make) {
        make.portraitFrame = CGRectMake(FKYWH(10), statusHeight+marginHeight, FKYWH(355), pushViewHeight);
        make.portraitMode = EBCustomViewAppearModeTop;
        make.stayDuration = 3;
    }];
    popView.receiveNowCallBack = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.pushBoxClickAction = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.popManager = banner;
    [banner show];
}

/// 在应用内收到推送弹窗 （iOS10以下）
- (void)popPushViewWithNotify_downiOS10:(NSDictionary *) notify{
    FKYCustomPushPopView *popView = [[FKYCustomPushPopView alloc]init];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat marginHeight = FKYWH(20);
    CGFloat pushViewHeight = FKYWH(90);
    //[[[UIApplication sharedApplication]keyWindow] makeToast:[NSString stringWithFormat:@"%@",notify]];
    [popView showNotifData_downiOS10WithUserInfo:notify];
    EBCustomBannerView *banner = [EBCustomBannerView showCustomView:popView block:^(EBCustomBannerViewMaker *make) {
        make.portraitFrame = CGRectMake(FKYWH(10), statusHeight+marginHeight, FKYWH(355), pushViewHeight);
        make.portraitMode = EBCustomViewAppearModeTop;
        //make.soundID = 1312;
        make.stayDuration = 3;
    }];
    popView.receiveNowCallBack = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.pushBoxClickAction = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.popManager = banner;
    [banner show];
}

/// 弹出自定义内容的框
-(void)popCustomPushWithParam:(NSDictionary *)dic{
    FKYCustomPushPopView *popView = [[FKYCustomPushPopView alloc]init];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat marginHeight = FKYWH(20);
    CGFloat pushViewHeight = FKYWH(90);
    [popView showCustomPushWithParam:dic];
    EBCustomBannerView *banner = [EBCustomBannerView showCustomView:popView block:^(EBCustomBannerViewMaker *make) {
        make.portraitFrame = CGRectMake(FKYWH(10), statusHeight+marginHeight, FKYWH(355), pushViewHeight);
        make.portraitMode = EBCustomViewAppearModeTop;
        make.soundID = 1312;
        make.stayDuration = 3;
    }];
    popView.receiveNowCallBack = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.pushBoxClickAction = ^(NSString * _Nonnull msg) {
        //[[UIApplication sharedApplication].keyWindow makeToast:msg];
    };
    
    popView.popManager = banner;
    [banner show];
}

#pragma mark - iOS 10中收到推送消息

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionSound);
    [self popPushViewWithNotify_upiOS10:notification];
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    [GeTuiSdk resetBadge];
    [GeTuiSdk setBadge:0];
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self dealWithInfoStr:userInfo[@"payload"] isAlert:NO];
    
    completionHandler();
}

#pragma mark - Private

- (void)dealWithInfoStr:(NSString *)infoStr isAlert:(BOOL)isAlert
{
    if (!isAlert) {// 不弹窗
        
    }
    NSDictionary *dic = nil;
    if ([infoStr isKindOfClass:[NSString class]] && infoStr.length>0)
    {
        dic = [infoStr dictionaryValue];
    }
    if (dic) {
        if ([self.delegate respondsToSelector:@selector(receiveInfo:isAlert:)]) {
            [self.delegate receiveInfo:dic isAlert:isAlert];
        }
    }
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
    
    self.clientId = clientId;
    if (self.isReady) {
        NDC_POST_Notification(FKYPushReadyNotification, nil, nil);
    }
    self.isReady = YES;
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
    
    if (!offLine) {
        //[self dealWithInfoStr:payloadMsg isAlert:YES];
        NSDictionary *dic = nil;
        if ([payloadMsg isKindOfClass:[NSString class]] && payloadMsg.length>0)
        {
            dic = [payloadMsg dictionaryValue];
        }
        if (dic){
            [self popCustomPushWithParam:dic];
        }
        
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark -- App在前台收到通知

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg handle:(void (^)(void))handle
{
    if (self.alertC.viewLoaded && self.alertC.view.window) {
        // alert已显示
        self.alertC.title = title;
        self.alertC.message = msg;
        self.pushTo = handle;
        return;
    }
    
    // 主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // 当前controller
        @try {
            UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.currentViewController;
            if (currentVC.presentedViewController == nil) {
                //防止模态窗口错误
                self.alertC.title = title;
                self.alertC.message = msg;
                self.pushTo = handle;
                [currentVC presentViewController:self.alertC animated:true completion:^{
                    //
                }];
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
    });
}

- (UIAlertController *)alertC {
    if (!_alertC) {
        _alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [_alertC addAction:self.cancleAction];
        [_alertC addAction:self.sureAction];
    }
    return _alertC;
}

- (UIAlertAction *)cancleAction {
    if (!_cancleAction) {
        _cancleAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
    }
    return _cancleAction;
}

- (UIAlertAction *)sureAction {
    if (!_sureAction) {
        _sureAction = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.pushTo) {
                self.pushTo();
            }
        }];
    }
    return _sureAction;
}

#pragma mark -- 拉取APP的历史未推送消息

- (void)requestNoPushHistroy{
    MJWeakSelf
    [[FKYRequestService sharedInstance] getNoPushMsgWithParam:nil completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (!isSucceed) {
            return;
        }
        
        NSArray *pushList = [[NSArray alloc]init];
        if ([response isKindOfClass:[NSArray class]]) {
            pushList = (NSArray *)response;
        }
        NSInteger pushMargin = 6;
        for (int i=0; i<pushList.count; i++) {
            NSDictionary *dic = pushList[i];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*pushMargin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf popCustomPushWithParam:dic];
            });
        }
    }];
}


@end
