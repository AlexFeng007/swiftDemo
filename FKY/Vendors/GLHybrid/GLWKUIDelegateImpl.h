//
//  GLWKUIDelegateImpl.h
//  YYW
//
//  Created by Rabe on 09/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class GLBridge;

@interface GLWKUIDelegateImpl : NSObject <WKUIDelegate>

@property (nonatomic, weak) GLBridge *engine; /* <webView引擎 */

/**
 初始化方法
 
 @param engine webView引擎
 @return 遵守<WKNavigationDelegate>的实例对象
 */
- (instancetype)initWithWebEngine:(GLBridge *)engine;

@end
