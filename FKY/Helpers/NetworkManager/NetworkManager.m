//
//  NetworkManager.m
//  FKY
//
//  Created by 夏志勇 on 2019/6/20.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager

static NetworkManager *networkManager = nil;

//+ (instancetype)sharedInstance
//{
//    @synchronized (self) {
//        if (networkManager == nil) {
//            networkManager = [[NetworkManager alloc] init];
//        }
//    }
//    return networkManager;
//}

// 实现创建单例对象的类方法
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[NetworkManager alloc] init];
    });
    return networkManager;
}


#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}


#pragma mark - Public

// 检测网络权限是否打开
- (void)checkNetworkStatus
{
    [self openEventServiceWithBolck:^(BOOL isOpen) {
        if (isOpen) {
            NSLog(@"蜂窝网络权限已打开");
            [self dismissAlert];
        }
        else {
            NSLog(@"蜂窝网络权限未打开");
            
            // 需进一步判断有无WiFi网络
            if ([self getNetworkStatus] != 0) {
                NSLog(@"当前有WiFi or 未知状态");
                [self dismissAlert];
                return;
            }
            
            NSLog(@"当前无网络<蜂窝网络&WiFi>");
            
            // 显示
            CGFloat time = 0.2;
            if (self.alert && self.visible) {
                time = 0.4;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self showAlert];
            });
        }
    }];
}

// 取消alert
- (void)dismissAlert
{
    if (self.removing) {
        return;
    }
    
    if (self.alert && self.visible) {
        self.removing = YES;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.alert dismissViewControllerAnimated:NO completion:^{
                @strongify(self);
                self.visible = NO;
                self.removing = NO;
            }];
        });
        
    }
}


#pragma mark - Private

// 显示alert
- (void)showAlert
{
    if (kAppDelegate.tabBarController.presentedViewController) {
        return;
    }
    
    // 初始化
    self.alert = [UIAlertController alertControllerWithTitle:@"已为\"1药城\"关闭网络权限" message:@"您可以在\"设置\"中为此应用打开网络权限" preferredStyle:UIAlertControllerStyleAlert];
    // 取消
    [self.alert addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        //
        self.visible = NO;
    }])];
    // 确认
    [self.alert addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        //
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        self.visible = NO;
    }])];
    // 弹出
    self.removing = NO;
    [kAppDelegate.tabBarController presentViewController:self.alert animated:YES completion:^{
        //
        self.visible = YES;
    }];
}

// 获取当前网络状态
- (NSInteger)getNetworkStatus
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable: {
            // @"不可达的网络";
            return 0;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            // @"运营商网络";
            return 1;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            // @"WiFi";
            return 2;
        }
        default: {
            // @"未识别的网络";
            return -1;
        }
    }
}

// 获取蜂窝权限开启状态
- (void)openEventServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            // 权限未知 or 蜂窝权限开启
            if (returnBolck) {
                returnBolck(YES);
            }
        } else {
            // 两种情况:[蜂窝权限被关闭，有WiFi权限 or 蜂窝权限被关闭，无WiFi权限]
            if (returnBolck) {
                returnBolck(NO);
            }
        }
    };
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
        // 权限未知 or 蜂窝权限开启
        if (returnBolck) {
            returnBolck(YES);
        }
    } else {
        // 两种情况:[蜂窝权限被关闭，有WiFi权限 or 蜂窝权限被关闭，无WiFi权限]
        if (returnBolck) {
            returnBolck(NO);
        }
    }
#endif
}


@end
