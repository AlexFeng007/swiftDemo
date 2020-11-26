//
//  FKYCartAddressModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartAddressModel.h"

@implementation FKYCartAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"adId" : @"id" };
}

- (NSString *)wholeAddress
{
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.provinceName, self.cityName, self.districtName, self.avenu_name, self.address];
    return address;
}

- (BOOL)isLegal
{
    if ((nil == self.provinceName) || (self.provinceName.length <= 0)) {
        return NO;
    }
    if ((nil == self.cityName) || (self.cityName.length <= 0)) {
        return NO;
    }
    if ((nil == self.districtName) || (self.districtName.length <= 0)) {
        return NO;
    }
    if ((nil == self.address) || (self.address.length <= 0)) {
        return NO;
    }
    if ((nil == self.receiverName) || (self.receiverName.length <= 0)) {
        return NO;
    }
    if ((nil == self.contactPhone) || (self.contactPhone.length <= 0)) {
        return NO;
    }
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.adId) forKey:NSStringFromSelector(@selector(adId))];
    [aCoder encodeObject:self.enterpriseId forKey:NSStringFromSelector(@selector(enterpriseId))];
    [aCoder encodeObject:self.receiverName forKey:NSStringFromSelector(@selector(receiverName))];
    [aCoder encodeObject:self.provinceCode forKey:NSStringFromSelector(@selector(provinceCode))];
    [aCoder encodeObject:self.cityCode forKey:NSStringFromSelector(@selector(cityCode))];
    [aCoder encodeObject:self.districtCode forKey:NSStringFromSelector(@selector(districtCode))];
    [aCoder encodeObject:self.avenu_code forKey:NSStringFromSelector(@selector(avenu_code))];
    [aCoder encodeObject:self.provinceName forKey:NSStringFromSelector(@selector(provinceName))];
    [aCoder encodeObject:self.cityName forKey:NSStringFromSelector(@selector(cityName))];
    [aCoder encodeObject:self.districtName forKey:NSStringFromSelector(@selector(districtName))];
    [aCoder encodeObject:self.avenu_name forKey:NSStringFromSelector(@selector(avenu_name))];
    [aCoder encodeObject:self.address forKey:NSStringFromSelector(@selector(address))];
    [aCoder encodeObject:self.print_address forKey:NSStringFromSelector(@selector(print_address))];
    [aCoder encodeObject:self.contactPhone forKey:NSStringFromSelector(@selector(contactPhone))];
    [aCoder encodeObject:@(self.defaultAddress) forKey:NSStringFromSelector(@selector(defaultAddress))];
    [aCoder encodeObject:self.purchaser forKey:NSStringFromSelector(@selector(purchaser))];
    [aCoder encodeObject:self.purchaser_phone forKey:NSStringFromSelector(@selector(purchaser_phone))];
    [aCoder encodeObject:@(self.isSelected) forKey:NSStringFromSelector(@selector(isSelected))];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _adId = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(adId))] integerValue];
        _enterpriseId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(enterpriseId))];
        _receiverName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(receiverName))];
        _provinceCode = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(provinceCode))];
        _cityCode = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(cityCode))];
        _districtCode = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(districtCode))];
        _avenu_code = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(avenu_code))];
        _provinceName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(provinceName))];
        _cityName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(cityName))];
        _districtName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(districtName))];
        _avenu_name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(avenu_name))];
        _address = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(address))];
        _print_address = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(print_address))];
        _contactPhone = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(contactPhone))];
        _defaultAddress = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(defaultAddress))] integerValue];
        _purchaser = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(purchaser))];
        _purchaser_phone = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(purchaser_phone))];
        _isSelected = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(isSelected))] boolValue];
    }
    return  self;
}

@end
