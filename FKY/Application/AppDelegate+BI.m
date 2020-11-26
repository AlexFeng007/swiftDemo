//
//  AppDelegate+BI.m
//  FKY
//
//  Created by yangyouyong on 2016/12/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "AppDelegate+BI.h"
#import <Aspects/Aspects.h>

#import "FKYSearchViewController.h"
#import "FKYProductionDetailViewController.h"
//#import "FKYPaySuccessViewController.h"
#import "FKYSetUpViewController.h"
//#import "FKYAccountViewController.h"
#import "FKYAllOrderViewController.h"
#import "FKYRefuseListViewController.h"
#import "FKYOrderDetailViewController.h"
#import "FKYJSOrderDetailViewController.h"
#import "NSArray+Block.h"
#import <UIKit/UIKit.h>


@implementation AppDelegate (BI)

- (void)configBI
{
    [[UIViewController class] aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        NSLog(@"%@ [viewWillAppear]", aspectInfo.instance);
        [[FKYAnalyticsManager sharedInstance] BI_InViewController:aspectInfo.instance];
	} error:nil];
	
	[[UIViewController class] aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        NSLog(@"%@ [viewWillDisappear]", aspectInfo.instance);
        [[FKYAnalyticsManager sharedInstance] BI_OutViewController:aspectInfo.instance];
    } error:nil];
}

//- (BOOL)viewControllisBI:(UIViewController *)vc
//{
//    //拦截掉在主控制器中添加的子控制器（子控制会导致BI_OutViewController方法调用覆盖掉主控制器的pagecode）
//	NSArray *BIControllers = @[@"UICompatibilityInputViewController",
//                               @"FKYNavigationController",
//                               @"FKYTabBarController",
//                               @"UIInputWindowController",
//                               @"FKY.SearchOftenBuyController",
//                               @"FKY.HomeMainController",
//                               @"FKY.HomeMainOftenBuyController",
//                               @"FKYProductionBaseInfoController",
//                               @"FKYProductionInstructionController",
//                               @"UIKeyboardCandidateGridCollectionViewController",
//                               @"FKY.COInputController",
//                               @"FKY.RCPopController",
//                               @"FKY.PDComboVC",
//                               @"FKY.FKYAddCarViewController",
//                               @"FKY.PDFixedComboFailVC",
//                               @"FKY.PDDiscountPriceInfoVC",
//                               @"FKY.COFrightRuleListController",
//                               @"FKYShowSaleInfoViewController",
//                               @"FKY.PDShareStockTipVC",
//                               @"FKY.FKYFactoryFliterForSearchResultVC",
//                               @"FKY.FKYPopComCouponVC",
//                               @"GLViewController"];
//	for (NSString *vcStr in BIControllers) {
//		if ([vc isKindOfClass:NSClassFromString(vcStr)]) {
//			return NO;
//		}
//	}
//	return YES;
//}
//
//- (BOOL)HandleBySelfWithVC:(UIViewController *)vc
//{
//    NSArray *BIControllers = @[@"UICompatibilityInputViewController",
//                               @"FKYNavigationController",
//                               @"FKYTabBarController",
//                               @"UIInputWindowController",
//                               @"FKY.FKYSearchResultVC",
//                               @"FKY.HomeMainController",
//                               @"FKY.HomeMainOftenBuyController",
//                               @"FKYOrderDetailViewController",
//                               @"FKYProductionDetailViewController",
//                               @"FKY.ShopItemViewController",
//                               @"FKY.SearchOftenBuyController",
//                               @"UIKeyboardCandidateGridCollectionViewController",
//                               @"FKY.COInputController",
//                               @"FKY.RCPopController",
//                               @"FKY.PDComboVC",
//                               @"FKY.FKYAddCarViewController",
//                               @"FKY.PDFixedComboFailVC",
//                               @"FKY.PDDiscountPriceInfoVC",
//                               @"FKY.COFrightRuleListController",
//                               @"FKYShowSaleInfoViewController",
//                               @"FKY.PDShareStockTipVC",
//                               @"FKY.FKYFactoryFliterForSearchResultVC",
//                               @"FKY.FKYPopComCouponVC",
//                               @"GLViewController"];
//    for (NSString *vcStr in BIControllers) {
//        if ([vc isKindOfClass:NSClassFromString(vcStr)]) {
//            return NO;
//        }
//    }
//    return YES;
//}

@end
