//
//  GLWKUIDelegateImpl.m
//  YYW
//
//  Created by Rabe on 09/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLWKUIDelegateImpl.h"
#import "GLViewController.h"

@implementation GLWKUIDelegateImpl

#pragma mark - life cycle

- (instancetype)initWithWebEngine:(GLBridge *)engine
{
    if (self = [super init]) {
        _engine = engine;
    }
    return self;
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           completionHandler();
                                                       }])];
    GLViewController *vc = (GLViewController *) self.engine.viewController;
    if (vc.presentedViewController == nil ) {
        //防止模态窗口错误
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           completionHandler(NO);
                                                       }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           completionHandler(YES);
                                                       }])];
    GLViewController *vc = (GLViewController *) self.engine.viewController;
    if (vc.presentedViewController == nil ) {
        //防止模态窗口错误
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *_Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           completionHandler(alertController.textFields[0].text ?: @"");
                                                       }])];
    GLViewController *vc = (GLViewController *) self.engine.viewController;
    if (vc.presentedViewController == nil ) {
        //防止模态窗口错误
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

@end
