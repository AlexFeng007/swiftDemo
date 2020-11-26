//
//  HJNetworkError.h
//  HJFramework
//  功能:网络错误处理
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJOperationManager;
@class HJOperationParam;

typedef void(^HJErrorHandleCompleteBlock)(BOOL success);
typedef void(^HJErrorHandleBlock)(HJErrorHandleCompleteBlock errorHandleCompleteBlock);

typedef enum {
    kLaunchFail = 1,                    //启动接口调用失败
    kTokenExpire,                       //token过期
    kLoginFailWhenTokenExpire,          //token过期后自动登录失败
    kGetSignKeyFailWhenSignKeyExpire,   //密钥过期后重新获取密钥失败
    kReturnCodeNotEqualToZero,          //rtn_code不为0
	kDataTypeMismatch,                  // 数据类型不匹配
    kNotConnectToServer = -1004,        //网络连接错误
    kServerError = -1011,               //服务器错误
} ENetworkError;

UIKIT_EXTERN NSString *const HJInterfaceReturnErrorDomain;

@interface HJNetworkError : NSObject

@property(nonatomic, copy) HJErrorHandleBlock errorHandleBlock;//错误处理block
@property(nonatomic, assign) BOOL handling;//是否正在错误处理

/**
 *  功能:错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError;

@end
