//
//  FKYAddressJsonManager.m
//  FKY
//
//  Created by 夏志勇 on 2019/1/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYAddressJsonManager.h"

@interface FKYAddressJsonManager ()

@property (nonatomic, strong) NSDictionary *addressDic;

@end


@implementation FKYAddressJsonManager

static FKYAddressJsonManager *addressManager = nil;

// 实现创建单例对象的类方法
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        addressManager = [[FKYAddressJsonManager alloc] init];
    });
    return addressManager;
}


#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getLocalAddressJsonContent];
    }
    return self;
}


#pragma mark - Public

- (void)queryAddressJsonForAreaCode:(NSString *)provinceName
                           cityName:(NSString *)cityName
                       districtName:(NSString *)districtName
                           callback:(callback)callback
{
    // 读取/解析本地地区json文件
    [self getLocalAddressJsonContent];
    
    if (self.addressDic && self.addressDic.allKeys.count > 0) {
        //
    }
    else {
        // 读取/解析本地地区json文件失败
        callback(NO, nil, nil, nil);
        return;
    }
    
    // 本地的地址文件中，只有台湾后面带省，其它均不带省~!@
    if ([provinceName isEqualToString:@"台湾"] || [provinceName isEqualToString:@"台湾省"]) {
        // 台湾省不处理，其它名称均去掉省
        provinceName = @"台湾省";
    }
    else {
        // 去掉省、市
        provinceName = [provinceName stringByReplacingOccurrencesOfString:@"省" withString:@""];
        provinceName = [provinceName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        // 对几个特殊的省进行处理
        if ([provinceName containsString:@"香港"]) {
            provinceName = @"香港特别行政区";
        }
        else if ([provinceName containsString:@"澳门"]) {
            provinceName = @"澳门特别行政区";
        }
        else if ([provinceName containsString:@"广西"]) {
            provinceName = @"广西";
        }
        else if ([provinceName containsString:@"内蒙古"]) {
            provinceName = @"内蒙古";
        }
        else if ([provinceName containsString:@"西藏"]) {
            provinceName = @"西藏";
        }
        else if ([provinceName containsString:@"宁夏"]) {
            provinceName = @"宁夏";
        }
        else if ([provinceName containsString:@"新疆"]) {
            provinceName = @"新疆";
        }
    }
    
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 子线程操作
        NSString *proviceCode = @"";    // 省code
        NSString *cityCode = @"";       // 市code
        NSString *districtCode = @"";   // 区code
        
        /// 默认省市区全部匹配成功
        BOOL matchFlag = YES;
        
        // 0.找省
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(infoName CONTAINS '%@')", provinceName]];
        NSArray *arrayProvince = self.addressDic[@"0"]; // 所有省数组
        NSArray *result = [arrayProvince filteredArrayUsingPredicate:predicate];
        if (result && result.count > 0) {
            // 有找到省
            proviceCode = [result.firstObject objectForKey:@"infoCode"]; // 省id
            
            // 1.找市
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(infoName CONTAINS '%@')", cityName]];
            NSArray *arrayCity = [self.addressDic valueForKey:proviceCode]; // 所有市数组
            result = [arrayCity filteredArrayUsingPredicate:predicate];
            if (result.count > 0) {
                // 有找到市
                cityCode = [result.firstObject objectForKey:@"infoCode"]; // 市id
                
                // 2.找区
                predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(infoName CONTAINS '%@')", districtName]];
                NSArray *arrayDistrict = [self.addressDic valueForKey:cityCode]; // 所有区数组
                result = [arrayDistrict filteredArrayUsingPredicate:predicate];
                if (result.count > 0) {
                    // 已找到区
                    districtCode = [result.firstObject objectForKey:@"infoCode"]; // 区id
                }
                else {
                    // 未找到区
                    matchFlag = NO;
                }
            }
            else {
                // 未找到市
                matchFlag = NO;
            }
        }
        else {
            // 未找到省
            matchFlag = NO;
        }
        
        // 若匹配失败，则让用户手动选择地区
        if (matchFlag == NO) {
            // 省市区未全部匹配成功
            
            // 匹配失败
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(NO, nil, nil, nil);
            });
            return;
        }
        
        // 匹配成功
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(YES, proviceCode, cityCode, districtCode);
        });
    }); // block
}


#pragma mark - Private

- (void)getLocalAddressJsonContent
{
    if (self.addressDic && self.addressDic.allKeys.count > 0) {
        return;
    }
    
    // 读取本地文件
    NSError *error;
    NSString *locationFilePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:locationFilePath encoding:NSUTF8StringEncoding error:&error];
    
    if (nil != error) {
        // 读取本地地址文件失败
        NSLog(@"read json string error : %@", error);
        return;
    }
    
    // 读取本地地址文件成功
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (nil != error) {
        // 解析本地地址文件失败
        NSLog(@"cover json string to dictionary error : %@", error);
        return;
    }
    
    self.addressDic = jsonDict;
}

@end
