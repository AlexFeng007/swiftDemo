//
//  FKYOrderStatusViewController.h
//  FKY
//
//  Created by mahui on 15/11/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  (当前状态)订单列表

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FKYOrderStatus) {
    AllType = 0,       // 全部订单
    UnpayType,         // 未付款
    UndelivereType,    // 未发货
    DelivereType,      // 已发货
    CompleteType,      // 已完成
    RejectedType,      // 拒收
    ReplenishmentType, // 补货
    CancleType,        // 取消
};


@interface FKYOrderStatusViewController : UIViewController

@property (nonatomic, assign) FKYOrderStatus orderStatus;
@property (nonatomic, assign) BOOL isOrderSearch;//判断是不是订单搜搜
@property (nonatomic, retain) NSString *searchText;

@property (nonatomic, copy) void(^clickIndex)(NSInteger index);
@property (nonatomic, copy) void(^sendExpiredTips)(NSString *tips);
 
- (void)requestData;
- (void)clearData;

@end
