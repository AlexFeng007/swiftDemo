//
//  FKYAccountBaseInfoModel.m
//  FKY
//
//  Created by 寒山 on 2019/4/17.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYAccountBaseInfoModel.h"

@implementation FKYAccountBaseInfoModel
// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(tools))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYAccountToolsModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(vipInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYVipDetailModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(yydInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYYYDInfoModel class]];
    }
    return nil;
}

@end
