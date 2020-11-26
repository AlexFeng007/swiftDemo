//
//  WUDeviceInfo.m
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUDeviceInfo.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "NSString+WUMMD5.h"
#import "Reachability.h"
#import "UIDevice+Hardware.h"

@implementation WUDeviceInfo

+ (BOOL)isReachableViaWiFi {
    Reachability *ry = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [ry currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

+ (NSString *)netTypeStatus {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return @"不可达的网络";
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WiFi";
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            return @"运营商网络";
        }
        default:
            return @"未识别的网络";
    }
}

+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier) {
        NSString *code = [carrier mobileNetworkCode];
        if (code) {
            if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
                return @"China Mobile";
            } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
                return @"China Unicom";
            } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
                return @"China Telecom";
            } else if ([code isEqualToString:@"20"]) {
                return @"China Tietong";
            }
        }
    }
    return @"Unknown Network";
}

+ (NSString *)UUIDString {
    //return [UIDevice currentDevice].identifierForVendor.UUIDString;
    return [UIDevice readIdfvForDeviceId];
}

+ (NSString *)UUIDMD5String {
    return [[self UUIDString] MD5ForLower16Bate];
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)bundleMarketingVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"];
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)currentTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return date;
}

@end
