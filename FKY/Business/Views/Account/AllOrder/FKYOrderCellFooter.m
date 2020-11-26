//
//  FKYOrderDetailFooterView.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  订单列表cell之footerview

#import "FKYOrderCellFooter.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "FKYOrderModel.h"


@interface FKYOrderCellFooter ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *orderTimeLabel; //下单时间
@property (nonatomic, strong) UILabel *orderNumLabel; //订单号
@property (nonatomic, strong) UIButton *orderCopyBtn;//复制订单号按钮
@property (nonatomic, strong) UIView *bgBtnView;
//@property (nonatomic, strong) UIButton *storePriceBtn;//r查看入库价
@property (nonatomic, strong) UIButton *commentBtn;//评论
@property (nonatomic, strong) UIButton *checkBtn;//查看物流
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *payOnPCLabel;
@property (nonatomic, strong) UIButton *complainBtn;//投诉按钮
@property (nonatomic, strong) UIButton *returnBtn;//申请退换货

// 找人代付之新增按钮...<只在订单状态为"待付款"的情况下新增相关逻辑>
// 0. 若是线下支付类型，则新增支付信息分享按钮
// 1. 若是线上支付类型，则新增找人代付按钮
@property (nonatomic, strong) UIButton *btnOtherPay;
@property (nonatomic, assign) BOOL isOnlinePay; // 是否为线上支付

// 订单状态
@property (nonatomic, assign) FKYOrderType orderStatus;
//订单号
@property (nonatomic, strong) NSString *orderNum;
@end


@implementation FKYOrderCellFooter

