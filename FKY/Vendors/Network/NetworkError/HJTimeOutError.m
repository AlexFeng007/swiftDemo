//
//  HJTimeOutError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJTimeOutError.h"

@interface HJTimeOutError()

@property(nonatomic, strong) NSMutableArray *timeOutRtnCodes;

@end

@implementation HJTimeOutError

DEF_SINGLETON(HJTimeOutError)

#pragma mark - Property
- (NSMutableArray *)timeOutRtnCodes
{
    if (_timeOutRtnCodes == nil) {
        _timeOutRtnCodes = [NSMutableArray array];
    }
    
    return _timeOutRtnCodes;
}

#pragma mark - API
/**
 *  功能:添加接口超时rtn_code
 */
- (void)addTimeOutRtnCode:(NSString *)aRtnCode
{
    [self.timeOutRtnCodes addObject:aRtnCode];
}

/**
 *  功能:判断某个rtn_code是否是超时rtn_code
 */
- (BOOL)timeOutForRtnCode:(NSString *)aRtnCode
{
    if (aRtnCode == nil) {
        return NO;
    }
    
    return [self.timeOutRtnCodes containsObject:aRtnCode];
}



@end
