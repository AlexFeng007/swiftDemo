//
//  GLWKNavigationDelegateImpl.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class GLBridge;

@interface GLWKNavigationDelegateImpl : NSObject <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) GLBridge *engine; /* <webView引擎 */

/**
 初始化方法

 @param engine webView引擎
 @return 遵守<WKNavigationDelegate>的实例对象
 */
- (instancetype)initWithWebEngine:(GLBridge *)engine;

@end
