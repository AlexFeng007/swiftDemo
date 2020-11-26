//
//  FKYShareView+FKYShareActions.m
//  FKY
//
//  Created by yangyouyong on 16/2/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYShareView+FKYShareActions.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

static NSString *staticTitle = @"批发方便、快捷、服务第一的药品就上1药城";

@implementation FKYShareView (FKYShareActions)

- (void) QQShareComplete:(void(^)(BOOL success))completeBlock {
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:self.url
                                                    title:self.title
                                              description:self.descrip
                                         previewImageData:self.previewImageData];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode resultCode = [QQApiInterface sendReq:req];
    BOOL isSuccess = resultCode == EQQAPISENDSUCESS;
    
    [self shouldHandleShareResultBlock:isSuccess
                         completeBlock:completeBlock];
}

- (void) WXShareComplete:(void(^)(BOOL success))completeBlock {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.descrip;
    [message setThumbImage:[UIImage imageWithData:self.previewImageData]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.url.absoluteString;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    @weakify(self);
    [WXApi sendReq:req completion:^(BOOL success){
        @strongify(self);
        [self shouldHandleShareResultBlock:success completeBlock:completeBlock];
    }];
}

- (void) WXFriendShareComplete:(void(^)(BOOL success))completeBlock {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.descrip;
    [message setThumbImage:[UIImage imageWithData:self.previewImageData]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.url.absoluteString;;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    @weakify(self);
    [WXApi sendReq:req completion:^(BOOL success){
        @strongify(self);
        [self shouldHandleShareResultBlock:success completeBlock:completeBlock];
    }];
}

- (void)shouldHandleShareResultBlock:(BOOL)shouldBe
                       completeBlock:(void(^)(BOOL success))completeBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dismissBlock();
        safeBlock(completeBlock,shouldBe);
    });
}

@end
