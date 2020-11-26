//
//  GLWKNavigationDelegateImpl.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLWKNavigationDelegateImpl.h"
#import "GLHybridSettings.h"
#import "GLInteractiveDelegateImpl.h"
#import "GLViewController.h"
#import <objc/message.h>

@interface GLWKNavigationDelegateImpl ()

@property (nonatomic, assign, readwrite) BOOL isBackForwardStart;         /* 内部页面是否准备发起一个回退上一级页面的请求 */
@property (nonatomic, weak, readwrite) id<WKNavigationDelegate> delegate; /* 可能实现了一些代理方法的业务VC */

@end

@implementation GLWKNavigationDelegateImpl

#pragma mark - life cycle

- (instancetype)initWithWebEngine:(GLBridge *)engine
{
    if (self = [super init]) {
        _engine = engine;
        _delegate = (id<WKNavigationDelegate>) _engine.viewController;
        _isBackForwardStart = NO;
    }
    return self;
}

#pragma mark - WKNavigationDelegate

#pragma mark 页面跳转的代理方法
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
    if ([_delegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [_delegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s", __FUNCTION__);
    if ([_delegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [_delegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%s, navigationType = %li webView.URL=%@",
          __FUNCTION__, (long) navigationAction.navigationType, webView.URL);
    if ([_delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    else {
        NSURL *url = [[navigationAction request] URL];
        GLViewController *vc = (GLViewController *) self.engine.viewController;
        NSString *redirectSelStr = [GLHybridSettings settingForKey:@"Hybrid-redirectFileURL-Method"
                                                             class:NSString.class
                                                        defaultVal:nil];
        SEL redirectSel = NSSelectorFromString(redirectSelStr);
        BOOL shouldCancelLoadURL = NO; // 默认可加载（不取消）
        // 优先配置文件定义scheme
        NSString *bridgeScheme = [GLHybridSettings settingForKey:@"Hybrid-bridge-scheme"
                                                           class:NSString.class
                                                      defaultVal:@"gl"];
        if ([[url scheme] isEqualToString:bridgeScheme]) {
            // 判断是否基于约定的请求
            shouldCancelLoadURL = YES; // 若是gl协议请求，则不走加载流程，执行js请求（js调oc）
            // 将JS的url转换成GLJsRequest对象 & 执行JS请求交互指令
            NSLog(@"\n【GLHybrid】开始解析url: \n%@\n\n", [[url absoluteString] stringByRemovingPercentEncoding]);
            // gl://forward?callid=2&param={"topage":"cart","animation":0,"fixPage":true,"params":{"canBack":"1"}}
            // gl://forward方式跳转本地界面
            [vc.interactiveDelegate executeJsRequestFromURL:url];
        }
        if ([_delegate respondsToSelector:redirectSel]) {
            // 将符合条件的url重定向本地
            shouldCancelLoadURL = (((BOOL(*)(id, SEL, id, id)) objc_msgSend)(_delegate,
                                                                             redirectSel,
                                                                             webView,
                                                                             navigationAction));
        }
        
        if ([self defaultPolicyForURL:url] && !shouldCancelLoadURL) {
            // 可以加载
            WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
            if (navigationAction.navigationType == WKNavigationTypeBackForward && !_isBackForwardStart) {
                _isBackForwardStart = YES;
            }
            decisionHandler(policy);
        }
        else {
            // 取消加载
            WKNavigationActionPolicy policy = WKNavigationActionPolicyCancel;
            decisionHandler(policy);
        }
    }
}

- (BOOL)defaultPolicyForURL:(NSURL *)url
{
    NSArray *schemes = [GLHybridSettings settingForKey:@"Hybrid-allowURLSchemes"
                                                 class:NSArray.class
                                            defaultVal:nil];
    return [schemes containsObject:url.scheme];
}

#pragma mark 用来追踪加载过程（页面开始加载、加载完成、加载失败）的方法

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    if ([_delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [_delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
    if ([_delegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [_delegate webView:webView didCommitNavigation:navigation];
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
    if (_isBackForwardStart) {
        _isBackForwardStart = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:GLWebPageDidBackForwardNotification object:webView];
    }
    if ([_delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_delegate webView:webView didFinishNavigation:navigation];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
    NSString *message = [NSString stringWithFormat:@"加载web页面失败，error: %@", [error localizedDescription]];
    NSLog(@"【GLHybrid】%@", message);
    if ([_delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [_delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    if ([_delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [_delegate webView:webView didFailNavigation:navigation withError:error];
    }
}

// 页面加载内容导致内容爆炸时，在webContent被kill之前reload页面，仅iOS9及以上有效
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"【GLHybrid】页面加载内容导致内容爆炸时，在webContent被kill之前reload页面，仅iOS9及以上有效");
    [webView reload];
}

@end
