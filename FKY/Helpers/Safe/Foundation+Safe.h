//
//  Foundation+Safe.h
//  YYW
//
//  Created by HUI on 2018/5/30.
//  Copyright © 2018年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (Safe)

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index;

+ (instancetype)safeArrayWithObject:(ObjectType)object;

- (nullable NSArray<ObjectType> *)safeSubarrayWithRange:(NSRange)range;

@end

@interface NSMutableArray<ObjectType> (Safe)

- (void)safeAddObject:(ObjectType)object;

- (void)safeInsertObject:(ObjectType)object atIndex:(NSUInteger)index;

- (void)safeInsertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexs;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)safeRemoveObjectsInRange:(NSRange)range;

- (nullable ObjectType)safeObjectAtIndexedSubscript:(NSUInteger)index;

@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (Safe)

+ (instancetype)safeDictionaryWithObject:(ObjectType)object forKey:(KeyType)key;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (safe)

- (void)safeSetObject:(nullable ObjectType)aObj forKey:(KeyType)aKey;

@end

@interface NSString (Safe)

- (nullable NSString *)safeSubstringFromIndex:(NSUInteger)from;

- (nullable NSString *)safeSubstringToIndex:(NSUInteger)to;

- (nullable NSString *)safeSubstringWithRange:(NSRange)range;

- (NSString *)safeStringByAppendingString:(NSString *)aString;

- (instancetype)safeInitWithString:(NSString *)aString;

+ (instancetype)safeStringWithString:(NSString *)string;

@end

@interface NSMutableString (Safe)

- (void)safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc;

- (void)safeAppendString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
