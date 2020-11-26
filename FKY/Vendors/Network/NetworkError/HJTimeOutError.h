//
//  HJTimeOutError.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJNetworkError.h"

@interface HJTimeOutError : HJNetworkError

AS_SINGLETON(HJTimeOutError)

/**
 *  功能:添加接口超时rtn_code
 */
- (void)addTimeOutRtnCode:(NSString *)aRtnCode;

/**
 *  功能:判断某个rtn_code是否是超时rtn_code
 */
- (BOOL)timeOutForRtnCode:(NSString *)aRtnCode;

@end
