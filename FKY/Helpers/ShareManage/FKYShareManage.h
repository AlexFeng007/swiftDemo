//
//  FKYShareManage.h
//  FKY
//
//  Created by mahui on 2016/11/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKYShareManage : NSObject

// 测试环境APP账号 appzd01  apppf01  appsc01  这三个，密码：q123456

+  (BOOL)WXInstall;
+  (BOOL)QQInstall;
+  (BOOL)SinaInstall;

+ (void)shareToQQWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToQQZoneWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToWXWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToWXFriendWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToSinaWithOpenUrl:(NSString *)openUrl andMessage:(NSString *)message andImage:(NSString *)imageUrl;
// QQ纯文本
+ (void)shareToQQWithMessage:(NSString *)message;
+ (void)shareToQQWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToQQZoneWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;
/// 企业微信对话
+ (void)shareToQYWXWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;

+ (void)shareToWXWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;
//微信好友 分享文本
+ (void)shareToWXWithMessage:(NSString *)message;
+ (void)shareToWXFriendWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;
+ (void)shareToSinaWithOpenUrl:(NSString *)openUrl title:(NSString *)title andMessage:(NSString *)message andImage:(NSString *)imageUrl;

+ (void)shareToWechat:(NSDictionary *)dic;

// 图片压缩...<OC版>...<maxLength单位为m>
+ (NSData *)compressImage:(UIImage *)image withMaxLength:(double)maxLength;

@end