#define kWidthThirdNormal 48
#define kWidthNormal 60
#define kWidthFlourNormal 75
#define kWidthLong 85

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    // 顶部分隔线
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(FKYWH(-12));
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    
    //功能按钮的底部视图
    self.bgBtnView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(FKYWH(44.5)));
        }];
        view;
    });
    
    // 下单时间
    self.orderTimeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(11));
            make.top.equalTo(self.mas_top).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(-FKYWH(20));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0x666666);
        label;
    });
    //订单号
    self.orderNumLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(11));
            make.top.equalTo(self.orderTimeLabel.mas_bottom);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH-FKYWH(40+10)));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0x666666);
        label.adjustsFontSizeToFitWidth = true;
        label.minimumScaleFactor = 0.8;
        label;
    });
    // 复制订单号按钮
    self.orderCopyBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumLabel.mas_right).offset(FKYWH(2));
            make.centerY.equalTo(self.orderNumLabel.mas_centerY);
            make.width.equalTo(@(FKYWH(40)));
            make.height.equalTo(@(FKYWH(19)));
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(13));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"复制" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateDisabled];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            [[UIPasteboard generalPasteboard] setString:self.orderNum];
            [self routerEventWithName:FKY_copyButtonClicked userInfo:@{FKYUserParameterKey:self.orderNum}];
            [FKYToast showToast:@"复制成功"];
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    // 代付相关按钮
    // 找人代付 or 分享支付信息
    self.btnOtherPay = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right); // 默认右侧无间隔
            make.width.equalTo(@0); // 默认宽度为0
            make.height.equalTo(@(FKYWH(28)));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"找人代付" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            switch (self.orderStatus) {
                case Unpay:
                    if (self.isOnlinePay) {
                        // 找人代付
                        safeBlock(self.findPeoplePayBlock);
                    }
                    else {
                        // 分享
                        safeBlock(self.sharePayInfoBlock);
                    }
                    break;
                case OutLinePay:
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    // 默认隐藏
    self.btnOtherPay.hidden = YES;
    
    // 右侧按钮
    // 确认收货 or 支付 or 取消订单 or 补货 or 拒收 or 再次购买
    self.rightBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
            make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            make.height.equalTo(@(FKYWH(28)));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            switch (self.orderStatus) {
                case Unpay:
                case OutLinePay:
                    safeBlock(self.payBlock);
                    break;
                case Ship:
                    safeBlock(self.cancleBlock);
                    break;
                case Cancle: // 已取消...<新增“再次购买”>
                    safeBlock(self.buyAgainBlock);
                    break;
                case Receive:
                    safeBlock(self.receiveBlock);
                    break;
                case Compelited: // 已完成...<新增“再次购买”>
                    safeBlock(self.buyAgainBlock);
                    break;
                case Replenishment:
                case ReplenishmentCompelited:
                    safeBlock(self.replenishmentBlock);
                    break;
                case Rejection:
                case RejectionCompelited:
                    safeBlock(self.rejectionBlock);
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    // 申请退换货
    self.returnBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.width.equalTo(@(FKYWH(kWidthNormal)));
            make.height.equalTo(@(FKYWH(28)));
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"申请售后" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x676767) forState:UIControlStateDisabled];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.returnBlock);
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    //投诉商家
    self.complainBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            make.height.equalTo(@(FKYWH(28)));
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        button.hidden = YES;
        [button setTitle:@"投诉商家" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x3F7FDC) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x676767) forState:UIControlStateDisabled];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.complainActionBlock);
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    // 左侧按钮
    // 查看物流...<在确认收货左边>
    self.checkBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.width.equalTo(@(FKYWH(kWidthNormal)));
            make.height.equalTo(@(FKYWH(28)));
            //make.centerY.equalTo(self.mas_centerY);
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"查看物流" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        //[button setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            switch (self.orderStatus) {
                case Receive:
                case Rejection:
                case RejectionCompelited:
                case Replenishment:
                case ReplenishmentCompelited:
                case Compelited:
                    // 查看物流
                    safeBlock(self.checkBlock);
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    // 左侧按钮
    // 延迟收货 or 取消订单...<在确认收货左边>
    self.leftBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.checkBtn.mas_left).offset(-FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.width.equalTo(@(FKYWH(kWidthNormal)));
            make.height.equalTo(@(FKYWH(28)));
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"延迟收货" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            switch (self.orderStatus) {
                case Unpay:
                case OutLinePay:
                case Ship:
                    safeBlock(self.cancleBlock);
                    break;
                case Receive:
                    safeBlock(self.delayBlock);
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    //
    //    // 查看入库价 <在查看评价左边>
    //    self.storePriceBtn = ({
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [self addSubview:button];
    //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.equalTo(self.checkBtn.mas_left).offset(-FKYWH(8));
    //            make.centerY.equalTo(self.rightBtn.mas_centerY);
    //            make.width.equalTo(@(FKYWH(kWidthFlourNormal)));
    //            make.height.equalTo(@(FKYWH(28)));
    //        }];
    //        button.titleLabel.font = FKYSystemFont(FKYWH(12));
    //        button.layer.borderWidth = 0.5;
    //        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
    //        button.layer.cornerRadius = FKYWH(2);
    //        button.layer.masksToBounds = YES;
    //        [button setTitle:@"查看入库价" forState:UIControlStateNormal];
    //        [button setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
    //        @weakify(self);
    //        [button bk_addEventHandler:^(id sender) {
    //            @strongify(self);
    //            switch (self.orderStatus) {
    //                case Receive:
    //                case Rejection:
    //                case RejectionCompelited:
    //                case ReplenishmentCompelited:
    //                case Compelited:
    //                    // 查看入库价
    //                    safeBlock(self.lookStorePriceBlock);
    //                    break;
    //                default:
    //                    break;
    //            }
    //        } forControlEvents:UIControlEventTouchUpInside];
    //        button;
    //    });
    
    // 去评价/已评价 <在查看物流左边>
    self.commentBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtnView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
            make.right.equalTo(self.leftBtn.mas_left).offset(-FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.width.equalTo(@(FKYWH(kWidthThirdNormal)));
            make.height.equalTo(@(FKYWH(28)));
        }];
        button.titleLabel.font = FKYSystemFont(FKYWH(12));
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        button.layer.cornerRadius = FKYWH(2);
        button.layer.masksToBounds = YES;
        [button setTitle:@"去评价" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            switch (self.orderStatus) {
                case Receive:
                case Rejection:
                case RejectionCompelited:
                case ReplenishmentCompelited:
                case Compelited:
                    // 去评价/查看已评价
                    safeBlock(self.commentBlock);
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    // 支付时间剩余提示
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bgBtnView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(8));
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.height.equalTo(@40);
            make.right.equalTo(self.commentBtn.mas_left).offset(-FKYWH(4));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0x999999);
        label.numberOfLines = 2;
        label;
    });
    
    // 中金支付，PC支付提示
    self.payOnPCLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.bgBtnView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgBtnView.mas_centerY);
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
        }];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = UIColorFromRGB(0xff2a59);
        label.text = @"请至pc端进行在线支付";
        label;
    });
    self.payOnPCLabel.hidden = YES;
}


