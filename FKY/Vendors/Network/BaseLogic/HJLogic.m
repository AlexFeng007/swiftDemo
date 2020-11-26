//
//  HJLogic.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJLogic.h"

@interface HJLogic ()

@property (nonatomic, strong) HJOperationManager *operationManger;

@end


@implementation HJLogic

+ (id)logicWithOperationManager:(HJOperationManager *)aOperationManger;
{
    HJLogic *logic = [[self alloc] init];
    logic.operationManger = aOperationManger;
    logic.loading = NO;
    return logic;
}

- (void)dealloc
{
    //[self unobserveAllNotifications];
}

@end
