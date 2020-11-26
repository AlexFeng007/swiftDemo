//
//  WUSignatureHelper.m
//  FKY
//
//  Created by Rabe on 01/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUSignatureHelper.h"
#import "NSString+MD5.h"

@implementation WUSignatureHelper

/**
 *  功能:获取请求时间戳
 */
+ (NSString *)getLocalTimeStamp
{
    NSTimeInterval localTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *localTimeStampStr = [NSString stringWithFormat:@"%0.0lf", localTimeStamp];
    return localTimeStampStr;
}

/**
 *  功能:获取签名字符串
 */
+ (NSString *)getSignature:(NSDictionary *)aDict secretKey:(NSString *)secretKey
{
    NSMutableDictionary *theDict = [aDict mutableCopy];
    NSArray *keys = [theDict allKeys];
    // 先将参数以其参数名的字典序升序进行排序
    NSArray *sortedKeyArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 遍历排序后的字典，将所有参数按"key=value"格式拼接在一起
    NSMutableString *basestring = [[NSMutableString alloc] init];
    for (NSString *key in sortedKeyArray) {
        NSString *value = [theDict valueForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, value];
        [basestring appendString:str];
    }
    [basestring appendString:secretKey];
    
    // 使用MD5对待签名串求签
    NSString *signature = [basestring stringFromMD5];
    signature = [signature lowercaseString];
    
    return signature;
}

@end
