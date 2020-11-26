//
//  GLWebViewEngineProtocol.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLWebViewEngineProtocol <NSObject>

@property (nonatomic, readonly, strong) UIView *engineWebView;

- (id)loadRequest:(NSURLRequest *)request;
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (id)loadFileURL:(NSURL *)url allowingReadAccessToURL:(NSURL *)accessToURL;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

- (NSURL *)URL;
- (BOOL)canLoadRequest:(NSURLRequest *)request;

- (instancetype)initWithFrame:(CGRect)frame;
-(void)denitAddScript;
@end
