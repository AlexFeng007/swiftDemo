//
//  HJURLCache.h
//  HJFramework
//  功能:重写URL缓存
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJURLCache : NSURLCache

+ (instancetype)standardURLCache;

/**
 *  功能:根据最新的接口版本号进行处理
 *  param:dict，格式{methodName:version}
 */
- (void)dealWithNewInterfaceVersionDict:(NSDictionary *)versionDict;

@end
