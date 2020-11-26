//
//  FKYLocationModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYLocationModel.h"

@implementation FKYLocationModel

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    
    [coder encodeObject:self.substationCode forKey:NSStringFromSelector(@selector(substationCode))];
    [coder encodeObject:self.substationName forKey:NSStringFromSelector(@selector(substationName))];
    [coder encodeObject:self.showIndex forKey:NSStringFromSelector(@selector(showIndex))];
    [coder encodeObject:self.showIndex forKey:NSStringFromSelector(@selector(isCommon))];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _substationCode = [coder decodeObjectForKey:NSStringFromSelector(@selector(substationCode))];
        _substationName = [coder decodeObjectForKey:NSStringFromSelector(@selector(substationName))];
        _showIndex = [coder decodeObjectForKey:NSStringFromSelector(@selector(showIndex))];
        _isCommon = [coder decodeObjectForKey:NSStringFromSelector(@selector(isCommon))];
}
    return self;
}

+ (instancetype)defaultModel
{
    FKYLocationModel *model = [FKYLocationModel new];
    model.substationName = @"默认";
    model.substationCode = @"000000";
    model.showIndex = @(0);
    model.isCommon = @(0);  // 默认通用城市
    return model;
}

- (NSString *)substationCode
{
    if (!_substationCode) {
        return @"000000";
    }
    
    if ([_substationCode isKindOfClass:NSNumber.class]) {
        NSNumber *number = (NSNumber *)_substationCode;
        return number.stringValue;
    }
    else if ([_substationCode isKindOfClass:NSString.class]) {
        return _substationCode;
    }
    else {
        return @"000000";
    }
}

@end
