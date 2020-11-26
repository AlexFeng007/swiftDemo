//
//  WUErrorMessage.m
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUErrorMessage.h"
#import "WUDeviceInfo.h"

@implementation WUErrorInfo

- (instancetype)initWithErrName:(NSString *)errName errType:(WUMonitorError)errType errCode:(NSString *)errCode errDes:(NSString *)errDes {
    if (self = [super init]) {
        _errorName = errName.length ? errName : @"客户端未写入错误名";
        switch (errType) {
            case WUMonitorErrorApi:
                _errorType = @"api";
                break;
            case WUMonitorErrorWeb:
                _errorType = @"h5";
                break;
            case WUMonitorErrorImageLoading:
                _errorType = @"img";
                break;
            default:
                _errorType = @"unknown";
                break;
        }
        _errorCode = errCode.length ? errCode : @"客户端未写入错误码";
        _errorDes = errDes.length ? errDes : @"客户端未写入错误原因";
    }
    return self;
}

@end



@implementation WUErrorMessage

+ (instancetype)errorMessageWithErrName:(NSString *)errName errType:(WUMonitorError)errType errCode:(NSString *)errCode errDes:(NSString *)errDes {
    return [[self alloc] initWithErrName:errName errType:errType errCode:errCode errDes:errDes];
}

- (instancetype)initWithErrName:(NSString *)errName errType:(WUMonitorError)errType errCode:(NSString *)errCode errDes:(NSString *)errDes {
    if (self = [super init]) {
        _netType = [WUDeviceInfo netTypeStatus];
        _sp = [WUDeviceInfo carrierName];
        _area = [WUMonitorConfiguration defaultConfiguration].cityName;
        _uid = [WUMonitorConfiguration defaultConfiguration].userId;
        _errorInfo = [[WUErrorInfo alloc] initWithErrName:errName errType:errType errCode:errCode errDes:errDes];
        _deviceId = [WUDeviceInfo UUIDString];
        _deviceType = [WUDeviceInfo systemName];
        _appVersion = [WUDeviceInfo bundleMarketingVersion];
        _osVersion = [WUDeviceInfo systemVersion];
        _time = [WUDeviceInfo currentTimestamp];
    }
    return self;
}

- (NSString *)jsonValue {
    return [self yy_modelToJSONString];
}

@end
