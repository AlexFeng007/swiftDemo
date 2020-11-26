//
//  FKYURLMap.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYURLMap : NSObject

@property (nonatomic, strong) NSDictionary *maps;

- (NSString *)prefix;
- (void)configPrefix:(NSString *)prefix;

- (UIViewController *)viewControllerForURL:(NSURL *)URL;
- (UIViewController *)viewControllerForProtocol:(Protocol *)protocol;
- (Class)viewControllerClassForURL:(NSURL *)URL;
- (Class)viewControllerClassForProtocol:(Protocol *)protocol;

@end
