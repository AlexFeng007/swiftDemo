//
//  NetworkManager.h
//  FKY
//
//  Created by 夏志勇 on 2019/6/20.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCellularData.h>

#if NS_BLOCKS_AVAILABLE
typedef void(^ReturnBlock)(BOOL isOpen);
#endif


@interface NetworkManager : NSObject

@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL removing;

// 单例实例化
+ (instancetype)sharedInstance;

// 检测网络权限是否打开
- (void)checkNetworkStatus;

// 取消alert
- (void)dismissAlert;

@end
