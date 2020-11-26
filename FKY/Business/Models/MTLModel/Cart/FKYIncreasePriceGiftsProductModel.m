//
//  FKYIncreasePriceGiftsProductModel.m
//  FKY
//
//  Created by airWen on 2017/6/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYIncreasePriceGiftsProductModel.h"

@implementation FKYIncreasePriceGiftsProductModel

#pragma mark - override MTLModel
- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionaryValue = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [dictionaryValue removeObjectForKey:@"isCanSelected"];
    return [NSDictionary dictionaryWithDictionary:dictionaryValue];
}

@end
