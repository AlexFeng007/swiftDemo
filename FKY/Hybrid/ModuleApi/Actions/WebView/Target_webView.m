//
//  Target_webView.m
//  YYW
//
//  Created by Rabe on 23/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "Target_webView.h"
#import "NSDictionary+GLParam.h"

@implementation Target_webView

- (id)Action_jsFetchWebViewController:(NSDictionary *)params
{
    NSString *urlString = [params paramForKey:@"url" defaultValue:nil class:NSString.class];
    if (!urlString.length) {
        return nil;
    }

    GLWebVC *vc = [[GLWebVC alloc] init];
    vc.urlPath = urlString;
    BOOL navBarVisible = [params boolParamForKey:@"showNavigation" defaultValue:NO];        //为true表示显示默认导航，默认false
    if (navBarVisible) {
        vc.barStyle = FKYBarStyleWhite;
        NSString *title = [params paramForKey:@"title" defaultValue:nil class:NSString.class];
        vc.title = title;
    } else {
        vc.barStyle = FKYBarStyleNotVisible;
    }
    return vc;
}

- (id)Action_nativeFetchHybridTestWebViewController:(NSDictionary *)params
{
    GLWebVC *vc = [[GLWebVC alloc] init];
    vc.urlPath = @"https://yhycstatic.yaoex.com/js/ycjsBridge/demo.html";
    return vc;
}

@end
