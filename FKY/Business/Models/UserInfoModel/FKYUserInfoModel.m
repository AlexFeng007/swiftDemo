//
//  FKYUserInfoModel.m
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYUserInfoModel.h"

@implementation FKYUserInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"customer"]) {
        [self setValue:value[@"province"] forKey:@"province"];
    }
    if ([key isEqualToString:@"user"]) {
        [self setValue:value[@"custId"] forKey:@"custId"];
        [self setValue:value[@"lastLoginDate"] forKey:@"lastLoginDate"];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:NSStringFromSelector(@selector(userId))];
    [aCoder encodeObject:self.ycenterpriseId forKey:NSStringFromSelector(@selector(ycenterpriseId))];
    [aCoder encodeObject:self.loginName forKey:NSStringFromSelector(@selector(loginName))];
    [aCoder encodeObject:self.sessionId forKey:NSStringFromSelector(@selector(sessionId))];
    [aCoder encodeObject:self.curUserType forKey:NSStringFromSelector(@selector(curUserType))];
    [aCoder encodeObject:self.custId forKey:NSStringFromSelector(@selector(custId))];
    [aCoder encodeObject:self.serviceType forKey:NSStringFromSelector(@selector(serviceType))];
    [aCoder encodeObject:self.substationCode forKey:NSStringFromSelector(@selector(substationCode))];
    [aCoder encodeObject:self.substationName forKey:NSStringFromSelector(@selector(substationName))];
    
    [aCoder encodeObject:self.lastLoginDate forKey:NSStringFromSelector(@selector(lastLoginDate))];
    [aCoder encodeObject:self.custName forKey:NSStringFromSelector(@selector(custName))];
    [aCoder encodeObject:self.custAddr forKey:NSStringFromSelector(@selector(custAddr))];
    [aCoder encodeObject:self.fileUrl forKey:NSStringFromSelector(@selector(fileUrl))];
    [aCoder encodeObject:self.password forKey:NSStringFromSelector(@selector(password))];
    [aCoder encodeObject:self.gltoken forKey:NSStringFromSelector(@selector(gltoken))];
    [aCoder encodeObject:self.userName forKey:NSStringFromSelector(@selector(userName))];
    [aCoder encodeObject:self.avatarUrl forKey:NSStringFromSelector(@selector(avatarUrl))];
    [aCoder encodeObject:self.token forKey:NSStringFromSelector(@selector(token))];
    [aCoder encodeObject:self.userType forKey:NSStringFromSelector(@selector(userType))];
    [aCoder encodeObject:self.enterpriseName forKey:NSStringFromSelector(@selector(enterpriseName))];
    
    [aCoder encodeObject:self.nameList forKey:NSStringFromSelector(@selector(nameList))];
    [aCoder encodeObject:self.ycuserinfo forKey:NSStringFromSelector(@selector(ycuserinfo))];
    [aCoder encodeObject:self.city_id forKey:NSStringFromSelector(@selector(city_id))];
    [aCoder encodeObject:self.roleId forKey:NSStringFromSelector(@selector(roleId))];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userId))];
        _ycenterpriseId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ycenterpriseId))];
        _loginName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(loginName))];
        _sessionId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(sessionId))];
        _curUserType = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(curUserType))];
        _custId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(custId))];
        _serviceType = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(serviceType))];
        _substationCode = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(substationCode))];
        _substationName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(substationName))];
        _lastLoginDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lastLoginDate))];
        _custAddr = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(custAddr))];
        _custName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(custName))];
        _fileUrl = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileUrl))];
        _password = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(password))];
        _gltoken = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gltoken))];
        _userName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userName))];
        _avatarUrl = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(avatarUrl))];
        _token = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(token))];
        _userType = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userType))];
        _enterpriseName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(enterpriseName))];
        
        _nameList = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(nameList))];
        _ycuserinfo = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ycuserinfo))];
        _city_id = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(city_id))];
        _roleId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(roleId))];
    }
    return  self;
}

@end
