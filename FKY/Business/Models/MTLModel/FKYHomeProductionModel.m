//
//  FKYHomeProductModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYHomeProductionModel.h"

@implementation FKYHomeProductionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"stepCount" : @"addSaleSize",
             @"baseCount" : @"minSaleSize"
             };
}

@end
