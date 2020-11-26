//
//  FKYCartProductModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartProductModel.h"
#import "FKYHomeProductionModel.h"
#import "FKYCartProductPromoteModel.h"
#import <Mantle/Mantle.h>

@implementation FKYCartProductModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"giftDescribe": @"describe",
             };
}

-(NSArray *)addHostUrlPropertyNameArray {
    return @[
             NSStringFromSelector(@selector(spuPicUrl))
             ];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:NSStringFromSelector(@selector(activityDtoList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYCartProductPromoteModel class]];
    }
    
//    if ([key isEqualToString:NSStringFromSelector(@selector(activityModel))]) {
//        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYCartProductPromoteModel class]];
//    }
    
    return nil;
}

- (void)copyPropertiesFromHomeModel:(FKYHomeProductionModel *)model {
    NSDictionary *dic = [[model class] managedObjectKeysByPropertyKey];
    NSSet *propertyNames = [self.class propertyKeys];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        id mapedValue = [model valueForKey:key];
        if ([key isEqualToString:@"minSalesNumber"]) {
            key = @"minSaleSize";
        }
        if ([key isEqualToString:@"stepCount"]) {
            key = @"addSaleSize";
        }
        
        if ([key isEqualToString:@"addedCount"]) {
            key = @"quantity";
        }
        
        if ([propertyNames containsObject:key]) {
            [self setValue:mapedValue forKey:key];
        }
    }];
}

- (FKYHomeProductionModel *)transToHomeProductionModel {
    FKYHomeProductionModel *model = [FKYHomeProductionModel new];
    NSDictionary *dic = [[self class] managedObjectKeysByPropertyKey];
    NSSet *propertyNames = [model.class propertyKeys];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        id mapedValue = [self valueForKey:key];
        if ([key isEqualToString:@"minSaleSize"]) {
            key = @"baseCount";
        }
        if ([key isEqualToString:@"addSaleSize"]) {
            key = @"stepCount";
        }
        if ([key isEqualToString:@"quantity"]) {
            key = @"addedCount";
        }
        
        if ([propertyNames containsObject:key]) {
            [model setValue:mapedValue forKey:key];
        }
    }];
    return model;
}

//+()

@end
