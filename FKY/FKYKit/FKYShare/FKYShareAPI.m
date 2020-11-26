//
//  FKYShareAPI.m
//  FKY
//
//  Created by yangyouyong on 16/2/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYShareAPI.h"
#import "FKYShareView.h"
#import "FKYShareView+FKYShareActions.h"
#import <Masonry/Masonry.h>

@implementation FKYShareAPI

+ (FKYShareView *)showShareViewWithURL:(NSURL *)url
                       title:(NSString *)title
                 description:(NSString *)description
            previewImageData:(NSData *)imageData
               completeBlock:(void (^)(BOOL success))combleteBlock {
    
    FKYShareView *shareView = [[FKYShareView alloc] init];
    shareView.url = url;
    shareView.title = title;
    shareView.descrip = description;
    shareView.previewImageData = imageData;
    @weakify(shareView);
    shareView.WXShareBlock = ^{
        @strongify(shareView);
        [shareView WXShareComplete:^(BOOL success) {
            safeBlock(combleteBlock,success);
        }];
    };

    shareView.WXFriendShareBlock = ^{
        @strongify(shareView);
        [shareView WXFriendShareComplete:^(BOOL success) {
            safeBlock(combleteBlock,success);
        }];
    };

    shareView.QQShareBlock = ^{
        @strongify(shareView);
        [shareView QQShareComplete:^(BOOL success) {
            safeBlock(combleteBlock,success);
        }];
    };
    
    shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIWindow *upperWindow = [UIApplication sharedApplication].windows.firstObject;
    [upperWindow addSubview:shareView];
    return shareView;
}

@end
