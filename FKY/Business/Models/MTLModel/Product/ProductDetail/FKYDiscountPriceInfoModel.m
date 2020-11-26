//
//  FKYDiscountPriceInfoModel.m
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYDiscountPriceInfoModel.h"


@implementation FKYDiscountPriceItemModel

@end


@implementation FKYDiscountPriceInfoModel

// Parse
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    // 解析model数据中的单个数据项...<字典>
    if ([key isEqualToString:NSStringFromSelector(@selector(discountDetail))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYDiscountPriceItemModel class]];
    }
    
    return nil;
}

@end
