//
//  FKYWebpImageHooker.m
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "UIImageView+FKYWebpImageHooker.h"
#import <Aspects/Aspects.h>

@implementation UIImageView (FKYWebpImageHooker)

+ (void)load
{
    Method origMethod = class_getInstanceMethod(self.class, NSSelectorFromString(@"sd_setImageWithURL:placeholderImage:options:progress:completed:"));
    Method altMethod = class_getInstanceMethod(self.class, NSSelectorFromString(@"fky_sd_setImageWithURL:placeholderImage:options:progress:completed:"));
    method_exchangeImplementations(origMethod, altMethod);
}

- (void)fky_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    NSString *webpSuffix = @"x-oss-process=image/format,webp";
    if ([url.absoluteString hasSuffix:webpSuffix]) {
        // 有此后缀
        [self fky_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil && [imageURL.absoluteString hasSuffix:webpSuffix]) {
                // webp图片下载失败，拦截写入错误日志
                [WUMonitorInstance saveImageDownloadError:url.absoluteString];
            }
            if (completedBlock) {
                completedBlock(image, error, cacheType, imageURL);
            }
        }];
    } else {
        // 无此后缀
        if ([url.absoluteString containsString:@"?"]) {
            // 包含?，用&拼接
            webpSuffix = [@"&" stringByAppendingString:webpSuffix];
        }
        else {
            // 不包含?，用?拼接
            webpSuffix = [@"?" stringByAppendingString:webpSuffix];
        }
        NSString *urlString = [url.absoluteString stringByAppendingString:webpSuffix];
        NSURL *__url = [NSURL URLWithString:urlString];
        [self fky_sd_setImageWithURL:__url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil && [imageURL.absoluteString hasSuffix:webpSuffix]) {
                // webp图片下载失败，拦截写入错误日志
                [WUMonitorInstance saveImageDownloadError:url.absoluteString];
            }
            if (completedBlock) {
                completedBlock(image, error, cacheType, imageURL);
            }
        }];
    }
}


@end

