//
//  GLMediator.m
//  YYW
//
//  Created by Rabe on 2017/3/6.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLMediator.h"

@interface GLMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end


@implementation GLMediator

#pragma mark - life cycle

+ (instancetype)sharedInstance
{
    static GLMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[GLMediator alloc] init];
    });
    return mediator;
}

#pragma mark - public

/**
 远程App调用入口 scheme://target/action?params
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *info))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = url.query;
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elements = [param componentsSeparatedByString:@"="];
        if (elements.count < 2) {
            continue;
        }
        [params setObject:elements.lastObject forKey:elements.firstObject];
    }

    // 增加path校验，防止黑客通过远程方式调用本地模块，此处可自定义更严谨的逻辑
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return nil;
    }

    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{ @"result" : result });
        }
        else {
            completion(nil);
        }
    }
    return result;
}

/**
 本地组件调用入口
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass;

    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }

    SEL action = NSSelectorFromString(actionString);

    if (target == nil) {
        // TODO: 处理无响应请求,此处没有可以响应的target，就直接return了，可以考虑给一个固定的target专门用于在这个时候顶上，然后处理这种请求
        return nil;
    }

    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    else {
        // TODO: 处理无响应请求，尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        }
        else {
            // TODO: 处理无响应请求，在notFound都没有的时候，此处直接return了。后期可考虑用前面提到的固定的target顶上
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

/**
 清理缓存模块对象
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - property

- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end
