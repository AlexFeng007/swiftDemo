//
//  GLBridge+Router.m
//  YYW
//
//  Created by Rabe on 2017/3/6.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridge+Router.h"
#import "GLMediator+WebViewActions.h"
#import "GLQRScanVC.h"
#import <WebKit/WebKit.h>
#import "GLErrorVC.h"

typedef NS_ENUM(NSUInteger, kForwardAnimationType) {
    kForwardAnimationTypePush = 0,
    kForwardAnimationTypePresent = 1,
};

typedef NS_ENUM(NSUInteger, kBackAnimationType) {
    kBackAnimationTypevPop = 0,
};

typedef void (^GLHybridBlock)(id data);

@implementation GLBridge (Router)

#pragma mark - public

/**
 前往页面
 
 gl://forward?callid=11111&param={
    "topage":"detail",
    "animation":0,  // 动画类型，0:push动画
    "params":{"productid":"12322"}
 }
 
 callback({
    "callid":11111,
    "errcode":2,
    "errmsg":"未登录",
 })
 
 */
- (void)forward:(GLJsRequest *)request
{
    NSString *topage = [request paramForKey:@"topage"];
    NSNumber *animation = [request paramForKey:@"animation"];
    NSNumber *fixPage = [request paramForKey:@"fixPage"]; // true:去特定页面 false:正常推出一个页面 默认false
    NSDictionary *params = [request paramForKey:@"params"];

    BOOL ret = false;
    SEL routerAction = NSSelectorFromString([NSString stringWithFormat:@"glMediator_%@ViewControllerWithParams:", topage]);
    if ([[GLMediator sharedInstance] respondsToSelector:routerAction]) {
        if ([fixPage boolValue]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[GLMediator sharedInstance] performSelector:routerAction withObject:params];
#pragma clang diagnostic pop
            ret = YES;
        }
        else { // 通过路由调节器获取一个业务页面实例
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([[[GLMediator sharedInstance] performSelector:routerAction withObject:params] isKindOfClass:UIViewController.class]) {
                UIViewController *vc = [[GLMediator sharedInstance] performSelector:routerAction withObject:params];
#pragma clang diagnostic pop
                ret = (vc == nil ? NO : YES);
                [self configHybridCallbackInViewController:vc callid:request.callbackId];
                if ([animation integerValue] == kForwardAnimationTypePush) { // 路由动画为push
                    [[FKYNavigator sharedNavigator] openViewController:vc isModal:NO animated:YES];
                }
                else if ([animation integerValue] == kForwardAnimationTypePresent) { // 路由动画为present
                    [[FKYNavigator sharedNavigator] openViewController:vc isModal:YES animated:YES];
                }
                else {
                    NSLog(@"【GLBridge+Router 警告】未知动画跳转类型: %@", animation);
                }
            }
            else {
                ret = NO;
            }
        }
    }
    else {
        NSLog(@"页面跳转失败<找不到对应类or方法>");
        ret = NO;
    }
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:ret ? GLBridgeRespCode_OK : GLBridgeRespCode_WRONG_PARAM data:nil];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:request.callbackId];
}

/**
 从浏览的历史中逐级返回上一层网页，如果已经是最顶层，则关闭当前容器
 
 gl://back?callid=11111&param={
    "animation":0, // animation	Number	动画类型，0:pop动画
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
 })
 
 */
- (void)back:(GLJsRequest *)request
{
    // 判断backItem是否为本地错误页面，如果是则直接pop
    WKWebView *webView = nil;
    if ([self.webViewEngine.engineWebView isKindOfClass:[WKWebView class]]) {
        webView = (WKWebView *) self.webViewEngine.engineWebView;
    }

    // backItem为H5页面，根据keyValue来判断逻辑
    NSNumber *animationType = [request paramForKey:@"animation"];
    if (nil != animationType) {
        switch ([animationType integerValue]) {
            case kBackAnimationTypevPop: {
                if (webView.canGoBack) {
                    [webView goBack];
                }
                else {
                    [self popRouterBack];
                }
                [self sendErrorCode:GLBridgeRespCode_OK data:nil request:request];
            } break;
            default: {
                [self sendErrorCode:GLBridgeRespCode_WRONG_PARAM data:nil request:request];
            } break;
        }
    }
    else {
        [self sendErrorCode:GLBridgeRespCode_WRONG_PARAM data:nil request:request];
    }
}

/**
 关闭当前容器
 
 gl://shutDown?callid=11111&param={
    "animation":0,
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
 })
 
 */
