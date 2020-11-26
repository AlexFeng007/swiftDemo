//
//  FKYCityModel.h
//  FKY
//
//  Created by mahui on 16/1/15.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYCityModel : FKYBaseModel

@property (nonatomic, strong)  NSString *cityId;
@property (nonatomic, strong)  NSString *cityName;
@property (nonatomic, strong)  NSArray *areaList;

@end
