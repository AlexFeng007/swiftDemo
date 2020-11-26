//
//  NSManagedObject+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "NSManagedObject+FKYKit.h"
#import "FKYBaseModel.h"
#import <objc/runtime.h>

@implementation NSManagedObject (FKYKit)

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
