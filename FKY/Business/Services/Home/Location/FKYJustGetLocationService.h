//
//  FKYJustGetLocationService.h
//  FKY
//
//  Created by airWen on 2017/7/25.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  定位服务类...<使用百度定位 & 百度地址反编码>

#import <Foundation/Foundation.h>

@protocol FKYJustGetLocationServiceDelegate <NSObject>

- (void)getDetailLocationFailedCode:(NSInteger)erroCode
                             reason:(NSString *)reason;

- (void)getLocationAddress:(NSString *)address
             provinceName:(NSString *)provinceName
                 cityName:(NSString *)cityName
             districtName:(NSString *)districtName;

@end


@interface FKYJustGetLocationService : NSObject

@property (nonatomic, weak) id<FKYJustGetLocationServiceDelegate> callBackDelegate;

- (void)fetchLocation;
- (void)stopFetchLocation;

@end
