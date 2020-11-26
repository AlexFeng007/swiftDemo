//
//  UIViewController+NetworkStatus.m
//  FKY
//
//  Created by 夏志勇 on 2018/6/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "UIViewController+NetworkStatus.h"
#import "RealReachability.h"
#import "Reachability.h"

@implementation UIViewController (networkStatus)

- (BOOL)checkNetworkStatus
{
//    AFNetworkReachabilityStatus networkStatus = [NetworkReachabilityManager networkReachabilityStatus];
//    if (networkStatus == AFNetworkReachabilityStatusNotReachable
//        || networkStatus == AFNetworkReachabilityStatusUnknown) {
//        // 无网络
//        return NO;
//    }
//    return YES;
    
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
//    if (status == RealStatusNotReachable) {
//        // 无网络
//        return NO;
//    }
//    return YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.163.com"];
    NetworkStatus status = reach.currentReachabilityStatus;
    if (status == NotReachable) {
        // 无网络
        return NO;
    }
    return YES;
}

- (void)showToastWhenNoNetwork
{
    if (![self checkNetworkStatus]) {
        // 无网络
        [self toast:@"网络不给力，请检查网络!"];
    }
}

@end
