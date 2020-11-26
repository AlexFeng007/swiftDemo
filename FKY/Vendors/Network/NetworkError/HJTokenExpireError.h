//
//  HJTokenExpireError.h
//  HJFramework
//  功能:token过期错误处理
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJNetworkError.h"

@interface HJTokenExpireError : HJNetworkError

AS_SINGLETON(HJTokenExpireError)

/**
 *  功能:添加token过期rtn_code
 */
- (void)addTokenExpireRtnCode:(NSString *)aRtnCode;

@end