- (void)shutDown:(GLJsRequest *)request
{
    NSNumber *animationType = [request paramForKey:@"animation"];
    if (nil != animationType) {
        switch ([animationType integerValue]) {
            case kBackAnimationTypevPop: {
                [self popRouterBack];
                [self sendErrorCode:GLBridgeRespCode_OK data:nil request:request];
            } break;
            default: {
                [self sendErrorCode:GLBridgeRespCode_WRONG_PARAM data:nil request:request];
            } break;
        }
    }
    else {
        [self sendErrorCode:GLBridgeRespCode_WRONG_PARAM data:nil request:request];
    }
}

#pragma mark - private

- (void)configHybridCallbackInViewController:(UIViewController *)viewController callid:(NSString *)callid
{
    if (!viewController) {
        return;
    }
    
    SEL action = NSSelectorFromString(@"setHybridCallbackBlock:");
    if ([viewController respondsToSelector:action]) { // 判断该页面是否实现了设置回调block
        GLHybridBlock callbackBlock = ^(id data) {    // 回调block
            NSDictionary *dict;
            if ([data isKindOfClass:NSDictionary.class]) { // block返回值是字典则使用之
                dict = (NSDictionary *) data;
            }
            else { // block返回值非字典则判断是否为nil，若不是则封装成字典
                dict = @{ @"result" : data == nil ? @"无返回值" : data };
            }
            // 将返回值入参并实例化为response，交由interactiveDelegate发送给js端，至此完成页面传值给H5的通信过程
            GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:data ? GLBridgeRespCode_OK : GLBridgeRespCode_WRONG_PARAM data:dict];
            [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:callid];
        };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [viewController performSelector:action
                             withObject:callbackBlock]; // 将以上block传给目标页面
#pragma clang diagnostic pop
    }
}

- (void)sendErrorCode:(GLBridgeRespCode)errCode data:(NSDictionary *)data request:(GLJsRequest *)request
{
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:errCode data:data];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:request.callbackId];
}

- (void)popRouterBack
{
    NSArray *viewControllers = [FKYNavigator sharedNavigator].topNavigationController.viewControllers;
    if (viewControllers.count > 1) {
        if ([FKYNavigator sharedNavigator].visibleViewController == viewControllers[viewControllers.count-1] ) {
             [[FKYNavigator sharedNavigator] pop];
        }
    }else{
        [[FKYNavigator sharedNavigator] dismiss];
    }
    //UIViewController *viewController = self.viewController;
    // 需先判断push方式，再判断present方式。
    // 不是所有界面跳转都是简单的push或present，还可能是先present一个navi，再在此基本上push一个h5.
//    UINavigationController *naviController = viewController.navigationController;
//    if (naviController && naviController.viewControllers && naviController.viewControllers.count > 0) {
//        NSArray *arrays = viewController.navigationController.viewControllers;
//        if ([arrays count] >= 2) {
//            //栈顶是当前vc
//            if(viewController.navigationController.topViewController == viewController) {
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }
//            else if ([viewController isKindOfClass:GLErrorVC.class]) { // 错误页面特殊处理
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }
//            else { //栈顶不是当前vc悄悄的去掉
//                NSMutableArray *arr = viewController.navigationController.viewControllers.mutableCopy;
//                __block id vc = nil;
//                [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if (obj == viewController) {
//                        vc = obj;
//                        *stop = YES;
//                    }
//                }];
//
//                [arr removeObject:vc];
//                viewController.navigationController.viewControllers = arr.copy;
//            }
//        }
//    }
//    else {
//        [viewController dismissViewControllerAnimated:YES completion:nil];
//    }
    
//    if (nil != viewController.presentingViewController) {
//        [viewController dismissViewControllerAnimated:YES completion:nil];
//    }
//    else {
//        NSArray *arrays = viewController.navigationController.viewControllers;
//        if ([arrays count] >= 2) {
//            //栈顶是当前vc
//            if(viewController.navigationController.topViewController == viewController) {
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }
//            else if ([viewController isKindOfClass:GLErrorVC.class]) { // 错误页面特殊处理
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }
//            else { //栈顶不是当前vc悄悄的去掉
//                NSMutableArray *arr = viewController.navigationController.viewControllers.mutableCopy;
//                __block id vc = nil;
//                [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if (obj == viewController) {
//                        vc = obj;
//                        *stop = YES;
//                    }
//                }];
//
//                [arr removeObject:vc];
//                viewController.navigationController.viewControllers = arr.copy;
//            }
//        }
//    }
}

@end
