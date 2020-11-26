//
//  FKYCartGroupInfoModel.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartGroupInfoModel.h"

@implementation FKYCartGroupInfoModel
// 数据解析
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"vipPromotionInfo" : @"promotionVipVO"};
}
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(vipPromotionInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYCartVipModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(shareStockVO))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYShareStockInfoModel class]];
    }
    return nil;
}
@end
