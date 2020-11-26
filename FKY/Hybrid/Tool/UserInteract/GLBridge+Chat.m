//
//  GLBridge+Chat.m
//  YYW
//
//  Created by Lily on 2017/7/28.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridge+Chat.h"

@implementation GLBridge (Chat)

/**
 打开小能聊天
 
 gl://openChat?callid=xx&param={
 "xnId":"yy234234_23423423"
 }
 
 callback({
 "callid":11111,
 "errcode":0,
 "errmsg":"ok",
 })
 
 */
- (void)openChat:(GLJsRequest *)request
{
//    NSString *groupID = STRING_FORMAT(@"%@",[request paramForKey:@"xnId"]);
//    
//    if (groupID.length>0) {
//        [[YWChatManager shareDataManager] enterChatViewWithItemID:@"" withGroupID:groupID];
//        
//        [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
//    }else{
//        [self sendWrongParamRespToJSWithCallbackid:request.callbackId];
//    }
}
@end
