//
//  AppDelegate.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+BI.h"
#import "AppDelegate+OpenPrivateScheme.h"

#import "NotificationCenter/NCWidgetController.h"

#import "UIApplication+KeyboardFrame.h"
#import "UIApplication+BadgeNumber.h"

#import "FKYTabBarController.h"
#import "UIViewController+ToastOrLoading.h"

#import "FKYCore.h"
#import "FKYCategories.h"
#import "FKYPush.h"
#import "FKYLoginAPI.h"
#import "FKYAccountLaunchLogic.h"
#import "FKYVersionCheckService.h"

#import "YWSpeedUpManager.h"
#import "NSObject+PerformBlock.h"
#import "HJLaunch.h"
#import "FKYHooker.h"

#import "FKYAccountSchemeProtocol.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYCartSchemeProtocol.h"
#import "FKYWebSchemeProtocol.h"

#import "FKYHomeURLMap.h"
#import "FKYAccountURLMap.h"
#import "FKYTabBarControllerURLMap.h"
#import "FKYCartControllerURLMap.h"
#import "FKYShopControllerURLMap.h"
#import "FKYWebURLMap.h"

#import "NetworkManager.h"
#import "FKYNetworkManager.h"
#import "IQKeyboardManager.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <iflyMSC/iflyMSC.h>
#import "GeTuiSdk.h"
#import <Bugly/Bugly.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WeiboSDK.h"
#import "TXLiteAVSDK_Professional/TXLiteAVSDK.h"
#import "SDImageCache.h"
#import "WWKApi.h"
//#import "BaiduMobStat.h"
#ifdef DEBUG
#import "DoraemonManager.h"
#endif

#define SHOW_REDPACKET_VIEW_TAG 9474

// weibo
NSString *const weiboAppKey = @"1798267981";
NSString *const weiboAppSecret = @"b8dd5ca94e8d3d1cea73674202523d16";

// 听云
NSString *const tingyunAppKey = @"e15d072eab0b44e4a0e5e21f0adcdadb";
NSString *const tingyunURLScheme = @"tingyun.32861";

/*
 听云账号:
 18827378584
 密码:
 000000a
 */

//腾讯即使通讯
#ifdef DEBUG
NSInteger const TxIMAppID = 1400423786;
#else
NSInteger const TxIMAppID = 1400413099;
#endif



@interface AppDelegate () <RDVTabBarControllerDelegate, QQApiInterfaceDelegate, WXApiDelegate, WeiboSDKDelegate, FKYPushDelegate, BuglyDelegate, UIAlertViewDelegate, V2TIMSDKListener,WWKApiDelegate>

// 红包视图
@property (nonatomic, strong) RedPacketView *redPacketView;
//口令
@property (nonatomic, strong)FKYCommandManager *commandManager;
// 微博相关
@property (nonatomic, copy) NSString *weiboToken; // 微博分享时需使用
@property (nonatomic, copy) NSString *wbCurrentUserID; // 保存后未使用

@end


@implementation AppDelegate

#pragma mark - Application Life Cycle

// app启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    [[HJLaunch sharedInstance] launchBeforeShowWindowWithOptions:launchOptions];
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //    #ifdef __IPHONE_11_0
    //        if (@available(ios 11.0,*))
    //        {
    //            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //            UITableView.appearance.estimatedRowHeight = 0;
    //            UITableView.appearance.estimatedSectionFooterHeight = 0;
    //            UITableView.appearance.estimatedSectionHeaderHeight = 0;
    //        }
    //    #endif
    
    //
    [[HJLaunch sharedInstance] launchAfterShowWindowWithOptions:launchOptions];
    
    // 可在后台运行的方法
    [self methodsRunOnBackgroundThreadWhenLaunch];
    
    // 需在前台运行的方法
    [self methodsRunOnForegroundThreadWhenLaunch];
    [[FKYAnalyticsManager sharedInstance]  BI_New_App_Open_Close_Record:@{@"pageCode":@"openApp"}];
    /// 注册企业微信SDK
    [WWKApi registerApp:@"wwautha2fceb831d35052b000065" corpId:@"wwa2fceb831d35052b" agentId:@"1000065"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[FKYPush sharedInstance] requestNoPushHistroy];
    });

    /// 检查pushId状态
    NSString *pushID = [[NSUserDefaults standardUserDefaults] objectForKey:@"BUSINESS_PUSH_ID"];
    if (pushID != nil && ![pushID isEqual:[NSNull null]] && pushID.length > 0){
        [self upLoadPushIdStatus:2];
    }
    
    return YES;
}
// app即将进入前台时，调用此方法
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // 判断当前网络连接状态
    //[[NSNotificationCenter defaultCenter] postNotificationName:FKYCheckNetworkStatusNotification object:nil];
    
    // 判断是在首页后，去掉红包接口
    UIViewController *VC = [self topViewController];
    if ([VC isKindOfClass:[FKYTabBarController class]] && self.tabBarController.selectedIndex == 0) {
        if ([self.tabBarController.viewControllers[0] isKindOfClass:[HomeController class]]){
            HomeController *homeVC = (HomeController *)self.tabBarController.viewControllers[0];
            [homeVC getRedData];
        }
    }
    [[FKYAnalyticsManager sharedInstance]  BI_New_App_Open_Close_Record:@{@"pageCode":@"openApp"}];
    
}

