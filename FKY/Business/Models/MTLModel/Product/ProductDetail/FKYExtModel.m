//
//  FKYProductSpecificationModel.m
//  FKY
//
//  Created by mahui on 15/11/25.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYExtModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSObject+Property.h"

@implementation FKYExtModel


- (NSDictionary *)fky_keyMap {
    return @{
             @"commonName" : @"【通用名称】" ,
             @"commonNamePinyin" : @"【商品名拼音】" ,
             @"productName" : @"【商品名称】" ,
             @"incredinet" : @"【成分】" ,
             @"character" :  @"【性状】" ,
             @"actionType" : @"【作用类别】" ,
             @"adaptationDisease" : @"【适应症】" ,
             @"directions" : @"【用法用量】" ,
             @"untowardEffect" : @"【不良反应】" ,
             @"taboo" : @"【禁忌】" ,
             @"announcements" : @"【注意事项】" ,
             @"drugInteractions" : @"【药物相互作用】" ,
             @"pharmacologicAction" : @"【药理作用】" ,
             @"storage" : @"【贮藏】" ,
             @"pack" : @"【包装】" ,
             @"expiryDate" : @"【有效期】" ,
             @"carriedStandard" : @"【执行标准】" ,
             @"manualRevisionDate" : @"【说明书修订日期】"
             };
}

- (NSArray *)rangedPropertyName {
    return @[
             @"commonName",
             @"commonNamePinyin" ,
             @"productName",
             @"incredinet" ,
             @"character" ,
             @"actionType" ,
             @"adaptationDisease" ,
             @"directions" ,
             @"untowardEffect" ,
             @"taboo" ,
             @"announcements",
             @"drugInteractions"  ,
             @"pharmacologicAction" ,
             @"storage" ,
             @"pack" ,
             @"expiryDate"  ,
             @"carriedStandard" ,
             @"manualRevisionDate"
             ];
}

- (NSString *)mappedForKey:(NSString *)key {
    
    return [[self fky_keyMap] stringForKey:key];
}

- (NSInteger)numberOfValuesToShow {
    NSArray *skippedProperty = @[@"commonName",
                                 @"commonNamePinyin",
                                 @"productName",];
    NSArray *propertyKeys = [self allPropertyKeys];
    __block NSInteger number = 2;
    [propertyKeys enumerateObjectsUsingBlock:^(NSString *_Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![skippedProperty containsObject:key]) {
            number += 1;
        }
    }];
    return number;
}

- (NSString *)textForIndex:(NSIndexPath *)index {
    NSString *propertyKey = nil;

        propertyKey = [self rangedPropertyName][index.section + 1];
        if (index.row == 0) {
            return [[self fky_keyMap] objectForKey:propertyKey];
        }else{
            if ([self respondsToSelector:NSSelectorFromString(propertyKey)]) {
                return [self valueForKey:propertyKey];
            }
            return nil;
        }
}


@end
