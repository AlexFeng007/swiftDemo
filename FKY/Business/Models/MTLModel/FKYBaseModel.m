//
//  FKYBaseModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@implementation FKYBaseModel

/**
 *  默认返回key和value相同的dictionary
 *
 *  @return
 */
+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [self p_normalPropertyKeyValue];
}

/**
 *  默认返回以JSON Model类名开头以ManagedObject结尾的类名为Managed Object类名
 *
 *  @return
 */
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(FKYManagedObjectClassFromMTLModelClass(self.class));
}

/**
 *  REST ful 日期格式
 *
 *  @return 日期格式
 */
+ (NSDateFormatter *)defaultDateFormatter
{
    NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}


#pragma mark - Private

+ (NSDictionary *)p_normalPropertyKeyValue
{
    NSSet *propertyNames = [self propertyKeys];
    NSMutableDictionary *dic = [@{} mutableCopy];
    [propertyNames enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        dic[obj] = obj;
    }];
    return dic;
}

- (NSArray *)addHostUrlPropertyNameArray
{
    return nil;
}

- (NSString *)picHost
{
    return nil;
}

@end
