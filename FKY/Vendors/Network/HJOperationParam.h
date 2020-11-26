//
//  HJOperationParam.h
//  HJFramework
//  功能:接口调用operation所需的参数
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kRequestPost = 0,                   //post方式
    kRequestGet                         //get方式
} ERequestType;

typedef NS_ENUM(NSInteger, EUpLoadFileType){
    kUpLoadData = 0,                    //data方式
    kUpLoadUrl                          //url方式
};

typedef NS_ENUM(NSInteger, EUpLoadFileMimeType){
    kPng = 0,                           //png方式
    kJpg                                //jpg方式
};

typedef void(^HJCompletionBlock)(id aResponseObject, NSError* anError);
typedef void(^HJCartNumBlock)(NSInteger num, NSError* anError);// 购物车数量


@interface HJOperationParam : NSObject

@property(nonatomic, assign) BOOL needSignature;                        //是否需要签名，默认为YES
@property(nonatomic, assign) BOOL needEncoderToken;                     //是否加密token，默认为YES
@property(nonatomic, assign) NSInteger retryTimes;                      //重试次数，默认为1
@property(nonatomic, assign) NSTimeInterval cacheTime;                  //缓存时间，默认为0秒
@property(nonatomic, assign) NSTimeInterval timeoutTime;                //超时时间，默认为30秒
@property(nonatomic, assign) BOOL alertError;                           //是否弹出错误提示，默认为NO
@property(nonatomic, assign) BOOL showErrorView;                        //是否显示错误界面，默认为NO
@property(nonatomic, copy) HJCompletionBlock callbackBlock;             //回调block

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithBusinessName:(NSString *)aBusinessName
                 methodName:(NSString *)aMethodName
                 versionNum:(NSString *)aVersionNum
                       type:(ERequestType)aType
                      param:(NSDictionary *)aParam
                   callback:(HJCompletionBlock)aCallback;

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithUrl:(NSString *)aUrl
              type:(ERequestType)aType
             param:(NSDictionary *)aParam
          callback:(HJCompletionBlock)aCallback;

/**
 *  功能:获取当前请求url
 */
+ (NSString *)getRequestUrl:(NSString *)aBusinessName
                 methodName:(NSString *)aMethodName
                 versionNum:(NSString *)aVersionNum;


#pragma mark - Optimize

/**
 *  功能:初始化方法<简化版>
 */
+ (instancetype)paramWithApiName:(NSString *)api
                            type:(ERequestType)type
                           param:(NSDictionary *)param
                        callback:(HJCompletionBlock)callback;

/**
 *  功能:获取当前请求url
 */
+ (NSString *)gerRequestUrl:(NSString *)api;

/**
 *  功能: BI埋点初始化方法<简化版>
 */
+ (instancetype)paramWithBiUrl:(NSString *)url
                          type:(ERequestType)type
                         param:(NSDictionary *)param
                      callback:(HJCompletionBlock)callback;

@end
