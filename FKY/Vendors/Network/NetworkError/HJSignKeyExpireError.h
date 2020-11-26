//
//  HJSignKeyExpireError.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJNetworkError.h"

@interface HJSignKeyExpireError : HJNetworkError

AS_SINGLETON(HJSignKeyExpireError)

/**
 *  功能:添加密钥过期rtn_code
 */
- (void)addSignKeyExpireRtnCode:(NSString *)aRtnCode;

@end
