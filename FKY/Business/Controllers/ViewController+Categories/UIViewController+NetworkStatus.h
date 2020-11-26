//
//  UIViewController+NetworkStatus.h
//  FKY
//
//  Created by 夏志勇 on 2018/6/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (networkStatus)

// 判断当前网络状态
- (BOOL)checkNetworkStatus;

// 无网络时显示toast
- (void)showToastWhenNoNetwork;

@end
