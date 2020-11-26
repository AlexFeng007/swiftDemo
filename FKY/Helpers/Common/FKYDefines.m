//
//  FKYDefines.m
//  fangkuaiyi
//
//  Created by yangyouyong on 15/9/6.
//  Copyright (c) 2015年 yangyouyong. All rights reserved.
//

#import "FKYDefines.h"

NSString *const FKYManagedObjectClassNameSuffix = @"ManagedObject"; // Managed Object类名结尾
NSString *const FKYMTLModelClassNameSuffix = @"Model";   // MTLModel类名结尾

Class FKYManagedObjectClassFromMTLModelClass(Class clazz) {
    NSString *mtlName = NSStringFromClass(clazz);
    return NSClassFromString([NSString stringWithFormat:@"%@%@",
                              [mtlName substringToIndex:mtlName.length - FKYMTLModelClassNameSuffix.length],
                              FKYManagedObjectClassNameSuffix]);
}

Class FKYMTLModelClassFromManagedObjectClass(Class clazz) {
    NSString *moName = NSStringFromClass(clazz);
    return NSClassFromString([NSString stringWithFormat:@"%@%@",
                              [moName substringToIndex:moName.length - FKYManagedObjectClassNameSuffix.length],
                              FKYMTLModelClassNameSuffix]);
}

CGFloat FKYWHWith2ptWH(CGFloat wh) {
    if (IS_IPHONE6 || IS_IPHONEX) {
        return wh;
    }
    else if (IS_IPHONE6PLUS || IS_IPHONEXR || IS_IPHONEXS_MAX) {
        return wh * (414. / 375.);
    }
    else if (IS_IPHONE5 || IS_IPHONE4) {
        return wh * (320. / 375.);
    }
    else if (IS_IPAD) {
        if ([UIScreen mainScreen].scale >= 2.0) {
            return wh * (768.0 / 375.0);
        }
        else {
            return wh * (384.0 / 375.0);
        }
    }
    
    return wh;
}

UIFont *FKYSystemFont(CGFloat size) {
    return  IOS9_OR_LATER?[UIFont fontWithName:@"PingFangSC-Regular" size:size]:[UIFont systemFontOfSize:size];
}

UIFont *FKYBoldSystemFont(CGFloat size) {
    return  IOS9_OR_LATER?[UIFont fontWithName:@"PingFangSC-Medium" size:size]:[UIFont boldSystemFontOfSize:size];
}

NSAttributedString *FKYAttributedStringForString(NSString *string, CGFloat fontSize, UIColor *fontColor) {
    if (string == nil) {
        return nil;
    }
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithString:string];
    [at addAttributes:@{NSForegroundColorAttributeName: fontColor,
                        NSFontAttributeName: FKYSystemFont(FKYWH(fontSize))
                        }range:NSMakeRange(0, string.length)];
    return at;
}

NSAttributedString *FKYAttributedStringForStringAndRangesOfSubString(NSString *string, CGFloat fontSize, UIColor *fontColor, NSArray *ranges, CGFloat subFontSize, UIColor *subFontColor) {
    if (string == nil || ranges == nil) {
        return nil;
    }
    if ([string  isKindOfClass:[NSNull class]]) {
        return nil;
    }
    for (NSValue *rangeValue in ranges) {
        if ([rangeValue rangeValue].location == NSNotFound) {
            return nil;
        }
    }
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithString:string];
    [at addAttributes:@{NSForegroundColorAttributeName: fontColor,
                        NSFontAttributeName: FKYSystemFont(FKYWH(fontSize))
                        }range:NSMakeRange(0, string.length)];
    
    for (NSValue *rangeValue in ranges) {
        NSRange strRange = [rangeValue rangeValue];
        [at setAttributes:@{NSForegroundColorAttributeName: subFontColor,
                            NSFontAttributeName: FKYSystemFont(FKYWH(subFontSize))
                            } range:strRange];
    }
    return at;
}

