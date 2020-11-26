//
//  FKYBaseModel+FKYModelTranslator.m
//  FKY
//
//  Created by yangyouyong on 2016/7/4.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel+FKYModelTranslator.h"
#import <objc/runtime.h>
#import "FKYBaseModel.h"

@implementation FKYBaseModel (FKYModelTranslator)

- (void)copyPropertiesFromBaseModel:(FKYBaseModel *)baseModel {
    NSDictionary *dic = [[baseModel class] managedObjectKeysByPropertyKey];
    NSArray *propertyNames = [self.class p_propertyNames];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        if ([propertyNames containsObject:key]) {
            id tempValue = [baseModel valueForKey:key];
            if (tempValue && ![tempValue isKindOfClass:[NSNull class]]) {
                [self setValue:tempValue forKey:value];
            }
        }
    }];
}

+ (NSArray *)p_propertyNames {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    NSMutableArray *propertyNames = [@[] mutableCopy];
    for (int i = 0; i < propertyCount; i++) {
        const char *name = property_getName(properties[i]);
        [propertyNames addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    if (properties) {
        free(properties);
    }
    return propertyNames;
}

@end
