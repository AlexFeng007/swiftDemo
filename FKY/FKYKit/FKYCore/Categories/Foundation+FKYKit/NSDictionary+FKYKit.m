//
//  NSDictionary+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "NSDictionary+FKYKit.h"
#import "NSString+Contains.h"

@implementation NSDictionary (FKYKit)

- (NSArray *)FKYKeyValueDictionaryPair {
    NSMutableArray *array = [NSMutableArray array];
    [self.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
        NSDictionary *dic = @{obj:self[obj]};
        [array addObject:dic];
    }];
    return array;
}

- (NSArray *)FKYKeyValueStringFormattedPair {
    NSMutableArray *array = [NSMutableArray array];
    [self.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
        NSString *string = [NSString stringWithFormat:@"%@=%@",obj,self[obj]];
        [array addObject:string];
    }];
    return array;
}

- (NSString *)jsonString {
    NSData *data = [NSJSONSerialization
                    dataWithJSONObject:self
                    options:NSJSONWritingPrettyPrinted
                    error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
