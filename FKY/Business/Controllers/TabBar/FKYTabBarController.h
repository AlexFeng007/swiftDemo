//
//  FKYRootViewController.h
//  FKY
//
//  Created by yangyouyong on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYTabBarSchemeProtocol.h"
#import <RDVTabBarController/RDVTabBarController.h>
#import "FKYVipDetailModel.h"


@interface FKYTabBarController : RDVTabBarController <FKY_TabBarController>

@property (nonatomic, assign, readonly) CGFloat tabbarHeight;

+ (FKYTabBarController *)shareInstance;

- (void)checkUpdate;
- (void)syncCartBadgeNumber;
- (void)setTabbarVipBadgeValue:(FKYVipDetailModel *)vipModel;//刷新角标vip
- (void)setTabbarVipBadgeValueForAcount:(BOOL)isVip;//刷新角标vip
- (void)resetVipTag:(NSInteger)index;//更新vip角标选中状态

@end
