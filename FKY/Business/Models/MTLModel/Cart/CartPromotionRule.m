//
//  CartPromotionRule.m
//  FKY
//
//  Created by yangyouyong on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "CartPromotionRule.h"

@implementation PromotionChangeGiftProductModel
//+(NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{
//             @"changePrice" : @"change_price",
//             @"changeQuantity" : @"change_quantity",
//             @"unitCn" : @"unit_cn",
//             @"shortName" : @"short_name"
//             };
//}

@end

@implementation CartPromotionRule
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:NSStringFromSelector(@selector(productPromotionChange))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PromotionChangeGiftProductModel class]];
    }
    return nil;
}
@end
