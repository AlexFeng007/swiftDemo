//
//  FKYBaseService.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "FKYNetworkManager.h"

typedef void(^FKYSuccessBlock)(BOOL mutiplyPage);
typedef void(^FKYFailureBlock)(NSString *reason);

// 一起购新增
typedef void(^FKYGroupBuySuccessBlock)(BOOL mutiplyPage, NSString *reason);

// 限购新增...<除了需要返回数据最外层的message字段外，还需要取接口操作失败后data里面的相关字段>
typedef void(^FKYRequestSuccessBlock)(BOOL mutiplyPage, id data);
typedef void(^FKYRequestFailureBlock)(NSString *reason, id data);

typedef void(^FKYUserErpSuccessBlock)(id data);


@interface FKYBaseService : NSObject

#pragma mark - 配置相关

- (NSString *)mainAPI;

- (NSString *)host:(NSString *)host appdengingAPI:(NSString *)apiUrl;

- (NSString *)manageAPI;
- (NSString *)mallAPI;
- (NSString *)passportAPI;
- (NSString *)payAPI;
- (NSString *)druggmpAPI;
- (NSString *)imageAPI;
- (NSString *)imageCodeAPI;
- (NSString *)messageCodeAPI;
- (NSString *)orderAPI;
- (NSString *)MAPI;
- (NSString *)usermanageReleaseAPI;
- (NSString *)logisticsReleaseAPI;

- (NSString *)requestUrl:(NSString *)url;
- (NSString *)requestUserUrl:(NSString *)url;
- (NSString *)requestLogisticsUrl:(NSString *)url;
- (NSString *)requestPayUrl:(NSString *)url;


#pragma mark - 网路相关

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYFailureBlock)failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYFailureBlock)failure;

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYFailureBlock)failure;

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(FKYNetworkSuccessBlock)success
                         failure:(FKYFailureBlock)failure;

// New
- (NSURLSessionDataTask *)PostRequst:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                             success:(FKYNetworkSuccessBlock)success
                             failure:(FKYRequestFailureBlock)failure;


#pragma mark - 

/**
 *  与原本的post请求的区别是：这个post会将body参数转化为json放入http body中
 *
 *  @param URLString
 *  @param body
 *  @param success
 *  @param failure
 *
 *  @return
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          body:(id)body
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYFailureBlock)failure;

// New
- (NSURLSessionDataTask *)PostMethod:(NSString *)URLString
                                body:(id)body
                             success:(FKYNetworkSuccessBlock)success
                             failure:(FKYRequestFailureBlock)failure;

// New...<固定套餐开发时新增>
- (NSURLSessionDataTask *)PostNew:(NSString *)URLString
                      requestBody:(id)body
                          success:(FKYNetworkSuccessBlock)success
                          failure:(FKYRequestFailureBlock)failure;

@end
