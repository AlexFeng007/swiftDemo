//
//  FKYProductRecommendListModel.m
//  FKY
//
//  Created by 夏志勇 on 2019/6/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYProductRecommendListModel.h"


@implementation FKYProductItemModel

@end


@implementation FKYProductShopModel

// Parse by YYModel
// model = [returnClass yy_modelWithDictionary:aResponseObject];
// 注：使用YYModel解析时，model不需要继承于FKYBaseModel~!@
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{ @"productList" : [FKYProductItemModel class] };
}

// Parse by Mantle
// model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:returnClass];
// 注：使用Mantle解析时，model必须继承于FKYBaseModel<MTLModel>
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    // 解析model数据中的单个数据项...<字典>
    if ([key isEqualToString:NSStringFromSelector(@selector(productList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductItemModel class]];
    }
    
    return nil;
}

@end


@implementation FKYProductHotSaleModel

// Parse by YYModel
// model = [returnClass yy_modelWithDictionary:aResponseObject];
// 注：使用YYModel解析时，model不需要继承于FKYBaseModel~!@
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{ @"productList" : [FKYProductItemModel class] };
}

// Parse by Mantle
// model = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:returnClass];
// 注：使用Mantle解析时，model必须继承于FKYBaseModel<MTLModel>
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    // 解析model数据中的单个数据项...<字典>
    if ([key isEqualToString:NSStringFromSelector(@selector(productList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductItemModel class]];
    }
    
    return nil;
}

@end


@implementation FKYProductRecommendListModel

// 当前model只能使用YYModel才能完全解析~!@

@end