#pragma mark - Public

- (void)configViewWithModel:(FKYOrderModel *)model andTimeOffset:(NSTimeInterval)offsetTime
{
    // 获取当前订单的最终状态
    [self getOrderFinalStatus:model];
    
    // 设置提示文描
    [self setTimeTip:model withOffset:offsetTime];
    
    // 设置所有button展示状态
    self.commentBtn.hidden = YES;
    //    self.storePriceBtn.hidden = YES;
    [self setAllButtonsStatus:model];
    
    // 异常订单确认收货
    if (model.orderStatus.integerValue >= 800) {
        self.timeLabel.hidden = true;
        self.leftBtn.hidden = true;
    }
    
    // 隐藏or显示
    [self setShowOrHideStatus:model];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.createTime];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderId];
    self.orderNum = model.orderId;
    BOOL showFlag = [model getHandleBarShowStatus];
    if (showFlag) {
        self.bgBtnView.hidden = false;
        [self.bgBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(FKYWH(44.5)));
        }];
    }else {
        self.bgBtnView.hidden = true;
        [self.bgBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(FKYWH(0)));
        }];
    }
}

#pragma mark - Private

/*
 说明：Android那边拷过来的订单状态
 
 // 订单状态
 0: 全部订单
 1: 待付款
 2: 待发货
 3: 待收货
 7: 已完成
 10: 已取消
 800: 拒收中
 850: 拒收&补货中
 900: 补货中
 
 // 补货
 901: 待确认
 902: 待发货
 903: 待收货
 904: 已关闭
 905: 已完成
 
 // 拒收
 801: 待确认
 802: 退款中
 803: 已关闭
 804: 已完成
 */


// 获取当前订单的最终状态
- (void)getOrderFinalStatus:(FKYOrderModel *)model
{
    // 确认订单状态
    _orderStatus = Unknow;
    
    NSInteger status = model.orderStatus.integerValue;
    if (status == 7) {
        // 已完成
        _orderStatus = Compelited;
    }
    if (status == 2) {
        // 待发货
        _orderStatus = Ship;
    }
    if (status == 3 || status == 903) {
        // 待收货
        _orderStatus = Receive;
    }
    if (status == 1) {
        // 待付款
        if ([model.getPayType isEqualToString:payType_xxzz]) {
            // 线下支付
            _orderStatus = OutLinePay;
            _isOnlinePay = NO;
        } else {
            // 线上支付
            _orderStatus = Unpay;
            _isOnlinePay = YES;
        }
        if (model.isZhongjin) {
            _orderStatus = ZhongJinPay;
        }
    }
    if (status == 10 || status == 850) {
        // 已取消
        _orderStatus = Cancle;
    }
    if (status == 800) {
        // 拒收中
        _orderStatus = Rejection;
    }
    if (status == 900 || status == 905) {
        //
        if (model.exceptionOrderId == nil || model.exceptionOrderId == NULL) {
            // 已取消???
            _orderStatus = Cancle;
        } else {
            // 补货中
            _orderStatus = Replenishment;
            
            if (status == 905) {
                // 已完成...<补货完成>
                _orderStatus = ReplenishmentCompelited;
            }
        }
    }
    if (status == 804) {
        // 已完成...<拒收完成>
        _orderStatus = RejectionCompelited;
    }
}

