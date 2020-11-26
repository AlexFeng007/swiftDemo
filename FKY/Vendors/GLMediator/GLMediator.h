//
//  GLMediator.h
//  YYW
//
//  Created by Rabe on 2017/3/6.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMediator : NSObject

/**
 单例
 */
+ (instancetype)sharedInstance;
/**
 远程App调用入口
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
/**
 本地组件调用入口
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
/**
 清理缓存模块对象
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
