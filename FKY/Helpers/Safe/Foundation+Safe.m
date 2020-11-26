//
//  Foundation+Safe.m
//  YYW
//
//  Created by HUI on 2018/5/30.
//  Copyright © 2018年 YYW. All rights reserved.
//

#import "Foundation+Safe.h"
#import <objc/runtime.h>

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_setImplementation(class_getInstanceMethod(self, @selector(objectAtIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeObjectAtIndexedSubscript:)));
        
        method_setImplementation(class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeObjectAtIndexedSubscript:)));
        method_setImplementation(class_getInstanceMethod(NSClassFromString(@"__NSArray0"), @selector(objectAtIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeObjectAtIndexedSubscript:)));
        method_setImplementation(class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeObjectAtIndexedSubscript:)));
    });
}

- (id)safeObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

+ (instancetype)safeArrayWithObject:(id)object {
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        //超过了边界,就获取从loction开始所有的item
        length = (self.count - location);
        return [self safeSubarrayWithRange:NSMakeRange(location, length)];
    } else {
        return [self subarrayWithRange:range];
    }
}

@end

@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_setImplementation(class_getInstanceMethod(self, @selector(setObject:atIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeSetObject:atIndexedSubscript:)));
        
        method_setImplementation(class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:)), class_getMethodImplementation(self, @selector(safeObjectAtIndexedSubscript:)));
    });
}

- (void)safeSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (obj == nil) {
        return;
    }

    if (self.count < idx) {
        return;
    }

    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

- (void)safeAddObject:(id)object {
    if (object == nil) {
        return;
    } else {
        [self addObject:object];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object == nil) {
        return;
    } else if (index > self.count) {
        return;
    } else {
        [self insertObject:object atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs {
    NSUInteger firstIndex = indexs.firstIndex;
    if (indexs == nil) {
        return;
    } else if (indexs.count != objects.count || firstIndex > objects.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return;
    } else {
        [self removeObjectAtIndex:index];
    }
}

- (void)safeRemoveObjectsInRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        return;
    } else {
        [self removeObjectsInRange:range];
    }
}

- (id)safeObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

@end

@implementation NSDictionary (Safe)

+ (instancetype)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key {
    if (!object || !key) {
        return [self dictionary];
    } else {
        return [self dictionaryWithObject:object forKey:key];
    }
}

@end

@implementation NSMutableDictionary (safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_setImplementation(class_getInstanceMethod(self, @selector(setObject:forKeyedSubscript:)), class_getMethodImplementation(self, @selector(safeSetObject:forKeyedSubscript:)));
    });
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (!key) {
        return;
    }

    if (!obj) {
        [self removeObjectForKey:key];
    } else {
        [self setObject:obj forKey:key];
    }
}

- (void)safeSetObject:(id)obj forKey:(id <NSCopying>)key {
    if (obj && key) {
        [self setObject:obj forKey:key];
    } else {
        return;
    }
}

@end

@implementation NSString (Safe)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        return nil;
    } else {
        return [self substringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to {
    if (to > self.length) {
        return nil;
    } else {
        return [self substringToIndex:to];
    }
}

- (NSString *)safeSubstringWithRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.length) {
        return nil;
    } else {
        return [self substringWithRange:range];
    }
}

- (NSString *)safeStringByAppendingString:(NSString *)aString {
    if (aString == nil) {
        return [self stringByAppendingString:@""];
    } else {
        return [self stringByAppendingString:aString];
    }
}

- (instancetype)safeInitWithString:(NSString *)aString {
    if (aString == nil) {
        return [self initWithString:@""];
    } else {
        return [self initWithString:aString];
    }
}

+ (instancetype)safeStringWithString:(NSString *)string {
    if (string == nil) {
        return [self stringWithString:@""];
    } else {
        return [self stringWithString:string];
    }
}

@end

@implementation NSMutableString (Safe)

- (void)safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (aString == nil) {
        return;
    } else if (loc > self.length) {
        return;
    } else {
        [self insertString:aString atIndex:loc];
    }
}

- (void)safeAppendString:(NSString *)aString {
    if (aString == nil) {
        return;
    } else {
        [self appendString:aString];
    }
}

@end

