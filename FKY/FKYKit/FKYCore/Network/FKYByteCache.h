//
//  FKYByteCache.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYByteCache : NSObject

- (id)initWithFile:(NSString *)path name:(NSString *)tableName;

- (NSData *)fetch:(NSString *)url timestamp:(time_t *)time;

- (BOOL)push:(NSData *)data forKey:(NSString *)url;

- (BOOL)push:(NSData *)data timestamp:(time_t)time forKey:(NSString *)url;

- (BOOL)remove:(NSString *)url;

- (BOOL)trimToTimestamp:(time_t)time;

@end
