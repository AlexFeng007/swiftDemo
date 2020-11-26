//
//  FKYPush.h
//  FKY
//
//  Created by 张斌 on 2017/7/27.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UserNotifications/UserNotifications.h>

@protocol FKYPushDelegate <NSObject>

- (void)receiveInfo:(NSDictionary *)info isAlert:(BOOL)isAlert;

@end



@interface FKYPush : NSObject

@property (nonatomic, weak) id<FKYPushDelegate> delegate;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *clientId;
/// 当前推送的id识别号
@property (nonatomic, strong) NSString *pushID;
/// 当前推送点击后进入的第一个界面入口
@property (nonatomic, strong) NSString *pushEntryVCName;

AS_SINGLETON(FKYPush);

- (void)setup;

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;


#pragma mark - iOS 10中收到推送消息

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg handle:(void (^)(void))handle;

/// 测试的弹窗方法
/// @param count 弹窗次数
- (void)testPushDataWithCount:(NSInteger) count withDration:(NSInteger) duration;

-(void)requestNoPushHistroy;

@end
