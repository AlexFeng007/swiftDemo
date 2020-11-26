//
//  FKYPromotionChangeProductListModel.m
//  FKY
//
//  Created by airWen on 2017/6/8.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYPromotionChangeProductListModel.h"
#import "FKYPromotionChangePriceGradModel.h"

@implementation FKYPromotionChangeProductListModel
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:NSStringFromSelector(@selector(changeRuleList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYPromotionChangePriceGradModel class]];
    }
    return nil;
}
@end
