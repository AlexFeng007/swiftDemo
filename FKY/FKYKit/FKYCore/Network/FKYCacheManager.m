//
//  FKYCacheManager.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYCacheManager.h"

@interface FKYCacheManager ()

@property (nonatomic, strong) FKYByteCache *normalCache;
@property (nonatomic, strong) FKYByteCache *dailyCache;
@property (nonatomic, strong) FKYByteCache *offlineCache;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) float maxCacheSize;

@end

@implementation FKYCacheManager

+ (FKYCacheManager *)sharedInstance {
    static FKYCacheManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultResponseModel = [FKYNetworkResponse class];
        self.maxCacheSize = 200;
    }
    return self;
}

- (FKYByteCache *)normalCache {
    if(!_normalCache) {
        NSString *cachePath = [self normalCachePath];
        _normalCache = [[FKYByteCache alloc] initWithFile:cachePath name:@"NORMAL"];
    }
    return _normalCache;
}

- (FKYByteCache *)dailyCache {
    if(!_normalCache) {
        NSString *cachePath = [self dailyCachePath];
        _normalCache = [[FKYByteCache alloc] initWithFile:cachePath name:@"DAILY"];
    }
    return _normalCache;
}

- (FKYByteCache *)offlineCache {
    if(!_offlineCache) {
        NSString *cachePath = [self offlineCachePath];
        _offlineCache = [[FKYByteCache alloc] initWithFile:cachePath name:@"OFFLINE"];
    }
    return _offlineCache;
}

- (NSString *)normalCachePath
{
    return [self cachePathWithComponentName:@"normalCache.db"];
}

- (NSString *)dailyCachePath
{
    return [self cachePathWithComponentName:@"dailyCache.db"];
}

- (NSString *)offlineCachePath
{
    return [self cachePathWithComponentName:@"offlineCache.db"];
}


- (NSString *)cachePathWithComponentName:(NSString *)name {
    NSString *path = [self defaultDirectory];
    path = [path stringByAppendingPathComponent:name];
    return path;
}

- (NSString *)defaultDirectory {
    
    static NSString *resouceDirectory;
    if (!resouceDirectory) {
        NSString *cacheDircetory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        resouceDirectory = [cacheDircetory stringByAppendingPathComponent:@"com.111.coreCache"];
        NSFileManager * fm = [NSFileManager defaultManager];
        BOOL isDir = YES;
        if (![fm fileExistsAtPath:resouceDirectory isDirectory:&isDir]) {
            [fm createDirectoryAtPath:resouceDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return resouceDirectory;
}

- (dispatch_queue_t)queue
{
    if (!_queue) {
        _queue = dispatch_queue_create("cache.serialqueue", NULL);
    }
    return _queue;
}

- (void)didEnterBackground:(NSNotification *)n {
    // 普通缓存
    if(self.normalCache) {
        [self.normalCache trimToTimestamp:time(0) - 300];
    }
    
    // 每日缓存
    if (self.dailyCache) {
        time_t today = time(0);
        time_t invalidTime = (int)today - (int)today % (24 * 3600);
        [self.dailyCache trimToTimestamp:invalidTime];
    }
    
    // 离线缓存的逻辑处理
    if (self.offlineCache) {
        NSTimeInterval oneDay = 60 * 60 * 24;
        NSTimeInterval oneMonth = oneDay * 30;
        
        [self.offlineCache trimToTimestamp:time(0) - oneMonth];
        
        if ([self offlineCacheSize] > 1024 * 1024 * self.maxCacheSize) {
            [self.offlineCache trimToTimestamp:time(0) - oneDay * 7];
        }
    }
}

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)cacheKey withCacheType:(FKYCacheType)cacheType
{
    dispatch_async(self.queue, ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        
        switch (cacheType) {
            case FKYCacheTypeNormal:
            {
                [self.normalCache push:data forKey:cacheKey];
            }
                break;
            case FKYCacheTypeDaily:
            {
                [self.dailyCache push:data forKey:cacheKey];
            }
                break;
            case FKYCacheTypeOffline:
            {
                [self.offlineCache push:data forKey:cacheKey];
            }
                break;
            default:
                break;
        }
    });
}

- (void)objectForKey:(NSString *)cacheKey cacheType:(FKYCacheType)cacheType decodeClass:(Class)decodeClass block:(FKYCacheManagerBlock)block
{
    dispatch_async(self.queue, ^{
        NSData *data = nil;
        time_t timeStamp = 0;
        switch (cacheType) {
            case FKYCacheTypeNormal:
            {
                data = [self.normalCache fetch:cacheKey timestamp:&timeStamp];
                if (data) {
                    time_t dtime = time(0) - timeStamp;
                    if (dtime < 0 || dtime > 5 * 60) {
                        data = nil;
                    }
                }
            }
                break;
            case FKYCacheTypeDaily:
            {
                data = [self.dailyCache fetch:cacheKey timestamp:&timeStamp];
                if (data) {
                    time_t today = time(0);
                    today = (int)today - (int)today % (24 * 3600); //去除当天的秒数
                    if (timeStamp < today) { // 零点过期
                        data = nil;
                    }
                }
            }
                break;
            case FKYCacheTypeOffline:
            {
                data = [self.offlineCache fetch:cacheKey timestamp:&timeStamp];
            }
                break;
            default:
                break;
        }
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data == nil) {
                    block(cacheType, nil);
                    return;
                }
                
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                if (object == nil) {
                    block(cacheType, nil);
                    return;
                }
                
                if (object) {
                    FKYNetworkResponse *response = [[self.defaultResponseModel alloc] initWithContent:object response:nil modelClass:decodeClass];
                    block(cacheType, response);
                }
            });
            
        }
    });
}

