//
//  FKYPromotionHGInfo.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYPromotionHGInfo.h"

@implementation FKYPromotionHGInfo
// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(hgOptionItem))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYHgOptionItemModel class]];
    }
    return nil;
}
@end