// app启动时、进入前台时、激活时，会调用此方法
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // badge置0
    [application setApplicationBadgeNumber:0];
    [GeTuiSdk resetBadge];
    [GeTuiSdk setBadge:0];
    
    // 延迟0.2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // 检测网络权限是否开启
        [[NetworkManager sharedInstance] checkNetworkStatus];
    });
    
    // 当前场景1：用户在检查订单界面进行微信支付时，若用户不打开微信（取消授权），则app会走当前方法；
    UIViewController *VC = [self topViewController];
    NSString *orderId = UD_OB(@"ORDERID_APP_DID_BECOME_ACTIVE");
    if ([VC isKindOfClass:[CheckOrderController class]] && (orderId != nil && orderId.length > 0)) {
        // 先loading
        [VC showLoading];
        // 延迟1.5s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self openUnpayOrder];
        });
    }
    //口令分享
    [self.commandManager showCommandView];
}
//口令分享
- (FKYCommandManager *)commandManager
{
    if (!_commandManager) {
        _commandManager = [[FKYCommandManager alloc] init];
    }
    return _commandManager;
}
// app从前台进入后台时、变为非激活状态时，会调用此方法
- (void)applicationWillResignActive:(UIApplication *)application
{
    // 隐藏可能已弹出的网络权限提示框
    [[NetworkManager sharedInstance] dismissAlert];
}

// app完全进入后台时，调用此方法
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //app退出埋点
    [[FKYAnalyticsManager sharedInstance]  BI_New_App_Open_Close_Record:@{@"pageCode":@"closeApp"}];
}

// app终止运行（killed）
- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    UD_RM_OB(FKYLocationKey);
    UD_RM_OB(@"currentStation");
    UD_RM_OB(@"currentStationName");
    [UD synchronize];
    [[FKYAnalyticsManager sharedInstance]  BI_New_App_Open_Close_Record:@{@"pageCode":@"closeApp"}];
}
//app接受到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

#pragma mark - Open Url

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString hasPrefix:@"wx"]) {
        [WXApi registerApp:@"wx83e3bc83ebc8b457" universalLink:@"https://m.yaoex.com/fky/"];
    }
    
    if ([url.absoluteString containsString:@"weibo"]) {
        [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:@"fky://"]) {
        return [self p_openPriveteScheme:url];
    }
    if ([url.absoluteString hasPrefix:@"fkywidget://"]) {
        return [self openUrlFromWidget:url];
    }
    
    //return false;
    return [self handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    return [WWKApi handleOpenURL:url delegate:self];
}

/*
// 如果第三方程序向企业微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到企业微信终端程序界面。
- (void)onResp:(WWKBaseResp *)resp {
}
// onReq是企业微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到企业微信终端程序界面。
-(void) onReq:(WWKBaseReq*)req {
}
*/

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.absoluteString hasPrefix:@"fky://"]) {
        return [self p_openPriveteScheme:url];
    }
    if ([url.absoluteString hasPrefix:@"fkywidget://"]) {
        return [self openUrlFromWidget:url];
    }
    
    if ([url.absoluteString hasPrefix:@"tencent"]) {
        [QQApiInterface handleOpenURL:url delegate:self];
    }
    if ([url.absoluteString hasPrefix:@"wx"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.absoluteString containsString:@"weibo"]) {
        [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    // 客户端的回调
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSNumber *code = resultDic[@"resultStatus"];
            if (code.integerValue == 9000) {
                /// 如果当前是通过充值购物金界面，则停留在购物金余额界面
                UIViewController *VC = [self topViewController];
                [VC dismissLoading];
                if ([VC isKindOfClass:[FKYshoppingMoneyBalanceVC class]]) {
                    NSLog(@"已处充值购物金界面~!@");
                    FKYshoppingMoneyBalanceVC *tempVC = (FKYshoppingMoneyBalanceVC *)VC;
                    [tempVC requestAllData];
                    return;
                }
                // 支付宝支付成功
                //                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_PaySuccess) setProperty:nil isModal:NO animated:NO];
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
                    FKYOrderPayStatusVC *paySuccessVC = (FKYOrderPayStatusVC*)destinationViewController;
                    paySuccessVC.fromePage = 1;
                } isModal:false animated:false];
            }
            else {
                // 支付宝支付失败
                
                /// 如果当前是通过充值购物金界面，则停留在购物金余额界面
                UIViewController *VC = [self topViewController];
                [VC dismissLoading];
                if ([VC isKindOfClass:[FKYshoppingMoneyBalanceVC class]]) {
                    NSLog(@"已处充值购物金界面~!@");
                    FKYshoppingMoneyBalanceVC *tempVC = (FKYshoppingMoneyBalanceVC *)VC;
                    [tempVC requestAllData];
                    return;
                }
                
                // 当前展示的VC
                if ([VC isKindOfClass:[FKYAllOrderViewController class]]) {
                    // 若当前已处于订单列表界面，则不再重复跳转，直接刷新
                    NSLog(@"已处于订单列表界面~!@");
                    return;
                }
                
                // 需要先返回到个人中心；若直接进入订单列表界面，导航栈中可能还存在已过期的在线支付方式界面~!@
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 4;
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"0";
                    }];
                }];
            }
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {
        // 支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"platformapi result = %@", resultDic);
        }];
    }
    
    return YES;
}


#pragma mark - Widget

