//
//  GLJsRequest.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLJsRequest : NSObject

@property (nonatomic, readonly, copy) NSString *methodName; /* <js调用方法名 */
@property (nonatomic, readonly, copy) NSString *callbackId; /* <js调用回调方法的id */
@property (nonatomic, copy) NSDictionary *param;  /* <js调用附带参数 */

/**
 获得一个jsRequest实例

 @param url 符合规则的url，如gl://method?callid=xxx&param={}
 @return 实例
 */
+ (GLJsRequest *)jsRequestFromURL:(NSURL *)url;

/**
 取js端传入参数内容

 @param key 约定的key
 @return 对应值
 */
- (id)paramForKey:(NSString *)key;

@end
