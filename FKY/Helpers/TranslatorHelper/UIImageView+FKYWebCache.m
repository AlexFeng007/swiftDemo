//
//  UIImageView+FKYWebCache.m
//  FKY
//
//  Created by yangyouyong on 2016/12/15.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "UIImageView+FKYWebCache.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (FKYWebCache)

+ (void)load {
    SEL selectors[] = {
        @selector(sd_setImageWithURL:),
        @selector(sd_setImageWithURL:placeholderImage:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"fky_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)fky_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    NSString *httpsUrl = url.absoluteString;
    if ([httpsUrl hasPrefix:@"http://"]) {
        httpsUrl = [url.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    [self fky_sd_setImageWithURL:[NSURL URLWithString:httpsUrl] placeholderImage:placeholder];
}

- (void)fky_sd_setImageWithURL:(NSURL *)url {
    NSString *httpsUrl = url.absoluteString;
    if ([httpsUrl hasPrefix:@"http://"]) {
        httpsUrl = [url.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    [self fky_sd_setImageWithURL:[NSURL URLWithString:httpsUrl]];
}

@end
