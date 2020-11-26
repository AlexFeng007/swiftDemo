//
//  FKYCartCheckOrderProductModel.m
//  FKY
//
//  Created by airWen on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYCartCheckOrderProductModel.h"

@implementation FKYCartCheckOrderProductModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(productPromotion))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductPromotionModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(promotionList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CartPromotionModel class]];
    }
    return nil;
}

@end
