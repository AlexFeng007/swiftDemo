//
//  GLBridge+Share.m
//  YYW
//
//  Created by Rabe on 28/02/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLBridge+Share.h"
#import "GLShareComponent.h"
#import "WWKApi.h"

static NSString *const kWeChatFriend = @"微信好友";
static NSString *const kWeChatZone = @"微信朋友圈";
static NSString *const kQQFriend = @"QQ好友";
static NSString *const kQZone = @"QQ空间";
static NSString *const kWeibo = @"微博";
static NSString *const kSMS = @"短信分享";
static NSString *const kCopy = @"复制内容";
static NSString *const kQYWXFriend = @"企业微信";

static NSString *GLSHARE_COMMAND_KEY = @"GLSHARE_COMMAND_KEY";

@implementation GLBridge (Share)

#pragma mark - public

/**
 分享
 
 gl://share?callid=11111&param={
 "title":"中药",                      //分享的标题
 "content":"可以用来养生",             //分享的内容
 "imgUrl":"https://eaifjfe.jpg",     //分享的小图标url
 "shareUrl":"https://www.baidu.com", //分享落地链接
 //wxfriend:微信好友 wxzone:微信朋友圈 qqfriend:qq好友  qqzone:qq空间
 //weibo:微博 sms:短信分享
 //按传值顺序传几个显示几个
 shareTypes:[
 "wxfriend",
 "qqfriend",
 "weibo"
 ]
 }
 
 callback({
 "callid":11111,
 "errcode":0,
 "errmsg":"ok",
 })
 
 */
 
- (void)share:(GLJsRequest *)request
{
    self.request = request;
    NSString *title = [request paramForKey:@"title"];
    if (title.length == 0) {
        title = @"分享";
    }
    NSString *content = [request paramForKey:@"content"];
    NSString *imgUrl = [request paramForKey:@"imgUrl"];
    NSString *shareUrl = [request paramForKey:@"shareUrl"];
    NSString *shareText = [request paramForKey:@"shareText"];//6.8.21加入新字段复制使用
    NSArray<NSString *> *shareTypes = [request paramForKey:@"shareTypes"];
    NSDictionary *shareinfo = [self shareinfoWithTypes:shareTypes];
    
    __weak typeof(self) weakself = self;
    [GLShareComponent showComponentWithTitles:shareinfo[@"titles"]
                                       images:shareinfo[@"images"]
                                      handler:^(NSString *type) {
        __strong typeof(weakself) self = weakself;
        if ([type isEqualToString:kWeChatFriend]) {
            // 微信好友分享
            NSString *type = [request paramForKey:@"type"];
            if (type && type.integerValue == 1) {
                // 小程序分享
                [self sendWechatShareInfo:request];
            }
            else {
                // 普通图文分享
                [self sendWXFriendReqWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
            }
            
            //[self sendWXFriendReqWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }
        else if ([type isEqualToString:kWeChatZone]) {
            [self sendWXZoneReqWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }
        else if ([type isEqualToString:kQQFriend]) {
            [self sendQQFriendReqWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }
        else if ([type isEqualToString:kQZone]) {
            [self sendQQZoneReqWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }
        else if ([type isEqualToString:kWeibo]) {
            [self sendWeiboWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }
        else if ([type isEqualToString:kSMS]) {
            [self sendSMSWithTitle:title content:content imgUrl:imgUrl shareUrl:shareUrl];
        }else if ([type isEqualToString:kCopy]){
            if (shareText != nil && shareText.length > 0){
                [[UIPasteboard generalPasteboard] setString:shareText];
            }else {
                [[UIPasteboard generalPasteboard] setString:shareUrl];
            }
            [FKYToast showToast:@"复制成功"];
        }else if ([type isEqualToString:kQYWXFriend]){
            /// 分享企业微信
            [self sendQYWXShareWithTitle:title andSummary:content andUrl:shareUrl andIconUrl:imgUrl];
            
        }
        else {
            NSLog(@"未知类型分享");
        }
        [self sendOkRespToJSWithData:nil callbackid:self.request.callbackId];
    }];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled: { // 用户取消传送
            break;
        }
        case MessageComposeResultFailed: { // 信息传送失败
            break;
        }
        case MessageComposeResultSent: { // 信息传送成功
            break;
        }
        default:
            break;
    }
}

#pragma mark - private

/// 企业微信分享
- (void)sendQYWXShareWithTitle:(NSString *)title andSummary:(NSString *)summary andUrl:(NSString *)url andIconUrl:(NSString *)iconUrl{
    if ([WWKApi isAppInstalled]) {
        //[FKYShareManage shareToWXWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
        [FKYShareManage shareToQYWXWithOpenUrl:url title:title andMessage:summary andImage:iconUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装企业微信客户端!"];
    }
}

// 微信好友分享之程序
- (void)sendWechatShareInfo:(GLJsRequest *)request
{
    // 取值
    NSString *title = [request paramForKey:@"title"];
    NSString *content = [request paramForKey:@"content"]; // description
    NSString *imgUrl = [request paramForKey:@"imgUrl"];
    NSString *shareUrl = [request paramForKey:@"shareUrl"]; // webpageUrl
    NSString *path = [request paramForKey:@"path"];
    NSString *userName = [request paramForKey:@"userName"];
    NSString *imgSmallUrl = [request paramForKey:@"imgSmallUrl"];
    
    // 入参
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (title && title.length > 0) {
        [dic setObject:title forKey:@"title"];
    }
    else {
        [dic setObject:@"分享" forKey:@"title"];
    }
    if (content && content.length > 0) {
        [dic setObject:content forKey:@"description"];
    }
    if (imgUrl && imgUrl.length > 0) {
        [dic setObject:imgUrl forKey:@"imgUrl"];
    }
    if (shareUrl && shareUrl.length > 0) {
        [dic setObject:shareUrl forKey:@"webpageUrl"];
    }
    if (path && path.length > 0) {
        [dic setObject:path forKey:@"path"];
    }
    if (userName && userName.length > 0) {
        [dic setObject:userName forKey:@"userName"];
    }
    else {
        [dic setObject:@"gh_317f53f9f8bb" forKey:@"userName"];
    }
    if (imgSmallUrl && imgSmallUrl.length > 0) {
        [dic setObject:imgSmallUrl forKey:@"imgSmallUrl"];
    }
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        // 分享
        [FKYShareManage shareToWechat:dic];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装微信客户端!"];
    }
    
    //[self.viewController BI_Record:@"product_yc_share_wechat"];
}

// 微信好友分享
- (void)sendWXFriendReqWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [FKYShareManage shareToWXWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装微信客户端!"];
    }
    //[self.viewController BI_Record:@"product_yc_share_wechat"];
}

// 微信朋友圈
- (void)sendWXZoneReqWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [FKYShareManage shareToWXFriendWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装微信客户端!"];
    }
    //[self.viewController BI_Record:@"product_yc_share_moments"];
}

// QQ好友分享
- (void)sendQQFriendReqWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [FKYShareManage shareToQQWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装QQ客户端!"];
    }
    //[self.viewController BI_Record:@"product_yc_qq"];
}

// QQ空间分享
- (void)sendQQZoneReqWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [FKYShareManage shareToQQZoneWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装QQ客户端!"];
    }
    //[self.viewController BI_Record:@"product_yc_qzone"];
}

// 微博分享
- (void)sendWeiboWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if ([WeiboSDK isWeiboAppInstalled]) {
        [FKYShareManage shareToSinaWithOpenUrl:shareUrl title:title andMessage:content andImage:imgUrl];
    }
    else {
        [self showAlertMessage:@"您的设备没有安装微博客户端!"];
    }
    // [self.viewController BI_Record:@"product_yc_weibo"];
}

