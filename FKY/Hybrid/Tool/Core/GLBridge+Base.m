//
//  GLBridge+Base.m
//  YYW
//
//  Created by Rabe on 27/02/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLBridge+Base.h"
//#import "GLCookieSyncManager.h"
#import "GLErrorVC.h"
//#import "WUCache.h"
#import "NSString+UrlEncode.h"

static NSString *const hybridAppStorageFilePath = @"HybridAppStorage";

@implementation GLBridge (Base)

#pragma mark - public

/**
 容器刷新当前界面
 
 gl://reloadPage?callid=11111&param={}
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
 })
 
 */
- (void)reloadPage:(GLJsRequest *)request
{
    [(GLWebVC *) self.viewController reloadPage];
    [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
}


/**
 容器刷新本地错误页面，加载初始urlPath
 该接口为本地接口，不提供给Js，当然Js也可以调用
 */
- (void)reloadErrorPage:(GLJsRequest *)request
{
    NSString *urlPath = [(GLErrorVC *) self.viewController urlPath];
    NSURL *url = [NSURL URLWithString:[urlPath urlDecode]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    GLWebVC *parentVc = (GLWebVC *) self.viewController.parentViewController;
    [parentVc.webViewEngine loadRequest:req];
}

/**
 增加、改动、删除appStorage  方便网页之间跨容器传递数据用。
 isPersistence--false 数据存放于内存中，重启app后消失。
 isPersistence--true 数据持久化到硬盘中，重启app后仍存在。
 当map里的value为空字符串时，表示删除。
 
 gl://updateAppStorage?callid=11111&param={
    "key":"a",
    "value":1111   //当值为空字符串时，表示删除
    "isPersistence":false   //是否持久化,内存的和持久化的独立处理，默认false
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
 })
 */
- (void)updateAppStorage:(GLJsRequest *)request
{
//    NSString *key = [request paramForKey:@"key"];
//    
//    if ([key isKindOfClass:NSString.class]) {
//        key = [key stringByRemovingPercentEncoding];
//    }
//    id val = [request paramForKey:@"value"];
//
//    if (key.length == 0) { // 无效指令
//        [self sendWrongParamRespToJSWithCallbackid:request.callbackId];
//        return;
//    }
//    
//    NSMutableDictionary *appStorage = [HJGlobalValue sharedInstance].appStorage;
//    BOOL isPersistence = [[request paramForKey:@"isPersistence"] boolValue];
//    if (isPersistence) {
//        appStorage = [[WUCache getCachedObjectForFile:hybridAppStorageFilePath] mutableCopy];
//        appStorage = appStorage ? : [[NSMutableDictionary alloc] init];
//    }
//    if ([val isKindOfClass:NSString.class] && [val length] == 0) { // 删除
//        [appStorage removeObjectForKey:key];
//    }
//    else { // 增加或更新
//        [appStorage setValue:val forKey:key];
//    }
//    [WUCache cacheObject:appStorage toFile:hybridAppStorageFilePath];
//    [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
}

/**
 删除所有appStorage
 
 gl://removeAllAppStorage?callid=11111&param={
    "isPersistence":false   //是否持久化,内存的和持久化的独立处理，默认false
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
 })
 */
- (void)removeAllAppStorage:(GLJsRequest *)request
{
//    BOOL isPersistence = [[request paramForKey:@"isPersistence"] boolValue];
//    if (isPersistence) {
//        [WUCache removeCacheFile:hybridAppStorageFilePath];
//    }
//    else {
//        NSMutableDictionary *appStorage = [HJGlobalValue sharedInstance].appStorage;
//        [appStorage removeAllObjects];
//    }
//    
//    [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
}

/**
 查询appStorage
 
 gl://queryAppStorage?callid=11111&param={
    "key":"a"        //查询key对应的值的value
    "isPersistence":false   //是否持久化,内存的和持久化的独立处理，默认false
 }
 
 callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok",
    "data":{
        "value":11111
    }
 })
 */
- (void)queryAppStorage:(GLJsRequest *)request
{
//    NSString *key = [request paramForKey:@"key"];
//    
//    if (key.length == 0) { // 无效指令
//        [self sendWrongParamRespToJSWithCallbackid:request.callbackId];
//        return;
//    }
//    
//    NSMutableDictionary *appStorage = [HJGlobalValue sharedInstance].appStorage;
//    BOOL isPersistence = [[request paramForKey:@"isPersistence"] boolValue];
//    if (isPersistence) {
//        appStorage = [[WUCache getCachedObjectForFile:hybridAppStorageFilePath] mutableCopy];
//        appStorage = appStorage ? : [[NSMutableDictionary alloc] init];
//    }
//    id val = [appStorage objectForKey:key];
//    val = val ?: @"";
//    [self sendOkRespToJSWithData:@{ @"value" : val } callbackid:request.callbackId];
}

@end
