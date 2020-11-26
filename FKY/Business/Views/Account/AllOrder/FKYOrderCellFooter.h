//
//  FKYOrderDetailFooterView.h
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单列表之订单cell对应的操作栏

#import <UIKit/UIKit.h>
@class FKYOrderModel;

typedef NS_ENUM(NSUInteger, FKYOrderType) {
    Unknow,                      // 未知状态 
    Unpay,                       // 待付款...<线上>
    Ship,                        // 待发货
    Receive,                     // 待收货
    Compelited,                  // 已完成
    Cancle,                      // 已取消
    Rejection,                   // 拒绝收货
    Replenishment,               // 补货
    ReplenishmentCompelited,     // 补货完成
    RejectionCompelited,         // 拒收完成
    OutLinePay,                  // 线下支付 待付款...<线下>
    ZhongJinPay,                 // 中金支付(此方式不支持)
    
};

typedef void(^FKYOrderCellFooterBlock)(void);

/// 复制订单按钮点击
static NSString *FKY_copyButtonClicked = @"FKY_copyButtonClicked";

@interface FKYOrderCellFooter : UIView

@property (nonatomic, copy) FKYOrderCellFooterBlock receiveBlock;           // 确认收货
@property (nonatomic, copy) FKYOrderCellFooterBlock delayBlock;             // 延期收货
@property (nonatomic, copy) FKYOrderCellFooterBlock payBlock;               // 支付
@property (nonatomic, copy) FKYOrderCellFooterBlock cancleBlock;            // 取消订单
//@property (nonatomic, copy) FKYOrderCellFooterBlock lookStorePriceBlock;    // 查看入库价
@property (nonatomic, copy) FKYOrderCellFooterBlock commentBlock;           // 去评价/已评价
@property (nonatomic, copy) FKYOrderCellFooterBlock checkBlock;             // 查看物流
@property (nonatomic, copy) FKYOrderCellFooterBlock rejectionBlock;         // 拒收
@property (nonatomic, copy) FKYOrderCellFooterBlock replenishmentBlock;     // 补货
@property (nonatomic, copy) FKYOrderCellFooterBlock buyAgainBlock;          // 再次购买
@property (nonatomic, copy) FKYOrderCellFooterBlock returnBlock;            // 申请退换货

@property (nonatomic, copy) FKYOrderCellFooterBlock timeIsOverBlock;        // 倒计时结束

// 找人代付相关
@property (nonatomic, copy) FKYOrderCellFooterBlock sharePayInfoBlock;      // 分享支付信息
@property (nonatomic, copy) FKYOrderCellFooterBlock findPeoplePayBlock;     // 找人代付

@property (nonatomic, copy) FKYOrderCellFooterBlock complainActionBlock;     // 找人代付
//
- (void)configViewWithModel:(FKYOrderModel *)model andTimeOffset:(NSTimeInterval)offsetTime;

@end
