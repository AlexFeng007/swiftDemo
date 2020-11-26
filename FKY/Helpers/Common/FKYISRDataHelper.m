//
//  FKYISRDataHelper.m
//  FKY
//
//  Created by hui on 2018/6/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYISRDataHelper.h"

@implementation FKYISRDataHelper

/**
 parse JSON data
 params,for example：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 **/
+ (NSString *)stringFromJson:(NSString *)params
{
    if (params == NULL) {
        return nil;
    }
    if (params == nil) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic != nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

/**
 parse JSON data for cloud grammar recognition
 **/
+ (NSString *)stringFromABNFJson:(NSString *)params
{
    if (params == NULL) {
        return nil;
    }
    if (params == nil) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSArray *wordArray = [resultDic objectForKey:@"ws"];
    for (int i = 0; i < [wordArray count]; i++) {
        NSDictionary *wsDic = [wordArray objectAtIndex: i];
        NSArray *cwArray = [wsDic objectForKey:@"cw"];
        
        for (int j = 0; j < [cwArray count]; j++) {
            NSDictionary *wDic = [cwArray objectAtIndex:j];
            NSString *str = [wDic objectForKey:@"w"];
            NSString *score = [wDic objectForKey:@"sc"];
            [tempStr appendString: str];
            [tempStr appendFormat:@" Confidence:%@",score];
            [tempStr appendString: @"\n"];
        }
    }
    return tempStr;
}

@end
