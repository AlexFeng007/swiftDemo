//
//  SDWebImageManager+FKYManager.m
//  FKY
//
//  Created by yangyouyong on 2016/12/15.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "SDWebImageManager+FKYManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SDWebImageManager (FKYManager)

+ (void)load
{
    SEL selectors[] = {
        @selector(downloadImageWithURL:options:progress:completed:),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"fky_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (id<SDWebImageOperation>)fky_downloadImageWithURL:(NSURL *)url
                                           options:(SDWebImageOptions)options
                                          progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                         completed:(SDWebImageCompletionWithFinishedBlock)completedBlock
{
    NSString *httpsUrl = url.absoluteString;
    if ([httpsUrl hasPrefix:@"http://"]) {
        httpsUrl = [url.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
#if FKY_ENVIRONMENT_MODE != 1 // 非正式环境允许SSL加载图片，正式环境不可允许
    return [self fky_downloadImageWithURL:[NSURL URLWithString:httpsUrl]
                                  options:SDWebImageAllowInvalidSSLCertificates
                                 progress:progressBlock
                                completed:completedBlock];
#endif
    return [self fky_downloadImageWithURL:[NSURL URLWithString:httpsUrl]
                       options:options
                      progress:progressBlock
                     completed:completedBlock];
}

@end
