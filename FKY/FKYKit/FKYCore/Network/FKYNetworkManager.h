//
//  FKYNetworkManager.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYNetworkResponse.h"
#import "AFNetworking/AFHTTPSessionManager.h"

typedef void (^FKYNetworkSuccessBlock)(NSURLRequest *request, FKYNetworkResponse *response);
typedef void (^FKYNetworkFailureBlock)(NSURLRequest *request, FKYNetworkResponse *response, NSError *error);

// 定义网络状态
typedef NS_ENUM(NSInteger, FKYNetworkReachabilityStatus) {
    FKYNetworkReachabilityStatusUnknown,
    FKYNetworkReachabilityStatusNotReachable,
    FKYNetworkReachabilityStatusReachableViaWWAN,
    FKYNetworkReachabilityStatusReachableViaWiFi,
};

@interface FKYNetworkManager : NSObject

// 可子类化FKYNetworkResponse，实现自身的解析逻辑
@property (nonatomic) Class defaultResponseModel;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
// 通用的请求参数Dict
@property (nonatomic, copy) NSDictionary *commonParameters;

/**
 *  获取当前网络状态
 */
@property (readonly, nonatomic) FKYNetworkReachabilityStatus networkReachabilityStatus;

// 获取单例对象
+ (instancetype)sharedInstance __attribute__((deprecated));

/**
 *  更新NSURLSessionConfiguration
 *
 *  @param configuration
 */
- (void)updateURLSessionConfiguration:(NSURLSessionConfiguration *)configuration __attribute__((deprecated));

// 获取默认FKYNetworkManager, 采用默认Configuration
+ (instancetype)defaultManager;

// 构造方法，可指定BaseURL
- (instancetype)initWithBaseURL:(NSURL *)url;

// 构造方法，可指定BaseURL和configuration
- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 *  GET
 *
 *  @param URLString   URL
 *  @param parameters  参数Dict
 *  @param decodeClass 解码Class
 *  @param success     success
 *  @param failure     failure
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                  decodeClass:(Class)decodeClass
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYNetworkFailureBlock)failure;

/**
 *  POST
 *
 *  @param URLString   URL
 *  @param parameters  参数Dict
 *  @param decodeClass 解码Class
 *  @param success     success
 *  @param failure     failure
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                   decodeClass:(Class)decodeClass
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYNetworkFailureBlock)failure;

/**
 *  PUT
 *
 *  @param URLString   URL
 *  @param parameters  参数Dict
 *  @param decodeClass 解码Class
 *  @param success     success
 *  @param failure     failure
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYNetworkFailureBlock)failure;

/**
 *  DELETE
 *
 *  @param URLString   URL
 *  @param parameters  参数Dict
 *  @param decodeClass 解码Class
 *  @param success     success
 *  @param failure     failure
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(FKYNetworkSuccessBlock)success
                         failure:(FKYNetworkFailureBlock)failure;

/**
 *  自定义Request
 *
 *  @param request     NSURLRequest
 *  @param decodeClass 解码Class
 *  @param success     success
 *  @param failure     failure
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                      decodeClass:(Class)decodeClass
                          success:(FKYNetworkSuccessBlock)success
                          failure:(FKYNetworkFailureBlock)failure;

/**
 *  取消指定taskIdentifier的Task
 *
 *  @param taskIdentifier
 */
- (void)cancelTaskWithIdentifier:(NSUInteger)taskIdentifier;

/**
 *  取消所有Task
 */
- (void)cancelAllTasks;

/**
 *  取消指定请求的task
 *
 *  @param method RESTFull Method
 *  @param path   请求url
 */
- (void)cancelHTTPTaskWithMethod:(NSString *)method path:(NSString *)path;


extern NSString * const FKYNetworkingReachabilityDidChangeNotification; // 监控网络状态的通知名称
extern NSString * const FKYNetworkingReachabilityNotificationStatusItem; // 通知中网络状态的key

/**
 *  监测网络状态更改
 *
 *  @param block block
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(FKYNetworkReachabilityStatus status))block;

@end
