//
//  NSTimer+Safe.h
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//  防止timer循环引用导致内存泄露...<swizzle methods for NSTimer by category>

#import <Foundation/Foundation.h>

@interface NSTimer (Safe)

@end
