//
//  GLBridge+NavigationBar.m
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridge+NavigationBar.h"
#import <WebKit/WebKit.h>
#import "GLErrorVC.h"
#import "UIColor+HEX.h"
#import "GLBridge+Share.h"

static NSString *GLNAVBAR_COMMAND_KEY = @"GLNAVBAR_COMMAND_KEY";
static NSString *GLNAVBAR_DICT_KEY = @"GLNAVBAR_DICT_KEY";


@implementation GLBridge (NavigationBar)

#pragma mark - private

- (void)clearLastNavigationBar
{
    //检查是否已经添加了NavigationBar
    NSPredicate *searchOldNavBar = [NSPredicate predicateWithFormat:@"class == %@", [GLNavigationBarComponent class]];
    NSArray<GLNavigationBarComponent *> *aryoldNavBar = [self.viewController.view.subviews filteredArrayUsingPredicate:searchOldNavBar];

    if ([aryoldNavBar count] > 0) {
        [aryoldNavBar makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    }
}

- (NSString *)safeString:(NSString *)str
{
    if ([str isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    else if ([str isKindOfClass:[NSNull class]] || str == nil) {
        return @"";
    }
    else if ([str isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", [str description]];
    }
    else if ([str isKindOfClass:[NSString class]]) {
        return (NSString *) str;
    }
    else if ([str isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([str isEqualToString:@"(null)"]) {
        return @"";
    }

    return (str == nil ? @"" : str);
}

- (NSArray *)safeArray:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        return @[];
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray *) obj;
    }
    else {

        return @[];
    }
    return @[];
}

- (NSDictionary *)safeDictionary:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        return @{};
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *) obj;
    }
    else {
        return @{};
    }
    return @{};
}

