//
//  NSObject+SafeRuntime.h
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//  利用runtime实现swizzle method & 给桩对象动态增加方法

#import <Foundation/Foundation.h>

@interface NSObject (SafeRuntime)

+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;
+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;
+ (Class)addMethodToStubClass:(SEL)aSelector;

@end
