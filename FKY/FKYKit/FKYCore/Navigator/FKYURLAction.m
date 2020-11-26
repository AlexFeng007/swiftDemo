//
//  FKYURLAction.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYURLAction.h"

@implementation FKYURLAction

+ (instancetype)actionWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.URL = URL;
        self.openHTTPURLInSafari = YES;
        self.animated = YES;
        self.isModal = NO;
        self.customTransition = YES;
    }
    return self;
}


@end
