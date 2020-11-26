//
//  GLBridge+Share.h
//  YYW
//
//  Created by Rabe on 28/02/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLBridge.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface GLBridge (Share) <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) GLJsRequest *request;

- (void)share:(GLJsRequest *)request;
@end
