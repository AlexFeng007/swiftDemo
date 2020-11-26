//
//  FKYShareManage.m
//  FKY
//
//  Created by mahui on 2016/11/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYShareManage.h"
#import "AppDelegate.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "UIImage+Resize.h"
#import "FKY-Swift.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "WWKApi.h"


@implementation FKYShareManage

#pragma mark - Image

// 获取分享图片...<此处图片大小固定设置为30k，小于微信的32k>
+ (void)imageWithUrlString:(NSString *)urlString success:(void(^)(NSData *imageData))successBlock
{
    if (urlString && urlString.length > 0) {
        // url不为空
        NSLog(@"share img url:%@", urlString);
        
        UIImageView *imgviewTemp = [[UIImageView alloc] init];
        [imgviewTemp sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                NSLog(@"img download success~@#");
                NSData *imgData = [FKYShareManage compressImage:image withMaxLength:0.03];
                safeBlock(successBlock, imgData);
            }
            else {
                NSLog(@"img download fail~@#");
                UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
                NSData *data = [FKYShareManage compressImage:img withMaxLength:0.03];
                safeBlock(successBlock, data);
            }
        }];
    }
    else {
        // url为空...<使用本地默认图片>
        UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
        NSData *data = [FKYShareManage compressImage:img withMaxLength:0.03];
        safeBlock(successBlock, data);
    }
}

// 获取分享图片...<微博分享的真实图片大小，此处设置为2m>
+ (void)imageWithUrlString:(NSString *)urlString forImageLength:(double)maxLength success:(void(^)(NSData *imageData))successBlock
{
    if (urlString && urlString.length > 0) {
        // url不为空
        NSLog(@"share img url:%@", urlString);
        
        // 阻塞主线程
//        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//        UIImage *image = [UIImage imageWithData:data];
//        NSData *imgData = [FKYShareManage compressImage:image withMaxLength:maxLength];
//        safeBlock(successBlock, imgData);
        
        // 异步下载
        UIImageView *imgviewTemp = [[UIImageView alloc] init];
        [imgviewTemp sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                NSLog(@"img download success~@#");
                NSData *imgData = [FKYShareManage compressImage:image withMaxLength:maxLength];
                safeBlock(successBlock, imgData);
            }
            else {
                NSLog(@"img download fail~@#");
                UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
                NSData *data = [FKYShareManage compressImage:img withMaxLength:maxLength];
                safeBlock(successBlock, data);
            }
        }];
    }
    else {
        // url为空...<使用本地默认图片>
        UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
        NSData *data = [FKYShareManage compressImage:img withMaxLength:maxLength];
        safeBlock(successBlock, data);
    }
}

// 图片压缩...<OC版>...<maxLength单位为m>
// 微信分享图片大小限制为32k
+ (NSData *)compressImage:(UIImage *)image withMaxLength:(double)maxLength
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    // 若传0，则表示图片无需压缩
    if (maxLength <= 0) {
        return data;
    }
    // 当前图片小于等于限制大小，不压缩，直接返回
    if (data.length <= 1024 * 1024 * maxLength) {
        return data;
    }
    
    // 1. 先压质量...<0.9>...<简单的用0.9压一下，压缩后的实际图片大小比0.9倍原图要小得多，但显示效果差别不大>
    NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
    // 2. 再压尺寸
    NSData *compressData = imgData; // 当前图片data
    
    // 若当前图片大小是限制大小的2位以上
    while (compressData.length >= 1024 * 1024 * maxLength * 2) {
        // 转图片
        UIImage *compressImage = [[UIImage alloc] initWithData:compressData];
        // 压缩一半...<0.7 * 0.7 = 0.49 约等于0.5>
        UIImage *img = [compressImage imageScaleDown:0.7];
        // img转data
        compressData = UIImageJPEGRepresentation(img, 1.0);
        NSLog(@"[compress half]+++");
    } // while
    
    // 若当前图片大小是限制大小的2位以上
    while (compressData.length > 1024 * 1024 * maxLength) {
        // 转图片
        UIImage *compressImage = [[UIImage alloc] initWithData:compressData];
        // 压缩一点...<0.9 * 0.9 = 0.81 约等于0.8>
        UIImage *img = [compressImage imageScaleDown:0.9];
        // img转data
        compressData = UIImageJPEGRepresentation(img, 1.0);
        NSLog(@"[compress]+++");
    } // while
    
    return compressData;
}


