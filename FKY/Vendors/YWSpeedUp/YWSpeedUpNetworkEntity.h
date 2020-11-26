//
//  YWSpeedUpNetworkEntity.h
//  YYW
//
//  Created by 张斌 on 2017/10/18.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWSpeedUpNetworkEntity : NSObject

@property (nonatomic, strong) NSNumber *contentLength;          //返回值长度
@property (nonatomic, strong) NSString *httpStatusCode;         //返回码
@property (nonatomic, strong) NSNumber *requestStartTime;       //请求开始时间
@property (nonatomic, strong) NSString *requestuuid;
@property (nonatomic, strong) NSString *url;                    //网络模块的url
@property (nonatomic, strong) NSNumber *usedTime;               //使用时间

@end
