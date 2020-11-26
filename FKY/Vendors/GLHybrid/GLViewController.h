//
//  GLViewController.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBridge.h"
#import "GLInteractiveDelegate.h"
#import "GLWebViewEngineProtocol.h"

extern NSString *const GLWebPageDidResetNotification;
extern NSString *const GLWebPageDidBackForwardNotification;

@interface GLViewController : UIViewController

@property (nonatomic, readonly, weak) UIView *webView; /* <WebView容器 */

@property (nonatomic, readwrite, copy) NSString *urlPath;    /* <访问的url链接 */
@property (nonatomic, readwrite, copy) NSString *htmlString; /* <访问的HTML STRING */
@property (nonatomic, readwrite, copy) NSString *hybridUrl;  /* <访问的hybrid网页 */
@property (nonatomic, readwrite, copy) NSString *localUrl;   /* <访问的本地目录 */

@property (nonatomic, readwrite, assign) BOOL isFakeStatusBarVisible; /* <伪造状态栏显示状态 */

@property (nonatomic, readonly, strong) id<GLWebViewEngineProtocol> webViewEngine;     /* <webView引擎 */
@property (nonatomic, readonly, strong) id<GLInteractiveDelegate> interactiveDelegate; /* <交互内核 */

/**
 重新加载当前网页
 */
- (void)reloadPage;
/**
 子类根据工程业务需要重写此方法,设置容器加载urlPath或htmlString或hybridUrl或localUrl等逻辑
 */
- (void)loadUrl;
/**
 获取SDK接口实例对象

 @return SDK提供的接口的实例对象
 */
- (GLBridge *)nativeAPI;
/**
 容器H5内置导航栈返回时的通知
 */
- (void)pageDidBackForward:(NSNotification *)notification;
/**
 是否吸顶
 */
- (void)setWebViewStickTop:(BOOL)isStickTop;

/**
 隐藏伪造状态栏
 */
- (void)setFakeStatusBarHidden:(BOOL)hidden;

@end
