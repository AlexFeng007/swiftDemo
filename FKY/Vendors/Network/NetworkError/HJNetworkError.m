//
//  HJNetworkError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJNetworkError.h"
#import "HJNetworkManager.h"
#import "HJOperationManager.h"
#import "HJOperationParam.h"

@implementation HJNetworkError

/**
 *  功能:错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    return YES;
}

@end
