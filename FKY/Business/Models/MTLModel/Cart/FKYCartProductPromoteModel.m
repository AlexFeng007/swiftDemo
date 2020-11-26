//
//  FKYCartProductPromoteModel.m
//  FKY
//
//  Created by yangyouyong on 15/11/18.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartProductPromoteModel.h"

@implementation FKYCartProductPromoteModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"activityPrice": @"activityProductSalesPrice.activityPrice",
             @"giftInfo" : @"activityProductRelation.activitySellInfo",
             @"activityInfo": @"giftInfo",
             @"leastUserBuy": @"activityProductRelation.leastUserBuy",
             @"mostUserBuy": @"activityProductRelation.mostUserBuy"
             };
}

@end