#pragma mark -

+ (BOOL)QQInstall
{
    BOOL result = [QQApiInterface isQQInstalled];
    return result;
}

+ (BOOL)WXInstall
{
    BOOL result = [WXApi isWXAppInstalled];
    return result;
}

+  (BOOL)SinaInstall
{
    BOOL result = [WeiboSDK isWeiboAppInstalled];
    return result;
}

+ (NSString *)des
{
    return @"1药城为你精心推荐";
}


#pragma mark - ShareAction

// QQ
+ (void)shareToQQWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    return [self shareToQQWithOpenUrl:openUrl title:message andMessage:[self des] andImage:imageUrl];
}

// QQ空间
+ (void)shareToQQZoneWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    return [self shareToQQZoneWithOpenUrl:openUrl title:message andMessage:[self des] andImage:imageUrl];
}

// 微信好友
+ (void)shareToWXWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    return [self shareToWXWithOpenUrl:openUrl title:message andMessage:[self des] andImage:imageUrl];
}

// 微信朋友圈
+ (void)shareToWXFriendWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    return [self shareToWXFriendWithOpenUrl:openUrl title:message andMessage:[self des] andImage:imageUrl];
}

// (新浪)微博
+ (void)shareToSinaWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    return [self shareToSinaWithOpenUrl:openUrl title:[self des] andMessage:message andImage:imageUrl];
}


#pragma mark - ShareMethod

// QQ
+ (void)shareToQQWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:openUrl];
    [FKYShareManage imageWithUrlString:imageUrl success:^(NSData *imageData) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            QQApiNewsObject *ob = [QQApiNewsObject objectWithURL:url title:title description:message previewImageData:imageData];
            SendMessageToQQReq *qq = [SendMessageToQQReq reqWithContent:ob];
            [QQApiInterface sendReq:qq];
        });
    }];
    //[[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode":@"share_yc"} eventId:nil];
}
// QQ纯文本
+ (void)shareToQQWithMessage:(NSString *)message
{
   dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:message];
        SendMessageToQQReq *qq = [SendMessageToQQReq reqWithContent:txtObj];
        [QQApiInterface sendReq:qq];
    });
}
// QQ空间
+ (void)shareToQQZoneWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:openUrl];
    [FKYShareManage imageWithUrlString:imageUrl success:^(NSData *imageData) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:url title:title description:message previewImageData:imageData];
            [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
            QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
            NSLog(@"code:%d", code);
        });
    }];
     //[[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode":@"share_yc"} eventId:nil];
}

/// 企业微信对话
+ (void)shareToQYWXWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    NSLog(@"shareToWX~!@");
    [FKYShareManage imageWithUrlString:imageUrl success:^(NSData *imageData) {
        WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
        WWKMessageLinkAttachment *attachment = [[WWKMessageLinkAttachment alloc] init];
        // 示例用链接，请填写你想分享的实际链接的标题、介绍、图标和URL
        attachment.title = title;
        attachment.summary = message;
        attachment.url = openUrl;
        attachment.icon = imageData;
        req.attachment = attachment;
        [WWKApi sendReq:req];
    }];
}