// widget设置...<默认widget不可展开>
- (void)setupForWidget
{
    //    // test
    //    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.yaocheng.com"];
    //    [shared setObject:@"夏志勇1024" forKey:@"widget_title"];
    //    [shared synchronize];
    //
    //    // 设置widget隐藏or显示
    //    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.111.fangkuaiyi.widget"];
}


#pragma mark - APNs

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[FKYPush sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

/*
 * 远程通知注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"FailToRegisterForRemoteNotificationsError %@", error);
}


#pragma mark APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[FKYPush sharedInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}


#pragma mark iOS10中收到推送消息

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    [[FKYPush sharedInstance] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    [[FKYPush sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}


#pragma mark - Notification

- (void)loginSuccess
{
    // 保存push信息
    [self savePush];
    
    [[FKYRequestService sharedInstance] requestForUserVipDetailWithParam:nil completionBlock:^(BOOL isSucceed, NSError *error, id response, FKYVipDetailModel *model) {
        if (isSucceed) {
            [self.tabBarController setTabbarVipBadgeValue:model];
        }
    }];
}

- (void)pushReady
{
    [self savePush];
}

// 用来定位自动退出登录bug的提示操作
- (void)logoutAlert:(NSNotification *)notification
{
    //退出登录后刷新角标
    [self.tabBarController setTabbarVipBadgeValue:nil];
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:notification.userInfo];
    mdic[@"deviceId"] = [FKYAnalyticsUtility getDeviceUUID];
    mdic[@"versioncode"] =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    mdic[@"userId"] = [FKYLoginAPI currentUser].userId;
    NSDictionary *dic = [mdic copy];
    
    // 不再弹提示，而是直接调接口上传服务器
    NSString *remark = @"";
    if (dic) {
        remark = [dic jsonString];
        if (remark && remark.length > 0) {
            //
        }
        else {
            remark = @"";
        }
    }
    FKYAccountLaunchLogic *accountLaunchLogic = [FKYAccountLaunchLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    [accountLaunchLogic addLogWithParam:@{@"remark": remark, @"biz_code": @"autoLogout"} CompletionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            // 上传成功
        }
        else {
            // 上传失败
        }
    }];
}


#pragma mark - Launch

// App启动时需(后台)运行的方法
- (void)methodsRunOnBackgroundThreadWhenLaunch
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 后台
        
        // 通用配置
        [self p_settupURLMaps];
        [self p_setupCoreData];
        [self configBI];
        [self addCDNImage];
        
        // 通过App Groups来共享values
        [self setValuesForAppGroups];
        
        // hook for webview
        [FKYHooker hook];
        
        // 读取保存在本地的cookies
        [[GLCookieSyncManager sharedManager] loadSavedCookies];
        
        // 配置全局alert弹窗风格
        [WUAlertViewConfig shared].itemHighlightTextColor = [UIColor whiteColor];
        [WUAlertViewConfig shared].itemHightlightBackgroundColor = UIColorFromRGB(0xff6666);
        [WUAlertViewConfig shared].buttonHeight = 37;
        
//        SDImageCache.sharedImageCache.maxCacheSize = 1024*1024*48;
//        [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
//        [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        
        [self initMyV2TIMManager];
        // 主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //
        });
    });
}

// App启动时需(前台)运行的方法
- (void)methodsRunOnForegroundThreadWhenLaunch
{
    // 网络状态监控
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 配置监控日志
    [[WUMonitorConfiguration defaultConfiguration] setUserId:[FKYLoginAPI currentUserId]];
    [[WUMonitorConfiguration defaultConfiguration] setCityName:[FKYLocationService new].currentLoaction.substationName];
    [[WUMonitorConfiguration defaultConfiguration] setAppPrefix:@"yaoex"];
    [[WUMonitorConfiguration defaultConfiguration] setSignatureKey:@"yaoex#uploadlog23j8"];
    
    // 配置网络环境
    [self p_configEnvironments];
    
    // UI
    [self p_configApperace];
    [self p_configViewController];
    
    // Widget
    [self setupForWidget];
    
    // 配置第三方IQKeyboard
    [self p_setupIQKeyboard];
    
    // 进入首次弹红包弹出
    self.redPacketShowed = false;
    
    //判断是否同意了合规
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *complicanceAgree= [userDef objectForKey:@"ComplicanceAgree"];
    if (complicanceAgree != nil && complicanceAgree.length > 0 && [complicanceAgree isEqualToString: @"agree"]){
        // 配置第三方SDK
        [self p_configVendors];
        // 显示广告视图...<调接口>
        [self showSplashView];
        
    }else{
        // 显示合规视图
        [self showComplicanceMaskView];
    }
    
    
    // 自动登录...<调接口>
    [FKYLoginAPI autoLogin];
    
    // 配置地址数据库...<调接口>
    [self configAddressDatabase];
    
    // 检查版本更新...<调接口>
    [[FKYVersionCheckService shareInstance] checkAppVersionSuccess:^(BOOL hasNewVersion){
        //
    } failure:nil];
    
    // 注册通知
    NDC_ADD_SELF_NOBJ(@selector(loginSuccess), FKYLoginSuccessNotification);
    NDC_ADD_SELF_NOBJ(@selector(loginSuccess), FKYAutoLoginSuccessNotification);
    NDC_ADD_SELF_NOBJ(@selector(pushReady), FKYPushReadyNotification);
    NDC_ADD_SELF_NOBJ(@selector(logoutAlert:), FKYLogoutForRequestFail);
}


#pragma mark - Public

// 显示红包视图
- (void)showRedPacketView
{
    //判断界面是否有红包的视图
    //首页已经弹出过红包
    if (self.redPacketShowed) {
        return;
    }
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.rootViewController.view.subviews) {
        if (subView.tag == SHOW_REDPACKET_VIEW_TAG) {
            return;
        }
    }
    
    _redPacketShowed = true;
    //请求红包
    @weakify(self);
    [[RedPacketShowProvider sharedInstance] checkRedPacketShowInfoWithBlock:^(BOOL success,RedPacketInfoModel *rpModel,NSString * msg){
        //        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HAS_RP_DRAW"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        if (success) {
            @strongify(self);
            self.redPacketView = [[RedPacketView alloc] init:rpModel];
            [self.redPacketView show];
            self.redPacketView.checkRedPacketAction = ^(){
                @strongify(self);
                [[RedPacketShowProvider sharedInstance] checkRedPacketDrawInfoWithBlock:^(BOOL success ,RedPacketDetailInfoModel *model,NSString * msg){
                    if (success) {
                        //查看详情
                        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RedPacket) setProperty:^(FKYRedPacketViewController *destinationViewController) {
                            destinationViewController.redPacketModel = model;
                        }];
                    }
                    [self.redPacketView dismiss];
                }];
            };
        }
    }];
}

// toast提示
- (void)showToast:(NSString *)tip
{
    if (tip && tip.length > 0) {
        [self.tabBarController toast:tip];
    }
}

// 获取weibo token
- (NSString *)getWeiboToken
{
    return self.weiboToken;
}


#pragma mark - Private

// 地址数据库相关配置
- (void)configAddressDatabase
{
    FKYAddressDBManager *addressManager = [FKYAddressDBManager instance];
    [addressManager configAddressDatabase];
    [addressManager checkAndUpdateAddressDatabase:^(BOOL success) {
        if (success) {
            NSLog(@"db更新成功");
        }
        else {
            NSLog(@"db更新失败");
        }
    }];
}

// APP启动时显示广告视图
- (void)showSplashView
{
    // 显示广告图
    self.showType = ShowLoginTypeSplashFirst;
    
    // 初始化广告视图并调接口请求数据
    @weakify(self);
    self.splashView = [FKYSplashView showSplashViewInSuperView:self.window.rootViewController.view withClickBlock:^(FKYSplashModel * model) {
        @strongify(self);
        // 跳转
        [self jumpSplash:model];
    } andHideBlock:^{
        @strongify(self);
        // 隐藏
        if (self.showType == ShowLoginTypeAfterSplash) {
            // 广告图显示完成后需要立即弹出登录界面...<广告图与登录界面均需展示时，以广告图优先>
            self.showType = ShowLoginTypeNow;
            dispatch_time_t  deadline = dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC);
            dispatch_after(deadline, dispatch_get_main_queue(), ^{
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES];
            });
        }
        else {
            // 广告图显示完成后不需要弹出登录界面，则重置
            self.showType = ShowLoginTypeOver;
        }
    }];
}
//显示合规视图
-(void)showComplicanceMaskView{//UIScreen.main.bounds
    @weakify(self);
    self.complianceMaskView = [[FKYComplianceMaskView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.complianceMaskView.exitBlock = ^{
        //不同意 退出
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:@"unAgree" forKey:@"ComplicanceAgree"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self exitApplication];
    };
    self.complianceMaskView.enterBlock = ^{
        //同意进入
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:@"agree" forKey:@"ComplicanceAgree"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self p_configVendors];
    };
    [self.window.rootViewController.view addSubview:self.complianceMaskView];
    [self.window.rootViewController.view bringSubviewToFront: self.complianceMaskView];
}
-(void)bringComplicanceMaskViewFront{
    [self.complianceMaskView showViewWhenEnterWeb];
    [self.window.rootViewController.view bringSubviewToFront: self.complianceMaskView];
}
//退出app
- (void)exitApplication{
    exit(0);
}
// 获取站点信息
- (void)requestSiteInfo
{
    [[FKYRequestService sharedInstance] getSiteWithParam:nil completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (isSucceed) {
            // 成功
            //NSLog(@"获取站点成功");
            if (response && [response isKindOfClass:[NSDictionary class]] == YES) {
                //NSLog(@"有返回值");
                // response
                NSDictionary *res = (NSDictionary *)response;
                // 名称&code
                NSString *name = res[@"name"];
                NSString *code = res[@"code"];
                if (name && name.length > 0 && code && code.length > 0) {
                    // 有站点值
                    FKYLocationService *lService = [FKYLocationService new];
                    // 当前保存的站点model
                    FKYLocationModel *sModel = [lService currentLoaction];
                    if (!sModel) {
                        // 直接保存
                        FKYLocationModel *location = [FKYLocationModel new];
                        location.substationName = name;
                        location.substationCode = code;
                        location.showIndex = @(1);
                        [lService saveLocation:location];
                        return;
                    }
                    if ([sModel.substationName isEqualToString:name] == NO || [sModel.substationCode isEqualToString:code] == NO) {
                        // 站点不一致，需保存
                        FKYLocationModel *location = [FKYLocationModel new];
                        location.substationName = name;
                        location.substationCode = code;
                        location.showIndex = @(1);
                        [lService saveLocation:location];
                    }
                }
                else {
                    //NSLog(@"[name or code]为空");
                }
            }
        }
        else {
            // 失败
            //NSLog(@"获取站点失败");
        }
    }];
}

// cdn监控
- (void)addCDNImage
{
    [[YWSpeedUpManager sharedInstance] startWithModule:ModuleTypeFKYBrowser];
    YWSpeedUpNetworkEntity *entity = [[YWSpeedUpNetworkEntity alloc] init];
    entity.requestStartTime = [YWSpeedUpManager currentMillisecond];
    [[[FKYNetworkManager defaultManager] sessionManager] GET:@"https://p1.maiyaole.com/111.jpg" parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [entity configWithObject:task];
        [[YWSpeedUpManager sharedInstance] addBrowserString:@"https://p1.maiyaole.com/111.jpg"];
        [[YWSpeedUpManager sharedInstance] addNetworkEntity:entity endAndUpdateWithModule:ModuleTypeFKYBrowser];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [entity configWithObject:task];
        [[YWSpeedUpManager sharedInstance] addBrowserString:@"https://p1.maiyaole.com/111.jpg"];
        [[YWSpeedUpManager sharedInstance] addNetworkEntity:entity endAndUpdateWithModule:ModuleTypeFKYBrowser];
    }];
}

//
- (void)goPushWithUrlString:(NSString *)urlString andParam:(NSDictionary *)param
{
    NSInteger pushType = 0;
    NSString *ItemName = @"";
    NSString *itemPosition = @"";
    NSString *itemTitle = @"";
    NSString *itemContent = @"";
    NSString *sectionId = @"";
    
    if (param[@"type"] != nil) {
        pushType = [param[@"type"] intValue];
        
        if (param[@"pushId"] != nil) {
            sectionId = [NSString stringWithFormat:@"%@",param[@"pushId"]];
        }
        if (param[@"url"] != nil) {
            itemContent = [NSString stringWithFormat:@"%@",param[@"url"]];
        }
        if (param[@"content"] != nil) {
            itemTitle = [NSString stringWithFormat:@"%@",param[@"content"]];
        }
        
        if (pushType == 8){//资质过期提醒
            ItemName = @"资质证照";
            itemPosition = @"9";
        }else if (pushType == 4){//商品降价提醒
            ItemName = @"";
            itemPosition = @"";
        }else if (pushType == 21){//降价专区
            ItemName = @"降价专区";
            itemPosition = @"3";
        }else if (pushType == 22){//优惠券过期提醒
            ItemName = @"优惠券过期提醒";
            itemPosition = @"7";
        }else if (pushType == 23){//特价专区
            ItemName = @"特价专区";
            itemPosition = @"2";
        }else if (pushType == 24){//满折专区
            ItemName = @"满折专区";
            itemPosition = @"4";
        }else if (pushType == 25){//其他活动页
            ItemName = @"其他活动";
            itemPosition = @"6";
        }else if (pushType == 13){//订单未付款提醒
            ItemName = @"物流订单信息";
            itemPosition = @"5";
        }else if (pushType == 14){//订单发货提醒
            ItemName = @"物流订单信息";
            itemPosition = @"5";
        }else if (pushType == 16){//订单签收提醒
            ItemName = @"物流订单信息";
            itemPosition = @"5";
        }else if (pushType == 17){//订单取消提醒
            ItemName = @"物流订单信息";
            itemPosition = @"5";
        }else if (pushType == 3){//im离线消息提醒
            ItemName = @"IM消息";
            itemPosition = @"1";
        }else if (pushType == 26){// 商业化推送
            ItemName = @"商业化推送";
            itemPosition = @"8";
        }
        
        
    }
    [self addBIWithItemName:ItemName itemPosition:itemPosition itemTitle:itemTitle itemContent:itemContent sectionId:sectionId];
    
    //跳转
    if (urlString.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self p_openPriveteScheme:[NSURL URLWithString:urlString]];
            if (pushType == 26){// 商业化推送才做pushID逻辑
                [FKYPush sharedInstance].pushID = sectionId;
                [self upLoadPushIdStatus:1];
            }
            
            //NSLog(@"%@", [NSString stringWithFormat:@"获取到pushID%@,获取到当前vc：%@",[FKYPush sharedInstance].pushID, [FKYPush sharedInstance].pushEntryVCName]);
        });
    }
}

/// 向后台更新pushid的状态
/// @param status 1就是有效  2就是失效
-(void)upLoadPushIdStatus:(int)status{
    
    /// pushId为空不上报
    if ([FKYPush sharedInstance].pushID == nil || [[FKYPush sharedInstance].pushID isEqual:[NSNull null]] || [FKYPush sharedInstance].pushID.length < 1) { //pushID为空
        return;
    }
    
    /// 用户未登录不上报
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin && status == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:[FKYPush sharedInstance].pushID forKey:@"BUSINESS_PUSH_ID"];
        [FKYPush sharedInstance].pushEntryVCName = [FKYNavigator sharedNavigator].topNavigationController.topViewController.className;
        NSDictionary *param = @{@"pushId":[FKYPush sharedInstance].pushID,@"buyerCode":[FKYLoginAPI currentUserId],@"status":@(status)};
        
        [[FKYRequestService sharedInstance] upLoadPushIdStatus:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
            
        }];
        return;
    }else if (status == 2){
        NSDictionary *param = @{@"pushId":[FKYPush sharedInstance].pushID,@"buyerCode":[FKYLoginAPI currentUserId],@"status":@(status)};
        
        [[FKYRequestService sharedInstance] upLoadPushIdStatus:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
            
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BUSINESS_PUSH_ID"];
        [FKYPush sharedInstance].pushID = @"";
        [FKYPush sharedInstance].pushEntryVCName = @"";
    }
    
}

- (void)addBIWithItemName:(NSString *)itemName itemPosition:(NSString *)itemPosition itemTitle:(NSString *)itemTitle itemContent:(NSString *)itemContent sectionId:(NSString *)sectionId {
    
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:sectionId sectionPosition:nil sectionName:@"推送点击" itemId:@"I2016" itemPosition:itemPosition itemName:itemName itemContent:itemContent itemTitle:itemTitle extendParams:nil viewController:[self topViewController]];
}

//
- (void)savePush
{
    FKYPush *push = [FKYPush sharedInstance];
    if (push.clientId && push.clientId.length > 0) {
        // 本地保存
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:push.clientId forKey:@"push_clientId"];
        [userDef synchronize];
    }
    
    // 保存推送信息
    if (push.deviceToken && push.deviceToken.length > 0 &&
        push.clientId && push.clientId.length > 0 &&
        [FKYLoginAPI currentUserId].length > 0) {
        [[FKYVersionCheckService shareInstance] saveDeviceInfoWithClientid:push.clientId devicetoken:push.deviceToken success:nil failure:nil];
    }
}

// 获取当前屏幕显示的viewcontroller
- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

//
- (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// 配置网络环境
- (void)p_configEnvironments
{
    FKYInternalSetDefaultEnvironment([[FKYEnvironment alloc] init]);
    [[FKYNetworkManager defaultManager] updateURLSessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
}

//
- (void)p_configViewController
{
    self.tabBarController = [FKYTabBarController shareInstance];
    self.tabBarController.delegate = self;
    [FKYNavigator sharedNavigator].rootViewController = self.tabBarController;
    
    self.tabBarController.navigationController.navigationBarHidden = YES;
}

//
- (void)p_settupURLMaps
{
    [FKYNavigator configGlobalScheme:@"fyk"];
    [FKYNavigator configGlobalHost:@"com.111.fky"];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYHomeURLMap alloc] init]];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYAccountURLMap alloc] init]];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYTabBarControllerURLMap alloc] init]];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYCartControllerURLMap alloc] init]];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYShopControllerURLMap alloc] init]];
    [[FKYNavigator sharedNavigator] addURLMap:[[FKYWebURLMap alloc] init]];
}

//
- (void)p_configApperace
{
    // 导航条
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //[navigationBar setBackgroundImage:[UIImage FKY_imageWithColor:UIColorFromRGB(0xf54b41)] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:[UIImage FKY_imageWithColor:UIColorFromRGB(0xffffff)] forBarMetrics:UIBarMetricsDefault];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeZero;
    [navigationBar setTitleTextAttributes:@{ NSFontAttributeName : FKYSystemFont(FKYWH(17)),
                                             NSForegroundColorAttributeName : [UIColor whiteColor],
                                             NSShadowAttributeName : shadow }];
    // 设置底部分隔线
    //[navigationBar setShadowImage:[UIImage FKY_imageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]]];
    [navigationBar setShadowImage:[UIImage FKY_imageWithColor:UIColorFromRGB(0xE6E6E6)]];
    
    // 显示状态栏
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:YES];
    [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

//
- (void)p_setupIQKeyboard
{
    // 设置IQKeyboardManager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide; // 默认隐藏切换功能
    
    //YYTextView
    [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class]
                                  didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification
                                    didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
}

// MagicalRecord...<CoreDate相关>
- (void)p_setupCoreData
{
    [MagicalRecord setDefaultModelNamed:@"FKY.momd"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"fky.sqlite"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strDocDir = [paths objectAtIndex:0];
    NSLog(@"%@", strDocDir);
}

// 第三方sdk配置
- (void)p_configVendors
{
    // 微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:weiboAppKey];
    
    // 微信分享
    [WXApi registerApp:@"wx83e3bc83ebc8b457" universalLink:@"https://m.yaoex.com/fky/"];
    
    // 百度地图
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    [mapManager start:@"vGaXoGLvp8DW2uZhVqawyYmM" generalDelegate:nil];
    
    // QQ分享
    id qShare = [[TencentOAuth alloc] initWithAppId:@"1104849171" andDelegate:nil];
    NSLog(@"qq share object: %@", qShare);
    
    //腾讯小直播配置
    [TXLiveBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/71e81203a3440637751835680ad71cfe/TXLiveSDK.licence" key:@"53545f4e3028fa95a834ac5ac44081b9"];
    
    // 推送...<个推>
    FKYPush *push = [FKYPush sharedInstance];
    push.delegate = self;
    [push setup];
    
    // 讯飞语音
    [IFlySpeechUtility createUtility:@"appid=5f7fbe91"];
    
    // 百度移动统计...<埋点>
    // [BaiduMobStat defaultStat].enableViewControllerAutoTrack = YES;//5b3dee80
    
    //    #error 【必须！】请在 ai.baidu.com中新建App, 绑定BundleId后，在此填写授权信息
    //    #error 【必须！】上传至AppStore前，请使用lipo移除AipBase.framework、AipOcrSdk.framework的模拟器架构，参考FAQ：ai.baidu.com/docs#/OCR-iOS-SDK/top
    
    /// 百度OCR识别
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    // DoraemonKit...<AMP开发助手>
#ifdef DEBUG
    [[DoraemonManager shareInstance] addH5DoorBlock:^(NSString *h5Url) {
        // 使用自己的H5容器打开这个链接
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> vc) {
            vc.urlPath = h5Url;
        }];
    }];
    [[DoraemonManager shareInstance] install];
#endif
    
#if FKY_ENVIRONMENT_MODE == 1 // 线上环境(正式版)
#if FKY_BUGLY_MODE == 1 // 提审版
    // <听云>监测统计
    [NBSAppAgent startWithAppID:tingyunAppKey];
    // <听云>设置面包屑
    [NBSAppAgent leaveBreadcrumb:@"didFinishLaunchingWithOptions"];
#endif
#endif
    
    /*
     定义字段说明：
     FKY_ENVIRONMENT_MODE：
     1-正式版...<线上环境，用于打回归包与提审包>...<对应Target=FKY_Beta or FKY>
     2-开发版...<开发环境，基本不使用>...<对应Target=FKY_DEV>
     3-测试版...<测试环境，用于提测，打测试包>...<对应Target=FKY_TEST>
     FKY_BUGLY_MODE: 只有正式版(FKY_ENVIRONMENT_MODE=1)才包括此字段定义
     1-提审版...<正式包，用于AppStore提审>
     2-beta版...<正式包，用于回归>
     即：将正式版再一分为二，Target为FKY的包用于提审，需启动Bugly；Target为FKY_Beta的包用于测试回归，不启动Bugly；
     */
#if FKY_ENVIRONMENT_MODE == 1 // 线上环境(正式版)
#if FKY_BUGLY_MODE == 1 // 提审版
    // Bugly异常框架
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES; // 监听卡顿
    config.blockMonitorTimeout = 1.5;
    config.delegate = self;
    [Bugly startWithAppId:@"837b12a1e6" config:config];
    //[Bugly startWithAppId:@"837b12a1e6"];
#endif
#endif
}

