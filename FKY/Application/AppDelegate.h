//
//  AppDelegate.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FKYTabBarController;
@class FKYSplashView;
@class FKYComplianceMaskView;

// token过期时弹出登录界面的相关逻辑状态
typedef NS_ENUM(NSInteger, ShowLoginType) {
    ShowLoginTypeOver = 0,          // 登录操作完成 or 不显示登录
    ShowLoginTypeNow = 1,           // 立即(直接)显示登录
    ShowLoginTypeSplashFirst = 2,   // 当前正在显示广告图
    ShowLoginTypeAfterSplash = 3,   // 显示广告图后需马上显示登录
    ShowLoginTypeOthers             // 其它状态...<不考虑>
};



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) FKYTabBarController *tabBarController;

/**
 *  @brief app启动时的广告活动图片
 */
@property (nonatomic, strong) FKYSplashView *splashView;

/**
 *  启动时展示的合规选择
 */
@property (nonatomic, strong) FKYComplianceMaskView *complianceMaskView;

// 首页首次显示红包判断
@property (nonatomic, assign) BOOL redPacketShowed;

// 弹出登录界面的相关展示逻辑状态
@property (nonatomic, assign) ShowLoginType showType;


// 显示红包视图
- (void)showRedPacketView;

// toast提示...<无需再手动new一个controller>
- (void)showToast:(NSString *)tip;

// 获取weibo token
- (NSString *)getWeiboToken;

// 获取站点...<调接口>
- (void)requestSiteInfo;
//把合规视图置顶
-(void)bringComplicanceMaskViewFront;
@end

