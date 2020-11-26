//
//  FKYCityModel.m
//  FKY
//
//  Created by mahui on 16/1/15.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYCityModel.h"
#import "FKYAreaModel.h"

@implementation FKYCityModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if (![key isEqualToString:@"areaList"]) {
        return nil;
    }
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYAreaModel class]];
}

@end
