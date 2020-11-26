//
//  FKYURLMap.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYURLMap.h"

@interface FKYURLMap ()
@property (nonatomic, copy) NSString *prefix;
@end

@implementation FKYURLMap

- (NSString *)prefix
{
    if (!_prefix) {
        _prefix = @"FKY";
    }
    return _prefix;
}

- (void)configPrefix:(NSString *)prefix
{
    self.prefix = prefix;
}

- (void)setMaps:(NSDictionary *)maps {
    // 把所有的key小写化
    NSMutableDictionary *dic = [@{} mutableCopy];
    [maps enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dic setObject:obj forKey:[key lowercaseString]];
    }];
    _maps = dic;
}

- (UIViewController *)viewControllerForURL:(NSURL *)URL
{
    Class class = [self viewControllerClassForURL:URL];
    if (class) {
        UIViewController *viewController = [[class alloc] init];
        return viewController;
    } else {
        return nil;
    }
}

- (UIViewController *)viewControllerForProtocol:(Protocol *)protocol
{
    Class class = [self viewControllerClassForProtocol:protocol];
    if (class) {
        UIViewController *viewController = [[class alloc] init];
        return viewController;
    } else {
        return nil;
    }
}

- (Class)viewControllerClassForURL:(NSURL *)URL
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", [self prefix], [URL lastPathComponent]];
    key = [key lowercaseString];
    if ([[self.maps allKeys] containsObject:key]) {
        Class viewControllerClass = self.maps[key];
        return viewControllerClass;
    } else {
        return nil;
    }
}

- (Class)viewControllerClassForProtocol:(Protocol *)protocol
{
    NSString *protocolName = NSStringFromProtocol(protocol);
    protocolName = [protocolName lowercaseString];
    if ([[self.maps allKeys] containsObject:protocolName]) {
        Class viewControllerClass = self.maps[protocolName];
        return viewControllerClass;
    } else {
        return nil;
    }
}



@end