// 设置提示
- (void)setTimeTip:(FKYOrderModel *)model withOffset:(NSTimeInterval)offsetTime
{
    if (_orderStatus == Unpay || _orderStatus == OutLinePay || _orderStatus == ZhongJinPay) {
        // 待付款
        _timeLabel.hidden = NO;
    } else {
        // 其它
        _timeLabel.hidden = YES;
    }
    
    if ((_orderStatus == Unpay || _orderStatus == ZhongJinPay) && model.residualTime.intValue > 0) {
        // 线上待付款
        __block int timeout = model.residualTime.intValue;
        timeout -= offsetTime;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            if (timeout <= 0) {
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    safeBlock(self.timeIsOverBlock);
                });
            } else {
                int hour = timeout / 3600;
                int min = timeout % 3600 / 60;
                int sec = timeout % 60;
                NSString *text = [NSString stringWithFormat:@"付款剩余时间: %02d时%02d分%02d秒",hour,min,sec];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLabel.text = text;
                });
                timeout--;
            }
        });
        dispatch_resume(timer);
    }
    
    if (_orderStatus == OutLinePay) {
        // 线下待付款
        
        // 自营的是48小时，非自营的是7天
        if (model.isZiYingFlag == 1) {
            // 自营
            _timeLabel.text = @"48小时未付款则自动取消";
            if (model.offlineDescribe4Self && model.offlineDescribe4Self.length > 0) {
                _timeLabel.text = model.offlineDescribe4Self;
            }
        } else {
            // mp
            _timeLabel.text = @"7天未付款则自动取消";
            if (model.offlineDescribe4Mp && model.offlineDescribe4Mp.length > 0) {
                _timeLabel.text = model.offlineDescribe4Mp;
            }
        }
    }
}

