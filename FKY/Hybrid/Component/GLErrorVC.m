//
//  GLErrorVC.m
//  YYW
//
//  Created by Rabe on 17/04/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLErrorVC.h"
#import "GLHybrid.h"
#import <WebKit/WebKit.h>

@interface GLErrorVC ()

@end

@implementation GLErrorVC

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupStatuBar];
    
    [self loadUrl];
}

#pragma mark - override

- (void)loadUrl
{
    // 子类可以重写此处逻辑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hybridError" ofType:@"html"];
    if (path) {
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        [self.webViewEngine loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }
}

#pragma mark - delegate

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    NSArray *controllers = self.parentViewController.navigationController.viewControllers;
//    if (controllers.count <= 1) {
//        [self.interactiveDelegate evaluateJs:@"document.getElementById(\"gobackbutton\").style.display=\"none\""];
//    }
}

#pragma GLErrorVCDelegate

- (void)parentVC:(UIViewController *_Nullable)viewController didFailProvisionalNavigation:(WKNavigation *_Nullable)navigation withError:(nonnull NSError *)error
{
}

- (void)parentVC:(UIViewController *)viewController didStartProvisionalNavigation:(WKNavigation *)navigation
{
}

- (void)parentVC:(UIViewController *)viewController didFinishNavigation:(WKNavigation *)navigation
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

#pragma mark - ui

- (void)setupStatuBar
{
    //用于遮挡状态栏透明，暴露了web的内容的缺陷
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *viewUnderStatusBar = [UIView new];
    [viewUnderStatusBar setBackgroundColor:[UIColor colorWithRed:249 / 255.0f green:249 / 255.0f blue:249 / 255.0f alpha:1.0f]];
    [viewUnderStatusBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:viewUnderStatusBar];
    [self.view bringSubviewToFront:viewUnderStatusBar];

    CGFloat heightStatusBar = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewUnderStatusBar(statusBarH)]" options:0 metrics:@{ @"statusBarH" : @(heightStatusBar) } views:NSDictionaryOfVariableBindings(viewUnderStatusBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewUnderStatusBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewUnderStatusBar)]];

    CGRect frameFullScreen = self.view.bounds;
    CGRect frameWebView = CGRectMake(0, heightStatusBar, CGRectGetWidth(frameFullScreen), CGRectGetHeight(frameFullScreen) - heightStatusBar);
    [self.webView setFrame:frameWebView];
}

@end