#pragma mark - GL Componet Method
/**
 设置导航栏

 gl://setupNavigation?callid=11111&param={
    "left": {
        "imgUrl": "",  // 最好返回按钮图片由h5返回
        "hasBack":true,
        "hasShutdown":true,
        "callid":callid
    },
    "middle": {
        "title":"购物车",
         "color":"0xffffff"
    },
     "bar": {
        "color":"0xf54b41"
     },
    "right"://最多有两个数据
        [{
            "imgUrl":"https://www.baidu.com/1234jjj.png",
            "buttonName":"需求清单"，
            "callid":32233,//native主动调用的JS方法
        }]
 }

 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
    "data":{}
 })
 
*/
- (void)setupNavigation:(GLJsRequest *)request
{
    self.request = request;
    [self.navigationDict removeAllObjects];
    self.navigationDict = request.param.mutableCopy;

    [self clearLastNavigationBar];

    GLNavigationBarComponent *navBar = [[GLNavigationBarComponent alloc] init];
    [navBar setEventDelegate:self];
    [navBar setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.viewController.view addSubview:navBar];

    [self.viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];

    [self.viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navBar)]];

    id objIsShowNavBar = [request paramForKey:@"isShow"];
    BOOL isShowNavBar = NO; //默认是不展示
    if (nil != objIsShowNavBar) {
        isShowNavBar = [[self safeString:objIsShowNavBar] boolValue];
    }

    //适配iphoneX tabbar上的vc并且tabbar没有隐藏不需要留出底部距离
    CGFloat bottomHeight = 0;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomHeight = insets.bottom;
        }
    }
    CGFloat bottomSpace = (self.viewController.navigationController.viewControllers.count <= 1) ? 0 : bottomHeight;
    
    // 显示状态栏与否
    GLViewController *vc = (GLViewController *)self.viewController;
    
    if (isShowNavBar) {
        // 显示自定义导航栏
        [vc setFakeStatusBarHidden:YES];
        [navBar setHidden:NO];
        [[navBar superview] bringSubviewToFront:navBar];
        
        // 设置导航背景色
        NSDictionary *barConfigurations = [self safeDictionary:[request paramForKey:@"bar"]];
        UIColor *barColor = [self parseColorInDictionary:barConfigurations];
        if (barColor) {
            navBar.backgroundColor = barColor;
        }
        
        // 设置导航左侧按钮
        NSDictionary *leftConfigurations = [self safeDictionary:[request paramForKey:@"left"]];
        BOOL isShowReturnButton = [leftConfigurations[@"hasBack"] boolValue];
        BOOL isShowCloseButton = [leftConfigurations[@"hasShutdown"] boolValue];
        NSString *shutDownTextColorValue = [self safeString:leftConfigurations[@"shutDownTextColor"]];
        UIColor *shutDownTextColor = nil;
        if (shutDownTextColorValue.length == 8 && [shutDownTextColorValue hasPrefix:@"0x"]) {
            shutDownTextColor = [UIColor colorWithHexStr:shutDownTextColorValue];
        }
        if (barColor) {
            navBar.backgroundColor = barColor;
        }
        if (isShowReturnButton && !isShowCloseButton) { //only return
            NSString *imageFlag = [self safeString:leftConfigurations[@"imgUrl"]];
            [navBar configNavLeftButton:imageFlag];
        }
        else if (!isShowReturnButton && isShowCloseButton) { //only close
            [navBar configNavCloseButtonWithTextColor:shutDownTextColor];
        }
        else if (isShowReturnButton && isShowCloseButton) { //retrun & close
            NSString *imageFlag = [self safeString:leftConfigurations[@"imgUrl"]];
            [navBar configNavLeftButton:imageFlag];
            [navBar configNavCloseButtonWithTextColor:shutDownTextColor];
        }
        
        // 设置导航title
        NSDictionary *titleConfigurations = [self safeDictionary:[request paramForKey:@"middle"]];
        NSString *strTitle = [self safeString:titleConfigurations[@"title"]];
        [navBar setTitle:strTitle];
        UIColor *titleColor = [self parseColorInDictionary:titleConfigurations];
        if (titleColor) {
            [navBar setTitleColor:titleColor];
        }
        
        //从右到左设置导航右侧按钮
        NSArray<NSDictionary *> *rightConfigurations = [self safeArray:[request paramForKey:@"right"]];
        NSDictionary *dicRgitButtonInfo = nil;
        for (NSInteger i = (rightConfigurations.count - 1); i >= 0; i--) {
            dicRgitButtonInfo = [self safeDictionary:rightConfigurations[i]];
            NSLog(@"%zi  %@", i, dicRgitButtonInfo);
            [navBar configNavRightButtonWithIndex:i imgUrl:[self safeString:dicRgitButtonInfo[@"imgUrl"]] title:[self safeString:dicRgitButtonInfo[@"buttonName"]]];
        }
        
        // 设置导航底部细线
        NSDictionary *bottomlineConfigurations = [self safeDictionary:[request paramForKey:@"bottomLine"]];
        BOOL isShowLine = [bottomlineConfigurations[@"visible"] boolValue];
        [navBar setBottomLineVisible:isShowLine];
        if (isShowLine) { //显示细线
            UIColor *lineColor = [self parseColorInDictionary:bottomlineConfigurations];
            if (lineColor) {
                [navBar setBottomLineColor:lineColor];
            }
        }
        
        CGRect frameFullScreen = self.viewController.view.bounds;
        CGRect frameWebView = CGRectMake(0, CGRectGetHeight(navBar.frame), CGRectGetWidth(frameFullScreen), CGRectGetHeight(frameFullScreen) - CGRectGetHeight(navBar.frame)-bottomSpace);
        [self.webView setFrame:frameWebView];
    }
    else {
        // 隐藏本地导航栏
        CGFloat statuBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        
        CGRect frame = CGRectZero;
        if (!vc.isFakeStatusBarVisible) {
            frame = CGRectMake(0, 0, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height);
        } else {
            frame = CGRectMake(0, statuBarHeight, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height - statuBarHeight);
        }
        [self.webView setFrame:frame];
        [navBar setHidden:YES];
        [vc setFakeStatusBarHidden:!vc.isFakeStatusBarVisible];
    }
    
    [self sendOkRespToJSWithData:nil callbackid:self.request.callbackId];
}

