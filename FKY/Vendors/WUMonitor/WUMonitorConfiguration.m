//
//  WUMonitorConfiguration.m
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUMonitorConfiguration.h"
#import "WUDeviceInfo.h"

@implementation WUMonitorConfiguration

+ (WUMonitorConfiguration *)defaultConfiguration {
    static WUMonitorConfiguration *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 默认值
        _maxItemsInDatabase = 2000;
        
        _userId = @"";
        _cityName = @"";
        
        _appPrefix = @"";
        _signatureKey = @"";
        _uploadUrl = @"http://upload.111.com.cn/uploadfilelog";
    }
    return self;
}

- (NSString *)tempFileNameWithFileType:(WUMonitorFileType)fileType {
    NSString *platform = @"mobile_ios";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSString *timeStamp = [df stringFromDate:[NSDate date]];
    if (fileType == WUMonitorFileTypeLogin) {
        return [NSString stringWithFormat:@"[%@]_[%@]_[uid]_[%@]_[%@].txt", platform, _appPrefix, _userId, timeStamp];
    } else {
        return [NSString stringWithFormat:@"[%@]_[%@]_[did]_[%@]_[%@].txt", platform, _appPrefix, [WUDeviceInfo UUIDMD5String], timeStamp];
    }
}

- (BOOL)isLogin {
    return _userId.length > 0;
}

- (void)setUserId:(NSString *)userId {
    if ([userId isKindOfClass:NSString.class]) {
        _userId = userId;
    } else if ([userId isKindOfClass:NSNumber.class]) {
        _userId = [(NSNumber *)userId stringValue];
    } else {
        _userId = @"";
    }
}

@end
