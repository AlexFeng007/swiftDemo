//
//  FKYDefines.h
//  fangkuaiyi
//
//  Created by yangyouyong on 15/9/6.
//  Copyright (c) 2015年 yangyouyong. All rights reserved.
//

#ifndef __FKY_Defines_h__
#define __FKY_Defines_h__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark -

#if defined(__cplusplus)
#define FKY_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define FKY_EXTERN extern __attribute__((visibility("default")))
#endif


#pragma mark - 设备/应用相关

#define SYSTEM_VERSION_EQ(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GT(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GE(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LT(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LE(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE6PLUS (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736)))
#define IS_IPHONE6 (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667)))
#define IS_IPHONE5 (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)))
#define IS_IPHONE4 (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
#define IS_IPHONEX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)))
#define IS_IPHONEXR (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)))
#define IS_IPHONEXS_MAX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)))

#define IOS9_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)


#pragma mark - color

#define RGBCOLOR(r, g, b) \
[UIColor colorWithRed:r / 256.f green:g / 256.f blue:b / 256.f alpha:1.f]

#define RGBACOLOR(r, g, b, a) \
[UIColor colorWithRed:r / 256.f green:g / 256.f blue:b / 256.f alpha:a]

#define UIColorFromRGB(rgbValue)                                      \
([UIColor                                                          \
colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
blue:((CGFloat)(rgbValue & 0x0000FF)) / 255.0         \
alpha:1.0])

#define UIColorFromRGBA(rgbValue, alphaValue)                         \
[UIColor                                                          \
colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
blue:((CGFloat)(rgbValue & 0x0000FF)) / 255.0         \
alpha:alphaValue]


#pragma mark - 简写

#define STRING_FORMAT(...) [NSString stringWithFormat: __VA_ARGS__]

#define safeBlock(_block, ...) \
if (_block)                \
_block(__VA_ARGS__)

#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 单例
#undef AS_SINGLETON
#define AS_SINGLETON(__class) \
+(__class *)sharedInstance;

#undef DEF_SINGLETON
#define DEF_SINGLETON(__class)                                              \
+(__class *)sharedInstance                                              \
{                                                                       \
static dispatch_once_t once;                                        \
static __class *__singleton__;                                      \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; }); \
return __singleton__;                                               \
}

/**
 *  通知简写
 */
#define NDC [NSNotificationCenter defaultCenter]
#define NDC_ADD_OB(_ob, _s, _n, _obj) [NDC addObserver:_ob selector:_s name:_n object:_obj]
#define NDC_ADD_SELF(_s, _n, _obj) NDC_ADD_OB(self, _s, _n, _obj)
#define NDC_ADD_SELF_NOBJ(_s, _n) NDC_ADD_OB(self, _s, _n, nil)
#define NDC_REMOVE_OB(_ob, _n, _obj) [NDC removeObserver:_ob name:_n object:_obj]
#define NDC_REMOVE_SELF(_n, _obj) NDC_REMOVE_OB(self, _n, _obj)
#define NDC_REMOVE_SELF_ALL [NDC removeObserver:self]
#define NDC_POST_Notification(_n, _ob, _info) [NDC postNotificationName:_n object:_ob userInfo:_info]

#define _LS(_name) NSLocalizedString(_name, @"")

#define NVFromSizeWH(_w, _h) ([NSValue valueWithCGSize:CGSizeMake(_w, _h)])
#define NVFromSize(_s) ([NSValue valueWithCGSize:_s])

#define NetworkReachabilityManager ([AFNetworkReachabilityManager sharedManager])

#define NetworkIsReachable ([NetworkReachabilityManager isReachable]) // 当前是否有网络

#define SELF_SHOP 8353
#define SELF_SHOP_ID @"8353"
#define SELF_SHOP_CartCount_Max 9999999
// 自营店铺id数组
#define SELF_SHOP_ARRAY [NSArray arrayWithObjects:@"8353"/*广东 */, @"125476"/*重庆 */, @"205817"/*昆山 */, nil]

// AppDelegate
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


#ifdef __cplusplus
extern "C" {
#endif
    void performBlockOnMainQueue(void (^block)(void), BOOL waitUntilDone);
    void performBlockOnAnotherQueue(void (^block)(void), BOOL sync);
    void performBlockOnGlobalQueue(dispatch_queue_priority_t priority, void (^block)(void), BOOL sync);
    void performBlockOnGlobalQueueAsync(dispatch_queue_priority_t priority, void (^block)(void));
    void performBlockOnDefaultGlobalQueueAsync(void (^block)(void));
    void performBlockDelay(dispatch_queue_t queue, NSTimeInterval delay, dispatch_block_t block);
    
#ifdef __cplusplus
};
#endif

