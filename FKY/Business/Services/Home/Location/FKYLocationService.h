//
//  FKYLocationService.h
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"

@class FKYLocationModel;


@interface FKYLocationService : FKYBaseService

@property (nonatomic, strong, readonly) NSArray *locations;
@property (nonatomic, strong) FKYLocationModel *currentLoaction;

- (FKYLocationModel *)currentLoaction;

- (void)saveLocation:(FKYLocationModel *)location;

- (void)setCurrentLocation:(FKYLocationModel *)location;

- (NSString *)currentLocationName;

- (void)getLocationsSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

/**
 *  百度地图定位
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)fetchBaiduMapLocationSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

@end