// 设置所有button展示状态
- (void)setAllButtonsStatus:(FKYOrderModel *)model
{
    if ((_orderStatus != Unpay && _orderStatus != OutLinePay) || _orderStatus == ZhongJinPay) {
        // 其它状态下均不显示代付相关按钮
        if (self.btnOtherPay.hidden == NO) {
            // 若已经显示，则隐藏
            self.btnOtherPay.hidden = YES;
            [self.btnOtherPay mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right); // 默认右侧无间隔
                make.width.equalTo(@0); // 默认宽度为0
            }];
        }
    }
    // 默认隐藏中金支付提示标识语
    self.payOnPCLabel.hidden = YES;
    // 根据是否是中金支付，更新按钮约束
    
    //初始化按钮的约束
    self.btnOtherPay.hidden = YES;
    [self.btnOtherPay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right); // 默认右侧无间隔
        make.width.equalTo(@0); // 默认宽度为0
    }];
    
    self.rightBtn.hidden = YES;
    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnOtherPay.mas_left).offset(0);
        make.width.equalTo(@0); // 60
    }];
    
    // 默认隐藏退换货
    self.returnBtn.hidden = YES;
    [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn.mas_left).offset(0);
        make.width.equalTo(@0);
    }];
    
    self.complainBtn.hidden = YES;
    [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.returnBtn.mas_left).offset(0);
        make.width.equalTo(@0); // 60
    }];
    
    // 查看物流...<隐藏>
    self.checkBtn.hidden = YES;
    [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.complainBtn.mas_left).offset(0);
        make.width.equalTo(@0);
    }];
    
    self.leftBtn.hidden = YES;
    [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.checkBtn.mas_left).offset(0);
        make.width.equalTo(@0);
    }];
    
    self.commentBtn.hidden = YES;
    [self.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftBtn.mas_left).offset(0);
        make.width.equalTo(@0);
    }];
    
    
    switch (_orderStatus) {
        case Unpay: // 线上待付款...<新增找人代付>
        {
            self.orderStatus = Unpay;   // 待付款
            self.isOnlinePay = YES;     // 线上支付
            
            // 立即支付
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            }];
            
            // 取消订单
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.checkBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 找人代付
            self.btnOtherPay.hidden = NO;
            [self.btnOtherPay setTitle:@"找人代付" forState:UIControlStateNormal];
            [self.btnOtherPay mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal))); // 80
            }];
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case OutLinePay: // 线下待付款...<新增支付信息分享>
        {
            self.orderStatus = Unpay;   // 待付款
            self.isOnlinePay = NO;     // 线下支付
            
            // 查看规则
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"线下转账" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            }];
            // 取消订单
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.checkBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 分享支付信息
            self.btnOtherPay.hidden = NO;
            [self.btnOtherPay setTitle:@"分享支付信息" forState:UIControlStateNormal];
            [self.btnOtherPay mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthLong)));
            }];
            
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case ZhongJinPay: // 中金支付
        {
            self.orderStatus = Unpay;   // 待付款
            
            // 取消订单
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            // 无...<隐藏>
            self.rightBtn.hidden = YES;
            // 查看物流...<隐藏>
            self.checkBtn.hidden = YES;
            // 中金支付开启提示语
            self.payOnPCLabel.hidden = NO;
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
            }else{
                _complainBtn.hidden = YES;
            }
            break;
        }
        case Ship: // 待发货
        {
            self.orderStatus = Ship;
            
            // 取消订单
            if (model.isZiYingFlag == 1 && model.orderType.integerValue!=3 && model.orderType.integerValue!=1) { //自营且是一起购、一起拼订单不可取消订单
                [self.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                self.rightBtn.hidden = NO;
                [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            } else {
                self.rightBtn.hidden = YES;
            }
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case Cancle: // 已取消
        {
            self.orderStatus = Cancle;
            
            // 再次购买
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            }];
            if (([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"])){
                if (model.exceptionOrderId == nil && model.orderStatus.integerValue == 905){
                    _complainBtn.hidden = YES;
                }else{
                    if ([model.complaintFlag isEqualToString:@"0"]){
                        [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                    }else if ([model.complaintFlag isEqualToString:@"1"]){
                        [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                    }
                    
                    [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                        make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                    }];
                    _complainBtn.hidden = NO;
                }
            }
            break;
        }
        case Receive: // 待收货
        {
            self.orderStatus = Receive;
            
            // 确认收货
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
            }];
            
            // 查看物流按钮位置重置complaintFlag
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            
            // 查看物流
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 延迟收货
            if (model.delayTimes.integerValue >= 2) {
                self.leftBtn.hidden = YES;
            } else {
                [self.leftBtn setTitle:@"延迟收货" forState:UIControlStateNormal];
                self.leftBtn.hidden = NO;
                [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.checkBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal)));
                }];
            }
            //mp和自营都显示申请售后《张震说去掉》
            if (model.isZiYingFlag == 1) {
                self.returnBtn.hidden = NO;
                [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal)));
                }];
            }
            
            //
            self.timeLabel.hidden = NO;
            self.timeLabel.text = [NSString stringWithFormat:@"已延期收货%@次",model.delayTimes];
            
            break;
        }
        case Replenishment: // 补货中
        {
            self.orderStatus = Replenishment;
            
            // 查看补货详情
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"查看补货详情" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthLong)));
            }];
            
            // 查看物流...<不隐藏>
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            // 查看物流按钮位置重置
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case ReplenishmentCompelited: // 补货完成
        {
            //self.orderStatus = Replenishment;
            self.orderStatus = ReplenishmentCompelited;
            
            // 查看补货详情
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"查看补货详情" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthLong)));
            }];
            // 查看物流...<不隐藏>
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            // 显示评论
            self.commentBtn.hidden = NO;
            if ([model.isEvaluate integerValue] == 0) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"去评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = true;
            } else if ([model.isEvaluate integerValue] == 1) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"已评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = false;
            } else {
                self.commentBtn.hidden = true;
            }
            if (self.commentBtn.hidden == NO) {
                [self.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.leftBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthThirdNormal)));
                }];
            }
            
            // 显示退换货
            if (model.isZiYingFlag == 1) {
                //自营订单
                self.returnBtn.hidden = NO;
                [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal)));
                }];
            }else {
                if (model.mpCanReturn == 1) {
                    //mp订单
                    self.returnBtn.hidden = NO;
                    [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                        make.width.equalTo(@(FKYWH(kWidthNormal)));
                    }];
                }
            }
            
            // 查看物流按钮位置重置
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case Rejection: // 拒收
        {
            self.orderStatus = Rejection;
            
            // 查看拒收详情
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"查看拒收详情" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthLong)));
            }];
            // 查看物流
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 查看物流按钮位置重置
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            break;
        }
        case RejectionCompelited: // 拒收完成
        {
            self.orderStatus = Rejection;
            
            // 查看拒收详情
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"查看拒收详情" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthLong)));
            }];
            // 查看物流
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 显示评论
            self.commentBtn.hidden = NO;
            if ([model.isEvaluate integerValue] == 0) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"去评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = true;
            } else if ([model.isEvaluate integerValue] == 1) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"已评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = false;
            } else {
                self.commentBtn.hidden = true;
            }
            if (self.commentBtn.hidden == NO) {
                [self.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.leftBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthThirdNormal)));
                }];
            }
            
            // 显示退换货
            if (model.isZiYingFlag == 1) {
                //自营订单
                self.returnBtn.hidden = NO;
                [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal)));
                }];
            }else {
                if (model.mpCanReturn == 1) {
                    //mp订单
                    self.returnBtn.hidden = NO;
                    [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                        make.width.equalTo(@(FKYWH(kWidthNormal)));
                    }];
                }
            }
            
            // 查看物流按钮位置重置、
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            
            break;
        }
        default: // 其它...<已完成> Compelited / Unknow
        {
            self.orderStatus = Compelited;
            
            // 再次购买
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnOtherPay.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            // 查看物流
            self.checkBtn.hidden = NO;
            [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.complainBtn.mas_left).offset(-FKYWH(8));
                make.width.equalTo(@(FKYWH(kWidthNormal)));
            }];
            
            // 显示评论
            self.commentBtn.hidden = NO;
            if ([model.isEvaluate integerValue] == 0) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0xe60012) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"去评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = true;
            } else if ([model.isEvaluate integerValue] == 1) {
                [self.commentBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"已评价" forState:UIControlStateNormal];
                self.commentBtn.userInteractionEnabled = false;
            } else {
                self.commentBtn.hidden = true;
            }
            if (self.commentBtn.hidden == NO) {
                [self.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.leftBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthThirdNormal)));
                }];
            }
            // 显示退换货
            if (model.isZiYingFlag == 1) {
                //自营订单
                self.returnBtn.hidden = NO;
                [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal)));
                }];
            }else {
                if (model.mpCanReturn == 1) {
                    //mp订单
                    self.returnBtn.hidden = NO;
                    [self.returnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.rightBtn.mas_left).offset(-FKYWH(8));
                        make.width.equalTo(@(FKYWH(kWidthNormal)));
                    }];
                }
            }
            // 查看物流按钮位置重置
            if ([model.complaintFlag isEqualToString:@"0"] || [model.complaintFlag isEqualToString:@"1"]){
                if ([model.complaintFlag isEqualToString:@"0"]){
                    [_complainBtn setTitle:@"投诉商家" forState:UIControlStateNormal];
                }else if ([model.complaintFlag isEqualToString:@"1"]){
                    [_complainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
                }
                _complainBtn.hidden = NO;
                [self.complainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.returnBtn.mas_left).offset(-FKYWH(8));
                    make.width.equalTo(@(FKYWH(kWidthNormal))); // 60
                }];
            }
            
            break;
        }
    } // switch
    //
    [self layoutIfNeeded];
}

// 若当前footer不显示，则所有子view均隐藏
- (void)setShowOrHideStatus:(FKYOrderModel *)model
{
    BOOL showFlag = [model getHandleBarShowStatus];
    if (showFlag == NO) {
        //self.topView.hidden = !showFlag;
        self.checkBtn.hidden = !showFlag;
        self.rightBtn.hidden = !showFlag;
        self.leftBtn.hidden = !showFlag;
        self.timeLabel.hidden = !showFlag;
        self.payOnPCLabel.hidden = !showFlag;
        self.btnOtherPay.hidden = !showFlag;
        self.commentBtn.hidden = !showFlag;
        //        self.storePriceBtn.hidden = !showFlag;
        self.returnBtn.hidden = !showFlag;
        self.complainBtn.hidden = YES;
    }
}

@end
