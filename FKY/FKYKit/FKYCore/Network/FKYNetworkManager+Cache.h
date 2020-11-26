//
//  FKYNetworkManager+Cache.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNetworkManager.h"
#import "FKYCacheManager.h"

@interface FKYNetworkManager (Cache)

/**
 *  支持缓存的GET请求
 *
 *  @param URLString   URL
 *  @param parameters  参数Dict
 *  @param decodeClass 数据解码Class
 *  @param cacheType   缓存类型 @FKYCacheType
 *  @param useCache    是否使用缓存，例如离线方式的请求中，下拉刷新时仅保存缓存数据，但不取缓存数据
 *  @param success     成功block
 *  @param failure     失败block
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
decodeClass:(Class)decodeClass
  cacheType:(FKYCacheType)cacheType
   useCache:(BOOL)useCache
    success:(FKYNetworkSuccessBlock)success
    failure:(FKYNetworkFailureBlock)failure;


/**
 *  清除指定请求的缓存
 *
 *  @param url        url
 *  @param parameters 参数
 */
- (void)removeCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  是否包含离线缓存数据
 *
 *  @param url        URL
 *  @param parameters 参数字典
 *
 *  @return YES or NO
 */
- (BOOL)hasOfflineCacheWithURL:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  清除所有缓存
 */
- (void)removeAllCache:(void (^)(void))completion;

@end
