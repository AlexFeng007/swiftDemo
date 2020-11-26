//
//  GLWebViewEngine.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLWebViewEngine.h"
#import "GLHybridSettings.h"
#import "GLWKNavigationDelegateImpl.h"
#import "GLWKUIDelegateImpl.h"
#import <objc/runtime.h>


@interface GLWebViewEngine ()

@property (nonatomic, readwrite, strong) UIView *engineWebView;
@property (nonatomic, readwrite, strong) WKUserContentController *contentController;
@property (nonatomic, readwrite, strong) id<WKUIDelegate> wkUIDelegate;
@property (nonatomic, readwrite, strong) id<WKNavigationDelegate> wkWebViewDelegate;
@end

@implementation GLWebViewEngine

@synthesize engineWebView = _engineWebView;

#pragma mark - life cycle

+ (void)load
{
    if ([UIDevice currentDevice].systemVersion.floatValue < (9.0)) {
        Method origMethod = class_getInstanceMethod(self.class,
                                                    NSSelectorFromString(@"evaluateJavaScript:completionHandler:"));
        Method altMethod = class_getInstanceMethod(self.class,
                                                   NSSelectorFromString(@"altEvaluateJavaScript:completionHandler:"));
        method_exchangeImplementations(origMethod, altMethod);
    }
}

// WKWebView 退出并被释放后导致 completionHandler 变成野指针，而此时 javaScript Core 还在执行JS代码，
// 待 javaScript Core 执行完毕后会调用 completionHandler() ，导致 crash。仅iOS8有此问题。
// 对于iOS 8系统，可以通过在 completionHandler 里 retain WKWebView 防止 completionHandler 被过早释放
- (void)altEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    id strongSelf = (WKWebView *) self.engineWebView;
    [self altEvaluateJavaScript:javaScriptString
              completionHandler:^(id r, NSError *e) {
        [strongSelf title];
        if (completionHandler) {
            completionHandler(r, e);
        }
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        WKUserContentController *userContentController = WKUserContentController.new;
        
        NSMutableString *script = [[NSMutableString alloc] init];
        
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            if ([cookie.domain isEqualToString:[self domain]]) {
                NSString *cookieString = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
                [script appendString:[NSString stringWithFormat:@"document.cookie='%@;path=/;domain=.yaoex.com';", cookieString]];
            }
        }
        
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:script
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                         forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        
        
        WKWebViewConfiguration *webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        WKWebView *webview = [[WKWebView alloc] initWithFrame:frame configuration:webViewConfig];
        webview.allowsBackForwardNavigationGestures = YES;
        
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        webViewConfig.preferences = preference;
        
        [webViewConfig.userContentController addScriptMessageHandler:self name:@"openPDF"];
        
        self.contentController = userContentController;
        self.engineWebView = webview;
        self.engineWebView.backgroundColor = [UIColor whiteColor];
        [[(WKWebView *) self.engineWebView scrollView] setShowsVerticalScrollIndicator:NO];
        [[(WKWebView *) self.engineWebView scrollView] setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}
-(void)denitAddScript{
    if (self.contentController != nil){
         [self.contentController removeScriptMessageHandlerForName:@"openPDF"];
    }
}
- (void)initialization
{
    WKWebView *wkWebView = (WKWebView *) _engineWebView;
    
    self.wkWebViewDelegate = [[GLWKNavigationDelegateImpl alloc] initWithWebEngine:self];
    self.wkUIDelegate = [[GLWKUIDelegateImpl alloc] initWithWebEngine:self];
    wkWebView.navigationDelegate = self.wkWebViewDelegate;
    wkWebView.UIDelegate = self.wkUIDelegate;
}

#pragma mark - GLWebViewEngineProtocol

- (id)loadRequest:(NSURLRequest *)request
{
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.domain isEqualToString:[self domain]]) {
            NSString *cookieItem = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
            [cookieString appendString:[NSString stringWithFormat:@"%@;", cookieItem]];
        }
    }
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:request.URL];
    [mutableRequest addValue:cookieString forHTTPHeaderField:@"Cookie"];
    [mutableRequest addValue:FKYAnalyticsManager.sharedInstance.h5ReferPageCode forHTTPHeaderField:@"refer"];
    
    [(WKWebView *) _engineWebView loadRequest:mutableRequest];
    return nil;
}

- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    [(WKWebView *) _engineWebView loadHTMLString:string baseURL:baseURL];
    return nil;
}

- (id)loadFileURL:(NSURL *)url allowingReadAccessToURL:(NSURL *)accessToURL
{
    WKWebView *webview = (WKWebView *) self.engineWebView;
    if ([webview respondsToSelector:@selector(loadFileURL:allowingReadAccessToURL:)]) {
        [webview loadFileURL:url allowingReadAccessToURL:accessToURL];
    }
    else {
        [self loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return nil;
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    [(WKWebView *) _engineWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}
//! WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name caseInsensitiveCompare:@"openPDF"] == NSOrderedSame) {
        NSDictionary *pdfDic = message.body;
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *vc) {
            if (pdfDic[@"url"] != nil ){
                vc.urlPath = [pdfDic objectForKey:@"url"];
            }
            if (pdfDic[@"orderId"] != nil ){
                vc.orderId = [pdfDic objectForKey:@"orderId"];
            }
            vc.barStyle = FKYBarStyleWhite;
            vc.isLookRcPDF = 1;
            vc.fromFuson = true;
        }];
    }
}

- (NSURL *)URL
{
    return [(WKWebView *) _engineWebView URL];
}

- (BOOL)canLoadRequest:(NSURLRequest *)request
{
    return (request != nil);
}

#pragma mark - private

- (NSString *)domain
{
    return [GLHybridSettings settingForKey:@"Hybrid-domain" class:NSString.class defaultVal:@""];
}

@end