// 微信好友
+ (void)shareToWXWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    NSLog(@"shareToWX~!@");
    [FKYShareManage imageWithUrlString:imageUrl success:^(NSData *imageData) {
        //
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = openUrl;
        
        //
        WXMediaMessage *ms = [WXMediaMessage message];
        ms.title = title;
        ms.description = message;
        [ms setThumbImage:[UIImage imageWithData:imageData]];
        ms.mediaObject = ext;
        
        //
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = ms;
        req.scene = WXSceneSession;
        [WXApi sendReq:req completion:nil];
    }];
    
    //[[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode":@"share_yc"} eventId:nil];
}
//微信好友 分享文本
+ (void)shareToWXWithMessage:(NSString *)message
{
    NSLog(@"shareToWX~!@");
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text                = message;
    req.bText               = YES;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    req.scene               = WXSceneSession;
    [WXApi sendReq:req completion:nil];
}
// 微信好友之小程序分享
+ (void)shareToWechat:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    
    //
    WXMiniProgramObject *ext = [[WXMiniProgramObject alloc] init];
    ext.webpageUrl = dic[@"webpageUrl"]; //兼容低版本的网页链接
    ext.userName = (dic[@"userName"] ? dic[@"userName"] : @"gh_317f53f9f8bb"); //小程序的原始id: gh_317f53f9f8bb
    ext.path = dic[@"path"]; //小程序页码的路径
    ext.withShareTicket = YES;
    ext.miniProgramType = WXMiniProgramTypeRelease; //小程序的发版类型
    NSString *imgUrl = dic[@"imgUrl"];
    if (imgUrl && imgUrl.length > 0) {
        // 小程序节点高清图（小于128k）
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        UIImage *img = [UIImage imageWithData:imageData];
        NSData *imgData = [FKYShareManage compressImage:img withMaxLength:0.128];
        ext.hdImageData = imgData;
    }
    else {
        // 无图时用默认图片
        UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
        NSData *imgData = [FKYShareManage compressImage:img withMaxLength:0.128];
        ext.hdImageData = imgData;
    }
    //
    WXMediaMessage *ms = [WXMediaMessage message];
    ms.title = (dic[@"title"] ? dic[@"title"] : @"1药城分享"); // 标题不能为空
    ms.description = dic[@"description"];
    ms.mediaObject = ext;
    NSString *thumbImageUrl = dic[@"imgSmallUrl"];
    if (thumbImageUrl && thumbImageUrl.length > 0) {
        // 兼容旧版本节点图片（小于32k）新版本优先使用hdImageData属性
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
        UIImage *img = [UIImage imageWithData:imageData];
        NSData *imgData = [FKYShareManage compressImage:img withMaxLength:0.03];
        ms.thumbData = imgData;
    }
//    else {
//        // 无图时用默认图片
//        UIImage *img = [UIImage imageNamed:@"icon_account_logo"];
//        NSData *imgData = [FKYShareManage compressImage:img withMaxLength:0.03];
//        ms.thumbData = imgData;
//    }
    //
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = ms;
    req.scene = WXSceneSession;
    @weakify(self);
    [WXApi sendReq:req completion:nil];
//    [WXApi sendReq:req completion:^(BOOL success){
//        @strongify(self);
//       // [self shouldHandleShareResultBlock:success completeBlock:completeBlock];
//    }];
   // [WXApi sendReq:req completion:nil];
    
    // 埋点
    //[[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode":@"share_yc"} eventId:nil];
}

// 微信朋友圈
+ (void)shareToWXFriendWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    [FKYShareManage imageWithUrlString:imageUrl success:^(NSData *imageData) {
        //
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = openUrl;
        
        //
        WXMediaMessage *mm = [WXMediaMessage message];
        mm.title = title;
        mm.description = message;
        [mm setThumbImage:[UIImage imageWithData:imageData]];
        mm.mediaObject = ext;
        
        //
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = mm;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req completion:nil];
    }];
    // [[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode":@"share_yc"} eventId:nil];
}

// (新浪)微博
+ (void)shareToSinaWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl
{
    [FKYShareManage imageWithUrlString:imageUrl forImageLength:2.0 success:^(NSData *imageData) {
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        authRequest.scope = @"all";
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShareWithUrl:openUrl title:title andMessage:message andImage:imageData] authInfo:authRequest access_token:[kAppDelegate getWeiboToken]];
        request.userInfo = @{@"ShareMessageFrom": @"YHYC",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }];
    
    //[[FKYAnalyticsManager sharedInstance] BI_Record:nil extendParams:@{@"pagecode": @"share_yc"} eventId:nil];
}


#pragma mark - Weibo

+ (WBMessageObject *)messageToShareWithUrl:(NSString *)url andMessage:(NSString *)title  andImage:(NSData *)imageData
{
    return [self messageToShareWithUrl:url title:[self des] andMessage:title andImage:imageData];
}

+ (WBMessageObject *)messageToShareWithUrl:(NSString *)url title:(NSString *)title andMessage:(NSString *)amessage  andImage:(NSData *)imageData
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = [NSString stringWithFormat:@"%@\n%@\n%@\n",title,amessage,url];
    WBImageObject *imgOb = [WBImageObject object];
    imgOb.imageData = imageData;
    message.imageObject = imgOb;
    
    return message;
}


@end