// App Groups
- (void)setValuesForAppGroups
{
    NSString *uuid4bd = [NSString stringWithFormat:@"app_bd_ios@%@@", FKYAnalyticsUtility.getDeviceUUID];
    
    // 通过NSUserDefaults来保存key对应的value；其它App可以通过相同的方法来取值；
    NSUserDefaults *userDef = [[NSUserDefaults alloc] initWithSuiteName:@"group.yaocheng.com"];
    [userDef setObject:uuid4bd forKey:@"uuid4bd"];
}


#pragma mark - Business

- (void)paySuccess
{
    UD_RM_OB(@"ORDERID_APP_DID_BECOME_ACTIVE");
    //    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_PaySuccess) setProperty:nil isModal:NO animated:NO];
    /// 如果当前是通过充值购物金界面，则停留在购物金余额界面
    UIViewController *VC = [self topViewController];
    [VC dismissLoading];
    if ([VC isKindOfClass:[FKYshoppingMoneyBalanceVC class]]) {
        NSLog(@"已处充值购物金界面~!@");
        FKYshoppingMoneyBalanceVC *tempVC = (FKYshoppingMoneyBalanceVC *)VC;
        [tempVC requestAllData];
        return;
    }
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
        FKYOrderPayStatusVC *paySuccessVC = (FKYOrderPayStatusVC*)destinationViewController;
        paySuccessVC.fromePage = 2;
    } isModal:false animated:false];
}

