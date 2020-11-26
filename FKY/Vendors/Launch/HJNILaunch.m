//
//  HJNILaunch.m
//  IHome4Phone
//
//  Created by bibibi on 15/7/23.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJNILaunch.h"

@implementation HJNILaunch

/**
 *  功能:客户端发现密钥与服务器不匹配时调用，中途密钥失效的时候，重新单独获取密钥用的
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getMySecretKey:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *param = [HJOperationParam paramWithBusinessName:@"mobile" methodName:@"getkey" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    param.needSignature = NO;
    
    return param;
}

@end