inline static NSString *StringValue(id obj)
{
    if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [NSString stringWithFormat:@"%@",[obj description]];
    }else if([obj isKindOfClass:[NSString class]]){
        return (NSString *)obj;
    }else{
        return @"";
    }
    return @"";
}


#pragma mark - 架构配置

/**
 *  通过MTLModel类名获取对应的Managed Object类名
 *
 *  @param clazz
 *
 *  @return
 */
Class FKYManagedObjectClassFromMTLModelClass(Class clazz);

/**
 *  通过Managed Object类名获取对应的MTLModel类名
 *
 *  @param clazz
 *
 *  @return
 */
Class FKYMTLModelClassFromManagedObjectClass(Class clazz);

/**
 *  根据2pt的宽/高获取当前设备中实际的宽/高
 *
 *  @param wh
 *
 *  @return
 */
FKY_EXTERN CGFloat FKYWHWith2ptWH(CGFloat wh);

//
#define FKYWH(_wh) FKYWHWith2ptWH(_wh)

/**
 *  根据增减规则和起步规则返回合法的数字
 *
 *  @param inputNumber 输入数字
 *  @param baseCount  起售数字
 *  @param stepCount  递增数字
 *  @param maxCount  最大上限
 *
 *  @return 符合规则的数字
 */
FOUNDATION_EXTERN NSInteger FKYValidNumberForStepperNumber(NSInteger inputNumber, NSInteger baseCount, NSInteger stepCount, NSInteger maxCount);

UIKIT_EXTERN UIFont *FKYSystemFont(CGFloat size);
UIKIT_EXTERN UIFont *FKYBoldSystemFont(CGFloat size);

FOUNDATION_EXTERN NSAttributedString *FKYAttributedStringForString(NSString *string, CGFloat fontSize, UIColor *fontColor);

FOUNDATION_EXTERN NSAttributedString *FKYAttributedStringForStringAndRangesOfSubString(NSString *string, CGFloat fontSize, UIColor *fontColor, NSArray *ranges, CGFloat subFontSize, UIColor *subFontColor);


#pragma mark - UserDefaults相关

#import "NSUserDefaults+FKYExtension.h"


#pragma mark - API

FOUNDATION_EXTERN NSString *const FKY_PC_HOST;
FOUNDATION_EXTERN NSString *const FKY_PC_TEST_HOST;
FOUNDATION_EXTERN NSString *const FKY_HOST;
FOUNDATION_EXTERN NSString *const FKY_TEST_HOST;    // 方快1测试环境
FOUNDATION_EXTERN NSString *const FKY_TEST_API;     // 测试环境
FOUNDATION_EXTERN NSString *const FKY_NORMAL_API;   // 正式环境
FOUNDATION_EXTERN NSString *const FKY_PREFER_API;   // 预生产环境
FOUNDATION_EXTERN NSString *const FKY_LOCAL_API_JIANGSHUAI; // 江帅本地环境

// 当前环境
FOUNDATION_EXTERN NSString *const YHYC_ENVIRONMENT;
// M站
FOUNDATION_EXTERN NSString *const ORDER_PJ_HOST;


#pragma mark - PicAPI

FOUNDATION_EXTERN NSString *const FKY_PIC_HOST;
FOUNDATION_EXPORT NSString *const FKY_PIC_P8_HOST;


#pragma mark - Const String

