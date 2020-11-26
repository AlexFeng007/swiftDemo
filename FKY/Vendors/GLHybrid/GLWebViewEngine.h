//
//  GLWebViewEngine.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "GLBridge.h"
#import "GLWebViewEngineProtocol.h"

@interface GLWebViewEngine : GLBridge <GLWebViewEngineProtocol,WKScriptMessageHandler>

@property (nonatomic, strong, readonly) id<WKUIDelegate> wkUIDelegate;              /* <实现WKUIDelegate>的实例 */
@property (nonatomic, strong, readonly) id<WKNavigationDelegate> wkWebViewDelegate; /* <实现WKNavigationDelegate的实例 */
@end