// 进入订单列表界面
- (void)openUnpayOrder
{
    // 当前展示的VC
    //    UIViewController *VC = [self topViewController];
    //    [VC dismissLoading];
    
    UIViewController *VC = [self topViewController];
    [VC dismissLoading];
    if ([VC isKindOfClass:[FKYshoppingMoneyBalanceVC class]]) {
        NSLog(@"已处充值购物金界面~!@");
        FKYshoppingMoneyBalanceVC *tempVC = (FKYshoppingMoneyBalanceVC *)VC;
        [tempVC requestAllData];
        return;
    }
    
    if ([VC isKindOfClass:[CheckOrderController class]]) {
        // 当前处于检查订单界面
    }
    else if ([VC isKindOfClass:[FKYAllOrderViewController class]]) {
        // 若当前已处于订单列表界面，则不再重复跳转，直接刷新
        NSLog(@"已处于订单列表界面~!@");
        return;
    }
    
    UD_RM_OB(@"ORDERID_APP_DID_BECOME_ACTIVE");
    
    // 跳转到订单详情界面...<先进入个人中心，再进入订单详情>
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
        destinationViewController.index = 4;
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
            destinationViewController.status = @"1";
        }];
    }];
}


#pragma mark - RDVTabBarControllerDelegate

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSString *itemId;
    NSString *itemName;
    NSInteger index =[tabBarController.viewControllers indexOfObject:viewController];
    switch (index)
    {
        case 0://首页
        {
            itemId = @"I2000";
            itemName = @"首页";
        }
            break;
        case 1://分类
        {
            itemId = @"I2001";
            itemName = @"分类";
        }
            break;
        case 2://店铺馆
        {
            itemId = @"I2002";
            itemName = @"店铺馆";
        }
            break;
        case 3://购物车
        {
            itemId = @"I2003";
            itemName = @"购物车";
        }
            break;
        case 4://我
        {
            itemId = @"I2004";
            itemName = @"我的";
        }
            break;
        default:
            itemId = @"";
            itemName = @"";
            break;
    }
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"底部导航栏" itemId:itemId itemPosition:@"0" itemName:itemName itemContent:nil itemTitle:nil extendParams:nil viewController:tabBarController.selectedViewController];
    return true;
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.tabBarController resetVipTag:tabBarController.selectedIndex];
}


