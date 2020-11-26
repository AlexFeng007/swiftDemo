//
//  FKYHooker.m
//  FKY
//
//  Created by Rabe on 02/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "FKYHooker.h"
#import <Aspects/Aspects.h>

@implementation FKYHooker

+ (void)hook {
    [self hookWeb];
}

+ (void)hookWeb {
    // WK走的是WebKit，所以需要单独hook，如果使用swift，需要在代码里侵入式写代码
    [[WKWebView class] aspect_hookSelector:@selector(webView:didFailProvisionalNavigation:withError:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSArray *args = aspectInfo.arguments;
        NSURL *url = [(WKWebView *)aspectInfo.instance URL];
        NSError *error = [args objectAtIndex:2];
        [WUMonitorInstance saveWebLoadingError:url.absoluteString error:error];
    } error:nil];
    [[WKWebView class] aspect_hookSelector:@selector(webView:didFailNavigation:withError:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSArray *args = aspectInfo.arguments;
        NSURL *url = [(WKWebView *)aspectInfo.instance URL];
        NSError *error = [args objectAtIndex:2];
        [WUMonitorInstance saveWebLoadingError:url.absoluteString error:error];
    } error:nil];
}

@end
