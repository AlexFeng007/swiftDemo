//
//  YWStubTarget.h
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//  桩对象，用于弱引用timer定时器的target，从而避免循环引用

#import <Foundation/Foundation.h>

@interface YWStubTarget : NSObject

@property (weak, nonatomic) NSTimer *weakTimer;
@property (weak, nonatomic) id weakTarget;
@property (assign, nonatomic) SEL weakSelector;

- (void)fireProxyTimer:(NSTimer *)userInfo;

@end