#pragma mark - FKYPushDelegate

- (void)receiveInfo:(NSDictionary *)info isAlert:(BOOL)isAlert
{
    if (isAlert) {
        NSString *url = info[@"url"];
        if ([url isEqualToString:@"fky://message/box"]) {
            //消息盒子
            [[NSNotificationCenter defaultCenter] postNotificationName:FKYHomeNoReadMessageNotification object:nil];
        }
        else {
            [[FKYPush sharedInstance] showAlertWithTitle:info[@"title"] message:info[@"content"] handle:^{
                [self goPushWithUrlString:url andParam:info];
            }];
        }
    }
    else {
        //跳转
        [self goPushWithUrlString:info[@"url"] andParam:info];
    }
}


#pragma mark - QQApiInterfaceDelegate

- (void)isOnlineResponse:(NSDictionary *)response
{
    //
}


#pragma mark - WXApiDelegate & QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req
{
    //
}

- (void)onResp:(id)resp
{
    // 微信支付的返回...<支付的优先级和重要程度最高>
    if ([resp isKindOfClass:PayResp.class]) {
        PayResp *result = resp;
        if (result && result.errStr.length > 0) {
            [self.tabBarController toast:result.errStr];
        }
        switch (result.errCode) {
            case WXSuccess:
                [self paySuccess];
                break;
            case WXErrCodeCommon:
                [self openUnpayOrder];
                break;
            case WXErrCodeUserCancel:
                [self openUnpayOrder];
                break;
            case WXErrCodeSentFail:
                [self openUnpayOrder];
                break;
            case WXErrCodeAuthDeny:
                [self openUnpayOrder];
                break;
            case WXErrCodeUnsupport:
                [self openUnpayOrder];
                break;
            default:
                break;
        }
        return;
    }
    
    // 以下为各平台分享的返回~!@
    NSString *successCode = @"分享成功";
    if ([resp isKindOfClass:QQBaseResp.class]) {
        // QQ分享
        QQBaseResp *response = (QQBaseResp *)resp;
        if (response.result.integerValue == 0) {
            [self.tabBarController toast:successCode];
        }
        return;
    }
    if ([resp isKindOfClass:BaseResp.class]) {
        // 微信分享
        BaseResp *response = (BaseResp *)resp;
        if (response.errCode == 0) {
            [self.tabBarController toast:successCode];
        }
        return;
    }
    
    /*
     关于用户微信分享成功or跳转微信后直接取消分享返回到当前App时，均提示"分享成功"问题的说明：
     
     https://open.weixin.qq.com/cgi-bin/announce?action=getannouncement&key=11534138374cE6li&version=&lang=zh_CN&token=
     为鼓励用户自发分享喜爱的内容，减少“强制分享至不同群”等滥用分享能力，破坏用户体验的行为，微信开放平台分享功能即日起做出如下调整：
     新版微信客户端（6.7.2及以上版本）发布后，用户从App中分享消息给微信好友，或分享到朋友圈时，开发者将无法获知用户是否分享完成。
     具体调整点为：分享接口调用后，不再返回用户是否分享完成事件，即原先的cancel事件和success事件将统一为success事件
     */
}


