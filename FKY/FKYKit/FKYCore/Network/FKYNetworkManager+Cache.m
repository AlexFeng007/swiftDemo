//
//  FKYNetworkManager+Cache.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNetworkManager+Cache.h"
#import <AFNetworking/AFURLRequestSerialization.h>
#import "FKYNetworkManager_private.h"

@implementation FKYNetworkManager (Cache)

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
decodeClass:(Class)decodeClass
  cacheType:(FKYCacheType)cacheType
   useCache:(BOOL)useCache
    success:(FKYNetworkSuccessBlock)success
    failure:(FKYNetworkFailureBlock)failure
{
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                  URLString:URLString
                                                 parameters:parameters
                                                      error:nil];
    
    NSString *cacheKey = request.URL.absoluteString;
    
    if (useCache) {
        [[FKYCacheManager sharedInstance] objectForKey:cacheKey
                                            cacheType:cacheType
                                          decodeClass:decodeClass
                                                block:^(FKYCacheType cacheType, FKYNetworkResponse *response)
         {
             if (response != nil) {
                 if (success) {
                     response.isCache = YES;
                     success(nil, response);
                 }
             }
             if (response == nil || cacheType == FKYCacheTypeOffline) {
                 [self cacheGET:URLString
                     parameters:parameters
                    decodeClass:decodeClass
                       cacheKey:cacheKey
                      cacheType:cacheType
                        success:success
                        failure:failure];
             }
         }];
    } else {
        [self cacheGET:URLString
            parameters:parameters
           decodeClass:decodeClass
              cacheKey:cacheKey
             cacheType:cacheType
               success:success
               failure:failure];
    }
}

- (void)cacheGET:(NSString *)URLString
      parameters:(NSDictionary *)parameters
     decodeClass:(Class)decodeClass
        cacheKey:(NSString *)cacheKey
       cacheType:(FKYCacheType)cacheType
         success:(FKYNetworkSuccessBlock)success
         failure:(FKYNetworkFailureBlock)failure
{
    [self GET:URLString
   parameters:parameters
  decodeClass:decodeClass
      success:^(NSURLRequest *request, FKYNetworkResponse *response) {
          
          if (success) {
              success(request, response);
          }
          
          if ([response.statusCode integerValue] == 1) { //1表示成功，非1表示失败请求
              [[FKYCacheManager sharedInstance] setObject:response.originalContent
                                                  forKey:cacheKey
                                           withCacheType:cacheType];
          }
      } failure:^(NSURLRequest *request, FKYNetworkResponse *response, NSError *error) {
          
          if (failure) {
              failure(request, response, error);
          }
      }];
}


- (void)removeCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    dispatch_async([FKYCacheManager sharedInstance].queue, ^{
        NSString *cacheKey = [self componentUrl:[self adapterUrl:url] parameters:parameters];
        [[FKYCacheManager sharedInstance].normalCache remove:cacheKey];
        [[FKYCacheManager sharedInstance].dailyCache remove:cacheKey];
        [[FKYCacheManager sharedInstance].offlineCache remove:cacheKey];
    });
}

- (BOOL)hasOfflineCacheWithURL:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self componentUrl:[self adapterUrl:url] parameters:parameters];
    BOOL result = [[FKYCacheManager sharedInstance].offlineCache fetch:cacheKey timestamp:NULL] != nil;
    return result;
}


- (void)removeAllCache:(void (^)(void))completion
{
    [[FKYCacheManager sharedInstance] removeAllCache:completion];
}


@end
