//
//  HJNetworkManager.h
//  HJFramework
//  功能:网络管理
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJOperationManager;

@interface HJNetworkManager : NSObject

AS_SINGLETON(HJNetworkManager)

/**
 *  功能:产生一个operation manager,当owner销毁的时候一并销毁HJOperationManager
 */
- (HJOperationManager *)generateOperationMangerWithOwner:(id)owner;

/**
 *  功能:移除operation manager
 */
- (void)removeOperationManger:(HJOperationManager *)aOperationManager;

@end
