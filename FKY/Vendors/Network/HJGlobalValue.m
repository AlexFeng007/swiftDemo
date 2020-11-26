//
//  HJGlobalValue.m
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import "HJGlobalValue.h"
#import "HJClientInfo.h"
#import "HJUserDefault.h"
#import "HJKeychain.h"

NSString *const KeyChainSignatureKey = @"keychain.signatureKey";
NSString *const TokenKey = @"TokenKey";

@interface HJGlobalValue  ()

@property (nonatomic, retain) NSDate* lastSessionDate;
@property (nonatomic, copy) NSString *signatureKey;                  //解密后的签名密钥
@property (nonatomic, copy) NSString *clientInfoString;              //clientinfo字符串

@end


@implementation HJGlobalValue

DEF_SINGLETON(HJGlobalValue)

@synthesize signatureKey = _signatureKey, token = _token;
@synthesize provinceId = _provinceId, provinceName = _provinceName, cityName = _cityName, countyName = _countyName;

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)token
{
    if (_token == nil) {
        _token = [HJUserDefault getValueForKey:TokenKey];
    }
    return _token;
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [HJUserDefault setValue:token forKey:TokenKey];
}

- (NSString *)signatureKey
{
    if (_signatureKey == nil) {
        _signatureKey = [HJKeychain getKeychainValueForType:KeyChainSignatureKey];
    }
    return _signatureKey;
}

- (void)setSignatureKey:(NSString *)signatureKey
{
    _signatureKey = [signatureKey copy];
    [HJKeychain setKeychainValue:signatureKey forType:KeyChainSignatureKey];
}

- (NSNumber *)provinceId
{
    if (_provinceId == nil) {
//        NSString *lastSavedProvinceId = user_defaults_get_string(kAppProvinceIdentifier);
//        if (!lastSavedProvinceId.length) { // 用户首次使用app
//            _provinceId = @(1);
//        }
//        else {
//            _provinceId = @(lastSavedProvinceId.integerValue);
//        }
        _provinceId = @(1);
    }
    return _provinceId;
}

- (void)setProvinceId:(NSNumber *)aProvinceId
{
    if (aProvinceId && ![aProvinceId isKindOfClass:[NSNumber class]]) {
        return;
    }
    
    _provinceId = [aProvinceId copy];
}

- (NSString *)provinceName
{
    if (_provinceName == nil) {
//        NSString *lastSavedProvinceId = user_defaults_get_string(kAppProvinceIdentifier);
//        if (!lastSavedProvinceId.length) { // 用户首次使用app
//            _provinceName = @"上海";
//        }
//        else {
//            _provinceName = [YWDBManager getProvinceName:lastSavedProvinceId];
//        }
        _provinceName = @"上海";
    }
    return _provinceName;
}

- (void)setProvinceName:(NSString *)aprovinceName
{
    _provinceName = [aprovinceName copy];
}

- (NSString *)cityName
{
    if (!_cityName) {
        _cityName = @"上海市";
    }
    return _cityName;
}

- (void)setCityName:(NSString *)aCityName
{
    _cityName = [aCityName copy];
}

- (NSString *)countyName
{
    if (!_countyName) {
        _countyName = @"浦东新区";
    }
    return _countyName;
}

- (void)setCountyName:(NSString *)countyName
{
    _countyName = [countyName copy];
}

- (NSString *)clientInfoString
{
    _clientInfoString = [[HJClientInfo sharedInstance] yy_modelToJSONString];
    return (_clientInfoString ? _clientInfoString : @"");
}

@end
