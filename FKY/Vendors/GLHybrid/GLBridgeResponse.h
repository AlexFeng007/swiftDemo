//
//  GLBridgeResponse.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GLBridgeRespCode) {
    GLBridgeRespCode_OK = 0,          /* <成功 */
    GLBridgeRespCode_WRONG_PARAM = 1, /* <参数错误 */
    GLBridgeRespCode_UNLOGIN = 2      /* <未登录 */
};

@interface GLBridgeResponse : NSObject

@property (nonatomic, strong, readonly) NSNumber *errcode; /* <返回给js的错误码 */
@property (nonatomic, strong, readonly) NSString *errmsg;  /* <返回给js的错误提示 */
@property (nonatomic, strong, readonly) id data;           /* <返回给js的业务内容 */

/**
 初始化
 
 @param errcode 错误码
 @param errmsg 错误信息
 @param data 业务内容
 @return 实例
 */
- (instancetype)init;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode data:(id)data;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg data:(id)data;

/**
 将返回js端信息转化为JSON

 @param callbackId js端回调id
 @return 转化为JSON的callback方法参数
 */
- (NSString *)callBackParamAsJSONWithId:(NSString *)callbackId;

@end
