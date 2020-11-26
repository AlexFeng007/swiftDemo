//
//  HJGlobalValue.h
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HJGlobalValue : NSObject
AS_SINGLETON(HJGlobalValue)

@property (nonatomic) NSTimeInterval deltaTime;     // 服务器时间-客户端时间

@property (nonatomic, copy) NSString *token;        // token
@property (nonatomic, copy) NSString *provinceName; // 当前省份名称
@property (nonatomic, copy) NSNumber *provinceId;   // 当前省份id
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *countyName;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

@end