NSInteger FKYValidNumberForStepperNumber(NSInteger inputNumber, NSInteger baseCount, NSInteger stepCount, NSInteger maxCount) {
    NSInteger finalCount = 0;
    finalCount = inputNumber > baseCount ? inputNumber : baseCount;
    if (finalCount == baseCount) {
        return baseCount;
    }
    finalCount = ((finalCount - baseCount) % stepCount == 0) ? finalCount : (((finalCount - baseCount) / stepCount + 1)  * stepCount + baseCount);
    finalCount = finalCount >= maxCount ? (maxCount - (maxCount % stepCount) + baseCount): finalCount;
    finalCount = finalCount > maxCount ? (finalCount - stepCount) : finalCount;
    return finalCount;
}

NSString *FKYDescribeString(NSString *describe, NSString *giftInfo, FKYDescribeType type) {
    NSString *returnString = [describe stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    switch (type) {
        case FKYDescribeTypeFirst:
            return returnString.length > 0 ? returnString : @" ";
            break;
        case FKYDescribeTypeSecond:
            return giftInfo;
            break;
        case FKYDescribeTypeSecondAfterFirst:
        {
            returnString = returnString.length > 0 ? returnString : giftInfo;
            return [returnString isKindOfClass:[NSNull class]] ? nil : returnString;
        }
    }
}


#pragma mark - API

NSString *const FKY_PC_HOST = @"https://www.fangkuaiyi.com";
NSString *const FKY_PC_TEST_HOST = @"https://test.fangkuaiyi.com";
NSString *const FKY_PIC_P8_HOST = @"https://p8.maiyaole.com";
NSString *const FKY_HOST = @"https://10.6.32.32:8090";
NSString *const FKY_TEST_HOST = @"https://mobile.test.fangkuaiyi.com";
NSString *const FKY_TEST_API = @"https://10.6.80.145:8090/json";

//NSString *const FKY_NORMAL_API = @"http://mobile.lzh.fangkuaiyi.com/json";   // 正式环境
//NSString *const FKY_NORMAL_API = @"http://mobile.fangkuaiyi.com/json";   // 正式环境
//NSString *const FKY_PREFER_API = @"http://mobile.test.fangkuaiyi.com/json"; // 预生产环境
NSString *const FKY_NORMAL_API = @"https://mobile.fangkuaiyi.com/json";   // 正式环境
//NSString *const FKY_PREFER_API = @"http://mobile.htest.fangkuaiyi.com/json"; // 预生产环境
NSString *const FKY_PREFER_API = @"https://shtest.mobile.fangkuaiyi.com/json"; // 预生产环境
//NSString *const FKY_PREFER_API = @"http://b2b.mobile.fangkuaiyi.com/json";
NSString *const FKY_LOCAL_API_JIANGSHUAI = @"https://10.6.105.22:8081/json"; // 江帅本地环境


/*
 10.6.155.138 pay.yaoex.com
 10.6.155.138 passport.yaoex.com
 10.6.155.138 usermanage.yaoex.com
 10.6.155.138 manage.yaoex.com
 10.6.155.138 mall.yaoex.com
 10.6.155.138 druggmp.yaoex.com
 10.6.155.138 yhycstatic.yaoex.com
 10.6.155.138 m.yaoex.com
 10.6.80.229 p8.maiyaole.com
 10.6.155.138 web-ycaptcha.yaoex.com
 10.6.155.138 arch-sms.yaoex.com
 */


#pragma mark - PicAPI

//NSString *const FKY_PIC_HOST = @"http://www.fangkuaiyi.com"; // 正式环境图片路径
NSString *const FKY_PIC_HOST = @"https://www.fangkuaiyi.com"; // 正式环境图片路径


#if FKY_ENVIRONMENT_MODE == 1   // 线上环境
NSString *const YHYC_ENVIRONMENT  = @"release";
NSString *const ORDER_PJ_HOST = @"https://m.yaoex.com";
#elif FKY_ENVIRONMENT_MODE == 2 // 开发环境
NSString *const YHYC_ENVIRONMENT = @"test";
NSString *const ORDER_PJ_HOST = @"http://m.yaoex.com";
#elif FKY_ENVIRONMENT_MODE == 3 // 测试环境
NSString *const YHYC_ENVIRONMENT = @"test";
NSString *const ORDER_PJ_HOST = @"http://m.yaoex.com";
#endif


#pragma mark - Const String
// Notification Name
NSString *const FKYHomeNoReadMessageNotification =  @"FKYHomeNoReadMessageNotification";   // 收到透传消息
NSString *const FKYCheckNetworkStatusNotification = @"FKYCheckNetworkStatusNotification";
NSString *const FKYLoginSuccessNotification = @"FKYLoginSuccessNotification";
NSString *const FKYLoginSuccessWhenVCDismissNotification = @"FKYLoginSuccessWhenVCDismissNotification";
NSString *const FKYLoginFailureNotification = @"FKYLoginFailureNotification";
NSString *const FKYAutoLoginSuccessNotification = @"FKYAutoLoginSuccessNotification";
NSString *const FKYPushReadyNotification = @"FKYPushReadyNotification";
NSString *const FKYSyncCartCompleteNotification = @"FKYSyncCartCompleteNotification";
NSString *const FKYCartNeedUpdateNotification = @"FKYCartNeedUpdateNotification";    // 需要同步远程购物车
NSString *const FKYCartAddProductNotification = @"FKYCartAddProductNotification";
NSString *const FKYCartDeleteProductNotification = @"FKYCartDeleteProductNotification"; // 本地删除完成
NSString *const FKYLogoutCompleteNotification = @"FKYLogoutCompleteNotification";       // 登出完成
NSString *const FKYTokenOverDateNotification = @"FKYTokenOverDateNotification";         // token过期
NSString *const FKYLocationChanged = @"FKYLocationChanged";
NSString *const FKYHomeSecondKillCountOver = @"FKYHomeSecondKillCountOver";   // 首页之秒杀楼层的倒计时结束
NSString *const FKYNEWHomeSecondKillCountOver = @"FKYNEWHomeSecondKillCountOver";   // 新首页之秒杀楼层的倒计时结束
NSString *const FKYSecondKillCountOver = @"FKYSecondKillCountOver";               // 秒杀专区的倒计时结束
NSString *const FKYHomeRefreshToStopTimers = @"FKYHomeRefreshToStopTimers";   // 首页刷新成功后暂停所有首页楼层的倒计时timer
NSString *const FKYShopRefreshToStopTimers = @"FKYShopRefreshToStopTimers";   // 店铺首页刷新成功后暂停所有首页楼层的倒计时timer
NSString *const FKYLogoutForRequestFail = @"FKYLogoutForRequestFail";         // 请求失败导致退出登录
NSString *const FKYRCSubmitApplyInfoNotification = @"FKYRCSubmitApplyInfoNotification"; // 退换化模块之提交退换货申请成功
NSString *const FKYRCSubmitBackInfoNotification = @"FKYRCSubmitBackInfoNotification";   // 退换化模块之提交回寄信息成功
// Notification Name
NSString *const FKYRefreshASNotification = @"FKYRefreshASNotification";                                 // 刷新售后工单列表
NSString *const FKYRefreshProductDetailNotification = @"FKYRefreshProductDetailNotification";//提交订单后刷新商品详情

//im登录失效
NSString *const FKYRefreshIMLoginOutNotification = @"FKYRefreshIMLoginOutNotification";

//口令进入直播停止山个直播
NSString *const FKYLiveEndForCommandNotification = @"FKYLiveEndForCommandNotification";

#pragma mark - iPhoneX适配相关

CGFloat const iPhoneX_SafeArea_BottomInset = 34;
CGFloat const iPhoneX_SafeArea_TopInset = 88;


#pragma mark -

// App Store Url
NSString *const AppStoreUrl = @"https://itunes.apple.com/cn/app/fang-kuai1/id1058275250?mt=8";

BOOL iOS10Later() {
    return [[[UIDevice currentDevice] systemVersion] compare:@"10" options:NSNumericSearch] == NSOrderedDescending;
}