FOUNDATION_EXTERN NSString *const FKYHomeNoReadMessageNotification;     // 收到透传消息
FOUNDATION_EXTERN NSString *const FKYCheckNetworkStatusNotification;    //
FOUNDATION_EXTERN NSString *const FKYLoginSuccessNotification;          //
FOUNDATION_EXTERN NSString *const FKYLoginFailureNotification;          //
FOUNDATION_EXTERN NSString *const FKYAutoLoginSuccessNotification;      //
FOUNDATION_EXTERN NSString *const FKYPushReadyNotification;             //
FOUNDATION_EXTERN NSString *const FKYSyncCartCompleteNotification;      // 本地同步完成
FOUNDATION_EXTERN NSString *const FKYCartNeedUpdateNotification;        // 需要同步远程购物车
FOUNDATION_EXTERN NSString *const FKYCartAddProductNotification;        // 本地添加和更改完成
FOUNDATION_EXTERN NSString *const FKYCartDeleteProductNotification;     // 本地删除完成
FOUNDATION_EXTERN NSString *const FKYLogoutCompleteNotification;        // 登出完成
FOUNDATION_EXTERN NSString *const FKYTokenOverDateNotification;         // token过期
FOUNDATION_EXTERN NSString *const FKYLocationChanged;                   // 分站更换
FOUNDATION_EXTERN NSString *const FKYHomeSecondKillCountOver;           // 首页之秒杀楼层的倒计时结束
FOUNDATION_EXTERN NSString *const FKYNEWHomeSecondKillCountOver;           // 新首页之秒杀楼层的倒计时结束
FOUNDATION_EXTERN NSString *const FKYSecondKillCountOver;               // 秒杀专区的倒计时结束
FOUNDATION_EXTERN NSString *const FKYHomeRefreshToStopTimers;           // 首页刷新成功后暂停所有首页楼层的倒计时timer
FOUNDATION_EXTERN NSString *const FKYShopRefreshToStopTimers;           // 店铺首页刷新成功后暂停所有首页楼层的倒计时timer
FOUNDATION_EXTERN NSString *const FKYLogoutForRequestFail;              // 请求失败导致退出登录
FOUNDATION_EXTERN NSString *const FKYRCSubmitApplyInfoNotification;     // 退换化模块之提交退换货申请成功
FOUNDATION_EXTERN NSString *const FKYRCSubmitBackInfoNotification;      // 退换化模块之提交回寄信息成功
FOUNDATION_EXTERN NSString *const FKYRefreshASNotification;             // 刷新售后工单列表
FOUNDATION_EXTERN NSString *const FKYRefreshProductDetailNotification; //刷新商品详情

FOUNDATION_EXTERN NSString *const FKYRefreshIMLoginOutNotification; //im登录退出
FOUNDATION_EXTERN NSString *const FKYLiveEndForCommandNotification; //口令进入直播停止山个直播
#pragma mark - iPhoneX适配相关

extern CGFloat const iPhoneX_SafeArea_BottomInset;
extern CGFloat const iPhoneX_SafeArea_TopInset;


#pragma mark - 相关枚举

typedef NS_ENUM(NSInteger, FKYLoginStatus) {
    FKYLoginStatusUnlogin = 0,      // 未登录
    FKYLoginStatusUncertify,        // 已登录,未认证
    FKYLoginStatusLoginComplete     // 已登录,已认证
};

// N-增值税普通发票 Y-增值税专用发
typedef NS_ENUM(NSInteger, FKYTicketType) {
    FKYTicketNone = 0,       // 没有发票
    FKYTicketCommon,         // 增值税普通发票
    FKYTicketSpecific        // 增值税专用发票
};

typedef NS_ENUM(NSInteger, FKYCouponStatus) {
    FKYCouponStatusUnused = 0,      // 未使用
    FKYCouponStatusUsed,            // 已使用
    FKYCouponStatusExpired          // 已过期
};

typedef NS_ENUM(NSInteger, FKYCouponStyle) {
    FKYCouponStyleNone = 0,         // 未设置
    FKYCouponStyleCouponTicket,     // 优惠券
    FKYCouponStyleCouponCode        // 优惠码
};

typedef NS_ENUM(NSInteger, FKYDescribeType) {
    FKYDescribeTypeFirst = 0,           // 只显示第一个文描
    FKYDescribeTypeSecond,              // 显示第二个文描
    FKYDescribeTypeSecondAfterFirst     // 第一个为空显示第二个
};

typedef NS_ENUM(NSInteger, ComboType) {
    ComboTypeNone = 0,  // 非套餐
    ComboTypeCombine,   // 搭配套餐
    ComboTypeFixed      // 固定套餐
};

typedef enum : NSUInteger {
    CartSupplyNameClickType,               // 购物车店铺名称点
    CartFreightGatherClickType,            // 运费凑单
    CartMinSaleGatherClickType             //起售门槛凑单
} GoToShopClickType;

#pragma mark - 

FOUNDATION_EXTERN NSString *FKYDescribeString(NSString *describe, NSString *giftInfo, FKYDescribeType type);

FOUNDATION_EXTERN NSString *const AppStoreUrl;

FOUNDATION_EXTERN BOOL iOS10Later(void);



#endif

