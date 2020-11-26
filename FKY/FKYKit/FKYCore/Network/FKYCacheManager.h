//
//  FKYCacheManager.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYNetworkResponse.h"
#import "FKYByteCache.h"

// 缓存类型
typedef NS_ENUM(NSInteger, FKYCacheType) {
    FKYCacheTypeNormal,        // 普通缓存，时间为5分钟
    FKYCacheTypeDaily,        // 每日缓存，零点过期
    FKYCacheTypeOffline       // 离线方式
};

typedef void (^FKYCacheManagerBlock)(FKYCacheType cacheType, FKYNetworkResponse *response);
typedef void (^FKYCacheManagerForCommonObjectBlock)(FKYCacheType cacheType, id response);

@interface FKYCacheManager : NSObject

@property (nonatomic, strong, readonly) FKYByteCache *normalCache;
@property (nonatomic, strong, readonly) FKYByteCache *dailyCache;
@property (nonatomic, strong, readonly) FKYByteCache *offlineCache;
@property (nonatomic, strong, readonly) dispatch_queue_t queue;
@property (nonatomic) Class defaultResponseModel;

+ (FKYCacheManager *)sharedInstance;

/**
 *  缓存设置方法
 *
 *  @param object    缓存值
 *  @param cacheKey  缓存名称
 *  @param cacheType 缓存类型
 */
- (void)setObject:(id <NSCoding>)object
           forKey:(NSString *)cacheKey
    withCacheType:(FKYCacheType)cacheType;

/**
 *  缓存获取方法
 *
 *  @param cacheKey  缓存名称
 *  @param cacheType 缓存类型
 *  @param block     缓存处理Block
 */
- (void)objectForKey:(NSString *)cacheKey
           cacheType:(FKYCacheType)cacheType
         decodeClass:(Class)decodeClass
               block:(FKYCacheManagerBlock)block;

- (void)comminObjectForKey:(NSString *)cacheKey
                 cacheType:(FKYCacheType)cacheType
               decodeClass:(Class)decodeClass
                     block:(FKYCacheManagerForCommonObjectBlock)block;

/**
 *  清除所有缓存
 *
 *  @param completion 清除完成的回调
 */
- (void)removeAllCache:(void (^)(void))completion;

/**
 *  清除指定cacheKey的缓存
 *
 *  @param cacheKey 缓存key
 */
- (void)removeCacheWithKey:(NSString *)cacheKey;

/**
 *  离线缓存大小
 *
 */
- (unsigned long long)offlineCacheSize;

/**
 *  总的缓存大小
 *
 */
- (unsigned long long)allCacheSize;

/**
 *  设置最大的缓存大小
 *
 *  @param size 缓存大小，单位：M
 */
- (void)setMaxCacheSize:(float)size;

@end
