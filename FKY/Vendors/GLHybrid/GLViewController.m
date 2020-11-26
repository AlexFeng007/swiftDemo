//
//  GLViewController.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLViewController.h"
#import "GLHybrid.h"
#import "GLInteractiveDelegateImpl.h"
#import <WebKit/WebKit.h>

// 与js交互，ua前缀必须为app_sdk
static NSString *const GLHYBRID_PREFIX_UA_FLAG = @"app_sdk";

NSString *const GLWebPageDidResetNotification = @"GLWebPageDidResetNotification";
NSString *const GLWebPageDidBackForwardNotification = @"GLWebPageDidBackForwardNotification";


@interface GLViewController ()

@property (nonatomic, readwrite, strong) UIView *fakeStatuBar;
@property (nonatomic, readwrite, strong) id<GLWebViewEngineProtocol> webViewEngine;
@property (nonatomic, readwrite, strong) GLBridge *iOSBridge;

@end


@implementation GLViewController

@dynamic webView;
@synthesize interactiveDelegate = _interactiveDelegate;
@synthesize webViewEngine = _webViewEngine;

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self __initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __initialize];
    }
    return self;
}

- (void)__initialize
{
    // Write app_sdk into navigator.userAgent if needed.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if ([userAgent rangeOfString:GLHYBRID_PREFIX_UA_FLAG].location == NSNotFound) {
        NSString *prefix = [GLHybridSettings settingForKey:@"Hybrid-prefix-userAgent" class:NSString.class defaultVal:nil];
        NSString *surfix = [GLHybridSettings settingForKey:@"Hybrid-surfix-userAgent" class:NSString.class defaultVal:nil];
        NSString *__userAgent = [NSString stringWithFormat:@"%@_%@_%@", prefix.length ? prefix : @"", userAgent, surfix.length ? surfix : @""];
        NSDictionary *defaults = [[NSDictionary alloc] initWithObjectsAndKeys:__userAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
    
    _isFakeStatusBarVisible = YES;
    _interactiveDelegate = [[GLInteractiveDelegateImpl alloc] initWithViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageDidBackForward:)
                                                 name:GLWebPageDidBackForwardNotification
                                               object:self.webViewEngine.engineWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!([(WKWebView *) self.webView title].length)) { // 在WKWebView白屏的时候，另一种现象是 webView.title 会被置空
        [self reloadPage];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.webView) {
        [self setupWebView];
        [self setWebViewStickTop:NO]; // 默认不吸顶
        [self setFakeStatusBarHidden:!_isFakeStatusBarVisible]; // 不吸顶则展示伪造状态栏
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - notification

- (void)applicationWillTerminate:(NSNotification *)notification
{
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
}

- (void)paegDidReset:(NSNotification *)notification
{
}

- (void)pageDidBackForward:(NSNotification *)notification
{
}

#pragma mark - public

- (void)loadUrl
{
    // 子类可以重写此处逻辑
    if (self.urlPath.length) { // 加载url链接
        NSURL *url = [NSURL URLWithString:[self createStringByAddingPercentEscapesWithUrlPath:self.urlPath]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
        [self.webViewEngine loadRequest:request];
    }
    else if (self.htmlString.length) { // 加载html内容
        [self.webViewEngine loadHTMLString:self.htmlString baseURL:nil];
    }
    else { // 加载本地文件或错误页面
        NSString *localHtmlPath = [[NSBundle mainBundle] pathForResource:self.localUrl ofType:@"html"];
        if (localHtmlPath.length) {
            NSURL *url = [NSURL fileURLWithPath:localHtmlPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webViewEngine loadRequest:request];
        }
        else { // TODO: 默认错误提示或html页面
            NSString *defaultLoadError = @"页面加载失败";
            NSString *html = [NSString stringWithFormat:@"<html><body> %@ </body></html>", defaultLoadError];
            [self.webViewEngine loadHTMLString:html baseURL:nil];
        }
    }
}

- (void)reloadPage
{
    [(WKWebView *)self.webView reload];
}

- (GLBridge *)nativeAPI
{
    return self.iOSBridge;
}

- (void)setWebViewStickTop:(BOOL)isStickTop
{
    CGFloat statuBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    CGRect frame = CGRectZero;
    if (isStickTop) {
        frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } else {
        frame = CGRectMake(0, statuBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - statuBarHeight);
    }
    [self.webView setFrame:frame];
}

- (void)setFakeStatusBarHidden:(BOOL)hidden
{
    self.fakeStatuBar.hidden = hidden;
}

#pragma mark - private

- (NSString *)createStringByAddingPercentEscapesWithUrlPath:(NSString *)urlPath
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlPath, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8);
}

#pragma mark - ui

- (void)setupWebView
{
    CGRect webViewBounds = self.view.bounds;
    webViewBounds.origin = self.view.bounds.origin;

    NSString *defaultWebViewEngineClass = @"GLWebViewEngine";
    self.webViewEngine = [[NSClassFromString(defaultWebViewEngineClass) alloc] initWithFrame:webViewBounds];
    [self registerBridge:self.webViewEngine];

    UIView *webView = self.webViewEngine.engineWebView;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:webView];
    [self.view sendSubviewToBack:webView];
    
    // 用于遮挡状态栏透明，暴露了web的内容的缺陷
    self.automaticallyAdjustsScrollViewInsets = NO;
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)) {
        ((WKWebView *) self.webView).scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    //兼容12.0以上系统网页输入框弹起键盘时，导致网页自动向上滑动导致键盘不能聚焦
    if (@available(iOS 12.0, *)) {
        ((WKWebView *) self.webView).scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    [self.view addSubview:self.fakeStatuBar];
    [self.view bringSubviewToFront:self.fakeStatuBar];
    
    CGFloat statuBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    [self.fakeStatuBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width, statuBarHeight)];
}

- (void)registerBridge:(GLBridge *)bridge
{
    if ([bridge respondsToSelector:@selector(setViewController:)]) {
        [bridge setViewController:self];
    }

    if ([bridge respondsToSelector:@selector(setInteractiveDelegate:)]) {
        [bridge setInteractiveDelegate:_interactiveDelegate];
    }

    [bridge initialization];
}

#pragma mark - property

- (UIView *)webView
{
    if (self.webViewEngine) {
        return self.webViewEngine.engineWebView;
    }
    return nil;
}

- (GLBridge *)iOSBridge
{
    if (_iOSBridge == nil) {
        _iOSBridge = [[GLBridge alloc] initWithWebViewEngine:_webViewEngine];
        [self registerBridge:_iOSBridge];
    }
    return _iOSBridge;
}

- (UIView *)fakeStatuBar
{
    if (_fakeStatuBar == nil) {
        _fakeStatuBar = [UIView new];
        _fakeStatuBar.translatesAutoresizingMaskIntoConstraints = NO;
        _fakeStatuBar.backgroundColor = [UIColor whiteColor];
    }
    return _fakeStatuBar;
}

@end
