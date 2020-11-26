//
//  HJClientInfo.m
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import "HJClientInfo.h"
#import "HJGlobalValue.h"
#import "UIDevice+Hardware.h"

//#import "HJKeychain.h"
//#import "HJKeychainDefine.h"


@interface HJGlobalValue()

@property (nonatomic, copy) NSString *clientInfoString;

@end


@interface HJClientInfo ()

@property (nonatomic, copy) NSString *clientAppVersion;
@property (nonatomic, copy) NSString *clientSystem;
@property (nonatomic, copy) NSString *clientVersion;
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *unionKey;
@property (nonatomic, copy) NSNumber *iaddr;
@property (nonatomic, copy) NSString *phoneType;
@property (nonatomic, copy) NSString *clientDeviceType;
@property (nonatomic, copy) NSString *clientAppVersionCode;
@property (nonatomic, copy) NSString *appName;

@end

@implementation HJClientInfo
DEF_SINGLETON(HJClientInfo)

@synthesize deviceToken = _deviceToken;

- (id)init
{
    self = [super init];
    if (self) {
        _clientSystem = @"iossystem";
        _clientVersion = [[UIDevice currentDevice] systemVersion];
        _clientDeviceType = @"iphone";
        _clientSystem = @"iphone";
        _channel = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"];
        _traderName = @"mobile_ios";
        
        _clientAppVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        _clientAppVersionCode = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        _appName = @"fky";

        // deviceid
        _deviceCode = [UIDevice readIdfvForDeviceId];
        
        _iaddr = @1;
        _nettype = @"";
    }
    
    return self;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
//    HJLogI(@"remote notification register success，＃＃＃＃＃＃＃＃＃＃\n token:%@\n##########################", [deviceToken description]);
    NSString *sr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    sr = [sr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [HJKeychain setKeychainValue:sr forType:HJ_KEYCHAIN_DEVICETOKEN];
}

@end
