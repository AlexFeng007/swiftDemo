//
//  WUCache.h
//  YYW
//
//  Created by Rabe on 16/8/9.
//  Copyright © 2016年 YYW. All rights reserved.
//  缓存模块  此类不可有子类！

#import <Foundation/Foundation.h>

//店铺相关的数据
#define shop_fky @"shopProducts"//店铺文件的开头
#define shop_time @"shopTime"//存储时店铺时间
#define shop_data @"shopData"//存储的缓存数据
#define shop_pageCount @"pageCount"//店铺的页码
#define shop_pageTotals @"pageTotals"//店铺产品数量
#define shop_offY @"ContentOffsetY"//店铺产品滑动的位置
#define shop_salesVolume @"salesVolume"//店铺产品筛选条件


@interface WUCache : NSObject

/**
 写入缓存

 @param obj 必须遵循<NSCoding>协议
 @param fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 */
+ (void)cacheObject:(id)obj toFile:(NSString *)fileName;

/**
 读取缓存

 @param fileName fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 @return 缓存对象
 */
+ (id)getCachedObjectForFile:(NSString *)fileName;

/**
 删除闪存&内存数据

 @param fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 */
+ (void)removeCacheFile:(NSString *)filename;

//店铺详情缓存上次浏览历史
+ (void)cacheShopObject:(id)obj and:(NSMutableDictionary *)mdic toFile:(NSString *)fileName;

@end
