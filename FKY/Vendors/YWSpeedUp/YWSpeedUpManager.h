//
//  YWSpeedUpManager.h
//  YYW
//
//  Created by 张斌 on 2017/10/17.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWSpeedUpNetworkEntity+YWSpeedUp.h"

typedef NS_ENUM(NSUInteger, ModuleType) {
    ModuleTypeHome = 1001,                  //首页
    ModuleTypeProductDetail = 1002,         //商品详情
    ModuleTypeCategory = 2001,              //分类
    ModuleTypeOrderList = 3002,             //订单列表
    ModuleTypeOrderDetail = 3003,           //订单详情
    ModuleTypeProductList = 4001,           //商品列表
    ModuleTypeBrowser = 9999,               //浏览器
    ModuleTypeFKYBrowser = 99999,           //方块一浏览器
    ModuleTypeFKYHome = 10001               //方块一首页
};

@interface YWSpeedUpManager : NSObject

AS_SINGLETON(YWSpeedUpManager);

//当前时间毫秒
+ (NSNumber *)currentMillisecond;

//取urlString包含第一个参数
+ (NSString *)urlExceptSecondParamFromStr:(NSString *)urlString;

//开始计时，每个模块以最后一次调用为准
- (void)startWithModule:(ModuleType)moduleType;

//浏览器模块的url
- (void)addBrowserString:(NSString *)browserUrlString;

//添加详细接口统计
- (void)addNetworkEntity:(YWSpeedUpNetworkEntity *)networkEntity withModule:(ModuleType)moduleType;

//结束计时，以第一次调用为准，结束后可以继续添加接口统计
- (void)endWithModule:(ModuleType)moduleType;

//上传模块统计
- (void)uploadWithModule:(ModuleType)moduleType;

//添加详细，结束统计，上传统计
- (void)addNetworkEntity:(YWSpeedUpNetworkEntity *)networkEntity endAndUpdateWithModule:(ModuleType)moduleType;

//添加浏览器url,结束统计，上传统计
- (void)addBrowserString:(NSString *)browserUrlString endAndUpdateWithModule:(ModuleType)moduleType;

@end


