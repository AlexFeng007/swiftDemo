//
//  NSObject+Safe.h
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//  处理[unrecognized selector sent to instance 0x600001f90ae0]类型的crash
//  利用runtime在快速消息转发(forwardingTargetForSelector)中进行处理
//  消息转发时：selecter不变，改变instance及selector的impl实现；

#import <Foundation/Foundation.h>

#define kMaxZombieCacheCount 4
#define kZombieFreedCountPerTime 2

@interface NSObject (Safe)

@property (retain, nonatomic) id safe;
@property (assign, nonatomic) BOOL didRegisteredNotificationCenter;

@end