// 短信分享
- (void)sendSMSWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl shareUrl:(NSString *)shareUrl
{
    if (![MFMessageComposeViewController canSendText]) {
        [self showAlertMessage:@"您的设备不支持短信功能，感谢您对1药城的支持!"];
    }
    else {
        MFMessageComposeViewController *msgVc = [[MFMessageComposeViewController alloc] init];
        msgVc.body = [NSString stringWithFormat:@"%@ %@", content, shareUrl];
        msgVc.messageComposeDelegate = self;
        if ([MFMessageComposeViewController canSendSubject]) {
            msgVc.subject = title;
        }
        if (self.viewController.presentedViewController == nil ) {
            //防止模态窗口错误
            [self.viewController presentViewController:msgVc animated:YES completion:nil];
            [[[[msgVc viewControllers] lastObject] navigationItem] setTitle:title];
        }
    }
}

- (void)showAlertMessage:(NSString *)msg
{
    NSString *str = [NSString stringWithFormat:@"\n%@", msg];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.contentMode = UIViewContentModeCenter;
    [alert show];
}

- (NSDictionary *)shareinfoWithTypes:(NSArray *)types
{
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    //    types = @[@"wxfriend", @"wxzone", @"qqfriend", @"qqzone", @"weibo", @"sms"]; // 测试代码
    [types enumerateObjectsUsingBlock:^(NSString *_Nonnull type, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([type isEqualToString:@"wxfriend"]) {
            [titles addObject:kWeChatFriend];
            [images addObject:@"wx_friend_snsBtn"];
        }
        else if ([type isEqualToString:@"wxzone"]) {
            [titles addObject:kWeChatZone];
            [images addObject:@"wx_zone_snsBtn"];
        }
        else if ([type isEqualToString:@"qqfriend"]) {
            [titles addObject:kQQFriend];
            [images addObject:@"qq_snsBtn"];
        }
        else if ([type isEqualToString:@"qqzone"]) {
            [titles addObject:kQZone];
            [images addObject:@"qq_zone_share"];
        }
        else if ([type isEqualToString:@"weibo"]) {
            [titles addObject:kWeibo];
            [images addObject:@"weibo_snsBtn"];
        }
        else if ([type isEqualToString:@"sms"]) {
            [titles addObject:kSMS];
            [images addObject:@"msg_snsBtn"];
        }else if ([type isEqualToString:@"copyContent"]){
            [titles addObject:kCopy];
            [images addObject:@"icon_copy_share"];
        }else if ([type isEqualToString:@"workwx"]){
            /// 企业微信
            [titles addObject:kQYWXFriend];
            [images addObject:@"QYWX_FX"];
        }
    }];
    return @{ @"titles" : titles,
              @"images" : images };
}

#pragma mark - property

- (GLJsRequest *)request
{
    return objc_getAssociatedObject(self, (__bridge const void *) GLSHARE_COMMAND_KEY);
    ;
}

- (void)setRequest:(GLJsRequest *)request
{
    objc_setAssociatedObject(self, (__bridge const void *) GLSHARE_COMMAND_KEY, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *) GLSHARE_COMMAND_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