/**
 隐藏导航栏

 gl://hideNavigation?callid=11111&param={
    "isHide":true, //true:隐藏原生导航 false:显示原生导航
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
    "data":{}
 })
 
 */
- (void)hideNavigation:(GLJsRequest *)request
{
    //true:隐藏原生导航 false:显示原生导航
    NSNumber *isHiddent = [request paramForKey:@"isHide"];
    if ([isHiddent boolValue]) { //隐藏原生导航
        [self hideNavigationBar:nil];
    }
    else { //显示原生导航
        [self showNavigationBar:nil];
    }

    [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
}

#pragma mark - GLNavigationBarComponentEventDelegate

- (void)touchLeftReturnNavigationBarButton
{
    NSNumber *callidBack = [self safeDictionary:[self.navigationDict objectForKey:@"left"]][@"callid"];
    if (nil == callidBack || callidBack.integerValue == 0) { //如果callid为空，按照原生返回按钮走,参照YWBaseWebViewController类的逻辑走
        WKWebView *webView = nil;
        if ([self.webViewEngine.engineWebView isKindOfClass:[WKWebView class]]) {
            webView = (WKWebView *) self.webViewEngine.engineWebView;
        }
        // backItem为H5页面，根据keyValue来判断逻辑
        if (webView.canGoBack) {
            BOOL ret = [[self safeDictionary:[self.navigationDict objectForKey:@"left"]][@"isShutdown"] boolValue];
            if (ret) {
                [self popBack];
            } else {
                [webView goBack];
            }
        }
        else {
            [self popBack];
        }
    }
    else {
        [self sendOkRespToJSWithData:nil callbackid:callidBack.stringValue];
    }
}

//参照YWSubjectViewController的逻辑来
- (void)touchLeftCloseNavigationBarButton
{
    [self popBack];
}

- (void)touchRightNavigationBarButton:(NSInteger)index
{
    NSArray<NSDictionary *> *rightConfigurations = [self safeArray:[self.navigationDict objectForKey:@"right"]];
    if (index <= rightConfigurations.count-1) {
        NSDictionary *dicRgitButtonInfo = [self safeDictionary:rightConfigurations[index]];
        
        // callid=9998 触发分享
        NSNumber *callid = dicRgitButtonInfo[@"callid"];
        
        if (nil == callid) {
            // callid为空
            [self sendWrongParamRespToJSWithCallbackid:self.request.callbackId];
        }
        else {
            //分享电子发票自定义参数，本地出发分享
            if ([dicRgitButtonInfo[@"isLookInvoice"] integerValue] == 1){
                GLWebVC *vc = (GLWebVC *)self.viewController;
                NSMutableDictionary *dic = [NSMutableDictionary new];
                dic[@"title"] = @"1药城电子普通发票";
                dic[@"content"] = [NSString stringWithFormat:@"订单号:\n%@  订单金额:%@",vc.orderId,vc.orderTotalNum];
                dic[@"imgUrl"] = @"";
                dic[@"shareUrl"] = vc.urlPath;
                dic[@"shareTypes"] = @[@"wxfriend",@"qqfriend",@"copyContent"];
                dic[@"type"] = @"2";
                GLJsRequest *request = [[GLJsRequest alloc] init];
                request.param = dic;
                [self share:request];
            }else if ([dicRgitButtonInfo[@"isLookRcPDF"] integerValue] == 1){
                GLWebVC *vc = (GLWebVC *)self.viewController;
                NSMutableDictionary *dic = [NSMutableDictionary new];
                dic[@"title"] = @"1药城退货证明";
                dic[@"content"] = [NSString stringWithFormat:@"订单号:\n%@",vc.orderId];
                dic[@"imgUrl"] = @"";
                dic[@"shareUrl"] = vc.urlPath;
                dic[@"shareTypes"] = @[@"wxfriend",@"qqfriend",@"copyContent"];
                dic[@"type"] = @"2";
                GLJsRequest *request = [[GLJsRequest alloc] init];
                request.param = dic;
                [self share:request];
            }else{
            // callid不为空
            [self sendOkRespToJSWithData:nil callbackid:[callid stringValue]];
            }
        }
    }
    else {
        [self sendWrongParamRespToJSWithCallbackid:self.request.callbackId];
    }
}

#pragma mark - private

- (void)popBack
{
    [self.viewController.view endEditing:YES];
    [[FKYNavigator sharedNavigator] pop];
}

- (void)hideNavigationBar:(GLJsRequest *)request
{
    NSPredicate *searchOldNavBar = [NSPredicate predicateWithFormat:@"class == %@", [GLNavigationBarComponent class]];
    NSArray<GLNavigationBarComponent *> *aryoldNavBar = [self.viewController.view.subviews filteredArrayUsingPredicate:searchOldNavBar];
    if ([aryoldNavBar count] > 0) {
        for (GLNavigationBarComponent *navBar in aryoldNavBar) {
            [navBar setHidden:YES];
        }
        CGFloat heightStatusBar = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        CGRect frameFullScreen = self.viewController.view.bounds;
        CGRect frameWebView = CGRectMake(0, heightStatusBar, CGRectGetWidth(frameFullScreen), CGRectGetHeight(frameFullScreen) - heightStatusBar);
        [self.webView setFrame:frameWebView];
    }
    else {
        NSLog(@"没有可隐藏的导航栏");
    }
}

- (void)showNavigationBar:(GLJsRequest *)request
{
    NSPredicate *searchOldNavBar = [NSPredicate predicateWithFormat:@"class == %@", [GLNavigationBarComponent class]];
    NSArray<GLNavigationBarComponent *> *aryoldNavBar = [self.viewController.view.subviews filteredArrayUsingPredicate:searchOldNavBar];
    if ([aryoldNavBar count] > 0) {
        //只显示最上层的导航栏
        for (GLNavigationBarComponent *navBar in aryoldNavBar) {
            [navBar setHidden:YES];
        }

        GLNavigationBarComponent *navBar = [aryoldNavBar lastObject];
        [navBar setHidden:NO];
        [[navBar superview] bringSubviewToFront:navBar];
        CGRect frameFullScreen = self.viewController.view.bounds;
        CGRect frameWebView = CGRectMake(0, CGRectGetHeight(navBar.frame), CGRectGetWidth(frameFullScreen), CGRectGetHeight(frameFullScreen) - CGRectGetHeight(navBar.frame));
        [self.webView setFrame:frameWebView];
    }
    else {
        NSLog(@"没有可隐藏的导航栏");
    }
}

- (UIColor *)parseColorInDictionary:(NSDictionary *)dictionary
{
    NSString *value = [self safeString:dictionary[@"color"]];
    if (value.length == 8 && [value hasPrefix:@"0x"]) {
        return [UIColor colorWithHexStr:value];
    }
    return nil;
}

#pragma mark - property

- (GLJsRequest *)request
{
    return objc_getAssociatedObject(self, (__bridge const void *) GLNAVBAR_COMMAND_KEY);
    ;
}

- (void)setRequest:(GLJsRequest *)request
{
    objc_setAssociatedObject(self, (__bridge const void *) GLNAVBAR_COMMAND_KEY, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)navigationDict
{
    return objc_getAssociatedObject(self, (__bridge const void *) GLNAVBAR_DICT_KEY);
    ;
}

- (void)setNavigationDict:(NSMutableDictionary *)navigationDict
{
    objc_setAssociatedObject(self, (__bridge const void *) GLNAVBAR_DICT_KEY, navigationDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *) GLNAVBAR_COMMAND_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *) GLNAVBAR_DICT_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