#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseResponse *)response
{
    //
}

// 收到微博的响应
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        WBSendMessageToWeiboResponse *sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString *accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken) {
            self.weiboToken = accessToken;
        }
        NSString *userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        self.weiboToken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
    }
    else if ([response isKindOfClass:WBSDKAppRecommendResponse.class]) {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBShareMessageToContactResponse.class]) {
        WBShareMessageToContactResponse *shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString *accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken) {
            self.weiboToken = accessToken;
        }
        NSString *userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
}


#pragma mark - BuglyDelegate

/**
 *  发生异常时回调
 *  @param exception 异常信息
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
{
    NSLog(@"异常事件代理");
    return [NSString stringWithFormat:@"TEST: %@", exception.userInfo];
}

#pragma mark - 腾讯im即时通讯
- (void)initMyV2TIMManager
{
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    config.logLevel = V2TIM_LOG_NONE;
    [[V2TIMManager sharedInstance] initSDK:TxIMAppID config:config listener:self];
}
- (void)onConnecting{
    NSLog(@"connecting");
}
- (void)onConnectSuccess{
    NSLog(@"connectingSucces");
}
- (void)onConnectFailed:(int)code err:(NSString *)err{
    
}
//在线时票据过期
- (void)onUserSigExpired{
    [[NSNotificationCenter defaultCenter] postNotificationName:FKYRefreshIMLoginOutNotification object:nil];
}
//当前用户被踢下线
- (void)onKickedOffline{
    [[NSNotificationCenter defaultCenter] postNotificationName:FKYRefreshIMLoginOutNotification object:nil];
}

@end
