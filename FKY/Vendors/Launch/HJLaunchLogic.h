//
//  PhoneLaunchLogic.h
//  IHome4Phone
//
//  Created by bibibi on 15/7/23.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJLogic.h"

@interface HJLaunchLogic : HJLogic


/**
 *  客户端发现密钥与服务器不匹配时调用,中途密钥失效的时候 ,重新单独获取密钥用的
 *
 *  @param aCompletionBlock
 */
- (void)getMySecretKey:(HJCompletionBlock)aCompletionBlock;

@end