- (void)comminObjectForKey:(NSString *)cacheKey cacheType:(FKYCacheType)cacheType decodeClass:(Class)decodeClass block:(FKYCacheManagerForCommonObjectBlock)block
{
    dispatch_async(self.queue, ^{
        NSData *data = nil;
        time_t timeStamp = 0;
        switch (cacheType) {
            case FKYCacheTypeNormal:
            {
                data = [self.normalCache fetch:cacheKey timestamp:&timeStamp];
                if (data) {
                    time_t dtime = time(0) - timeStamp;
                    if (dtime < 0 || dtime > 5 * 60) {
                        data = nil;
                    }
                }
            }
                break;
            case FKYCacheTypeDaily:
            {
                data = [self.dailyCache fetch:cacheKey timestamp:&timeStamp];
                if (data) {
                    time_t today = time(0);
                    today = (int)today - (int)today % (24 * 3600); //去除当天的秒数
                    if (timeStamp < today) { // 零点过期
                        data = nil;
                    }
                }
            }
                break;
            case FKYCacheTypeOffline:
            {
                data = [self.offlineCache fetch:cacheKey timestamp:&timeStamp];
            }
                break;
            default:
                break;
        }
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data == nil) {
                    block(cacheType, nil);
                    return;
                }
                
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                if (object == nil) {
                    block(cacheType, nil);
                    return;
                }
                
                if (object) {
                    block(cacheType, object);
                }
            });
            
        }
    });
}

- (void)removeAllCache:(void (^)(void))completion
{
    dispatch_async([FKYCacheManager sharedInstance].queue, ^{
        [self.normalCache trimToTimestamp:time(0)];
        [self.dailyCache trimToTimestamp:time(0)];
        [self.offlineCache trimToTimestamp:time(0)];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self normalCachePath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self normalCachePath] error:nil];
            self.normalCache = nil;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self dailyCachePath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self dailyCachePath] error:nil];
            self.dailyCache = nil;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self offlineCachePath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self offlineCachePath] error:nil];
            self.offlineCache = nil;
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)removeCacheWithKey:(NSString *)cacheKey
{
    dispatch_async([FKYCacheManager sharedInstance].queue, ^{
        [self.normalCache remove:cacheKey];
        [self.dailyCache remove:cacheKey];
        [self.offlineCache remove:cacheKey];
    });
}

- (unsigned long long)offlineCacheSize
{
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self offlineCachePath] error:nil];
    return [attrs fileSize];
}

- (unsigned long long)allCacheSize
{
    NSDictionary *normalCacheAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self normalCachePath] error:nil];
    NSDictionary *dailyCacheAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self dailyCachePath] error:nil];
    return [normalCacheAttrs fileSize] + [dailyCacheAttrs fileSize] + [self offlineCacheSize];
}


@end
