//
//  FKYOrderStatusViewController.m
//  FKY
//
//  Created by mahui on 15/11/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderStatusViewController.h"
#import "UIViewController+NavigationBar.h"
#import <Masonry/Masonry.h>
#import "FKYNavigator.h"
#import "FKYOrderCell.h"
#import "FKYOrderService.h"
#import "FKYOrderModel.h"
#import "UIViewController+ToastOrLoading.h"
#import "FKYAccountSchemeProtocol.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYOrderCellFooter.h"
#import "FKYOrderDetailViewController.h"
#import "FKYJSOrderDetailViewController.h"
#import "FKYProductAlertView.h"
#import "FKYTabBarController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "FKYPullToRefreshStateView.h"
#import "FKYCartSchemeProtocol.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

#import "FKY-Swift.h"
#import "FKYWarnView.h"

#import "FKYReceiveProductViewController.h"
#import "FKYLogisticsDetailViewController.h"
#import "FKYCartSubmitService.h"
#import "FKYSearchBar.h"
#import "FKYSearchService.h"
#import "AppDelegate+OpenPrivateScheme.h"

@interface FKYOrderStatusViewController () <UITableViewDataSource, UITableViewDelegate, FKYNavigationControllerDragBackDelegate, UIAlertViewDelegate,FKYSearchBarDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) FKYOrderService *orderSevice;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger runningTime;
@property (nonatomic, strong) FKYDelayInfoModel *delayInfoModel;
@property (nonatomic, strong) FKYOrderEmptyView *emptyView;
@property (nonatomic, strong) FKYOrderSearchEmptyView *searchEmptyView;
@property (nonatomic, copy)   NSString *statusString;
@property (nonatomic, strong) FKYWarnView *warnView;
/// 推荐品的modelList
@property (nonatomic, strong)NSMutableArray<HomeCommonProductModel *>* recommendProductList;

/// 推荐品列表的分页大小
@property (nonatomic, assign)NSInteger recommendProductPageSize;

//搜搜界面
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) FKYSearchBar *searchBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) FKYSearchService *service;

// 找人代付需求新增
@property (nonatomic, strong) ShareView4Pay *shareView;         // 代付相关分享视图
@property (nonatomic, strong) FKYOrderModel *currentOrderItem;  // 用于分享操作时的订单对象
@property (nonatomic, strong) FKYCartSubmitService *submitService;

// 解决待付款订单cell重用后倒计时功能重复计时的bug
@property (nonatomic, assign) NSTimeInterval timestamp4GetData; // 获取订单列表数据时的时间戳
@property (nonatomic, strong) FKYCmdPopView *cmdPopView;
@property (nonatomic, assign) BOOL noNeedResh; //是否需要刷新

#pragma mark --------- 专为推荐品增加的属性 ---------
@property (nonatomic, strong)NSIndexPath *selectIndexPath;

/// 商品加车弹框
@property (nonatomic, strong)FKYAddCarViewController *addCarView;

@property (nonatomic, strong)JSBadgeView *badgeView;

/// 行高管理器
@property (nonatomic, strong)ContentHeightManager *cellHeightManager;

/// 上拉加载尾部视图
@property (nonatomic, strong)MJRefreshAutoNormalFooter *MJ_Footer;

/// 是否正在获取网络请求 防止鬼畜操作 多次网络请求
@property (nonatomic, assign)BOOL isRequesting;

/// 套餐优惠viewmodel
@property (nonatomic, strong)FKYDiscountPackageViewModel *discountPackageViewModel;

/// 是否已经上报过套餐优惠埋点了
@property (nonatomic,assign)BOOL isUploadedDiscountEntryBI;

@end


@implementation FKYOrderStatusViewController

#pragma mark - LifeCircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUploadedDiscountEntryBI = false;
    self.isRequesting = false;
    if (self.isOrderSearch){
        [self setupView];//增加搜索栏
    }
    [self p_setupUI];
    if (self.isOrderSearch){
        [self requestData];//增加搜索栏
    }
    if (@available(iOS 11, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.recommendProductPageSize = 10;
    self.dataArr = @[].mutableCopy;
    
    // 通知
    NDC_ADD_SELF_NOBJ(@selector(p_OrderStatusRelodData), @"OrderStatusRelodData");
    NDC_ADD_SELF_NOBJ(@selector(p_OrderStatusRelodData), FKYLoginSuccessNotification);
    NDC_ADD_SELF_NOBJ(@selector(resetRefreshSatut), @"paySuccessToRefresh");
    // 已完成
    //    if (self.orderStatus == CompleteType) {
    //        // 收通知
    //        NDC_ADD_SELF_NOBJ(@selector(updateOrderListForCompleted), FKYRCSubmitApplyInfoNotification);
    //    }
    [self requestDiscountPackageEntryInfo];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addDiscountBaoGuangBi) object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    //Removing notification observers on dealloc.
    NDC_REMOVE_SELF_ALL;
}


#pragma mark - SetupView

- (void)p_setupUI
{
    self.warnView = ({
        FKYWarnView *view = [[FKYWarnView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.equalTo(@(FKYWH(30)));
        }];
        [view configViewWithType:FKYWarnViewTypeNomal];
        view;
    });
    if (self.isOrderSearch){
        self.warnView.hidden = YES;
    }
    self.mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.estimatedRowHeight = FKYWH(165);
        [self.view addSubview:tableView];
        [tableView registerClass:[FKYOrderCell class] forCellReuseIdentifier:@"FKYOrderCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [tableView registerClass:[SearchProductInfoCell class] forCellReuseIdentifier:NSStringFromClass([SearchProductInfoCell class])];
        [tableView registerClass:[FKYOrderEmptyCell class] forCellReuseIdentifier:NSStringFromClass([FKYOrderEmptyCell class])];
        [tableView registerClass:[FKYDiscountPackageCell class] forCellReuseIdentifier:NSStringFromClass([FKYDiscountPackageCell class])];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView emptyFooterView];
        if (self.isOrderSearch){
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.view);
                make.top.equalTo(self.navBar.mas_bottom);
            }];
        }else{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.warnView.mas_bottom);
            }];
        }
        tableView;
    });
    
    self.emptyView = ({
        FKYOrderEmptyView *view = [[FKYOrderEmptyView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:view];
        if (self.isOrderSearch){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.view);
                make.top.equalTo(self.navBar.mas_bottom);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
        view.openHome = ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
                destinationViewController.index = 0;
            } isModal:NO];
        };
        [self.view sendSubviewToBack:view];
        view;
    });
    
    self.searchEmptyView = ({
        FKYOrderSearchEmptyView *view = [[FKYOrderSearchEmptyView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:view];
        if (self.isOrderSearch){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.view);
                make.top.equalTo(self.navBar.mas_bottom);
            }];
        }else{
            view.hidden = YES;
        }
        [self.view sendSubviewToBack:view];
        view;
    });
    
    @weakify(self);
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.isRequesting) {
            [self.mainTableView.mj_footer endRefreshing];
            return ;
        }
        self.isRequesting = true;
        if ([self.orderSevice hasNext]) {
            // 请求订单列表数据
            [self.orderSevice getOrderListWithOrderType:self.statusString keyWord:self.searchText  success:^(NSMutableArray *orderList){
                @strongify(self);
                self.isRequesting = false;
#pragma mark debug 订单列表赋值
                self.dataArr = orderList.mutableCopy;
                [self.mainTableView reloadData];
                if (self.sendExpiredTips) {
                    self.sendExpiredTips([self.orderSevice getQualificationReminder]);
                }
                [self stopAnimation:1];
                [self disposeRecommendProductData];
                [self ProcessingData];
            } failure:^(NSString *reason) {
                @strongify(self);
                self.isRequesting = false;
                [self toast:reason];
                [self stopAnimation:1];
                [self ProcessingData];
            }];
        }
        else {
            self.isRequesting = false;
            [self stopAnimation:1];
            [self disposeRecommendProductData];
        }
    }];
    
    self.MJ_Footer = (MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer;
    [self.MJ_Footer setTitle:@"--没有更多啦！--" forState:MJRefreshStateNoMoreData];
    
//    [self.mainTableView addPullToRefreshWithActionHandler:^{
//        @strongify(self);
//        if ([self.orderSevice hasNext]) {
//            // 请求订单列表数据
//            [self.orderSevice getOrderListWithOrderType:self.statusString keyWord:self.searchText  success:^(NSMutableArray *orderList){
//                @strongify(self);
//#pragma mark debug 订单列表赋值
//                self.dataArr = orderList.mutableCopy;
//                [self disposeRecommendProductData];
//                [self.mainTableView reloadData];
//                if (self.sendExpiredTips) {
//                    self.sendExpiredTips([self.orderSevice getQualificationReminder]);
//                }
//                [self stopAnimation];
//            } failure:^(NSString *reason) {
//                @strongify(self);
//                [self toast:reason];
//                [self stopAnimation];
//            }];
//        }
//        else {
//            [self disposeRecommendProductData];
//            //
//            [self stopAnimation];
//        }
//    } position:SVPullToRefreshPositionBottom];
    
//    [self.mainTableView.pullToRefreshView setCustomView:[FKYPullToRefreshStateView fky_footerViewWithState:SVPullToRefreshStateStopped]
//                                               forState:SVPullToRefreshStateStopped];
//    [self.mainTableView.pullToRefreshView setCustomView:[FKYPullToRefreshStateView fky_footerViewWithState:SVPullToRefreshStateTriggered]
//                                               forState:SVPullToRefreshStateTriggered];
//    [self.mainTableView.pullToRefreshView setCustomView:[FKYPullToRefreshStateView fky_footerViewWithState:SVPullToRefreshStateLoading]
//                                               forState:SVPullToRefreshStateLoading];
}

#pragma mark - Private
//增加搜索栏
- (void)setupView
{
    [self fky_setupNavigationBar];
    self.navBar = [self fky_NavigationBar];
    [self fky_setNavigationBarBottomLineHidden:NO];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self createBackBtn];
    [self createSearchBar];
    [self createSearchBtn];
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar).offset(FKYWH(10));
        make.height.width.equalTo(@(FKYWH(30)));
        make.bottom.equalTo(@(FKYWH(-7)));
    }];
    [btn setImage:[UIImage imageNamed:@"icon_back_new_red_normal"] forState:UIControlStateNormal];
    // @weakify(self);
    [btn bk_addEventHandler:^(id sender) {
        // @strongify(self);
        [[FKYNavigator sharedNavigator] pop];
    } forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = btn;
}

// 创建搜索栏
- (void)createSearchBar
{
    FKYSearchBar *search = [[FKYSearchBar alloc] initWithLeftIconType:LeftIconStyle_SearchIconNone];
    search.delegate = self;
    [self.navBar addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(FKYWH(10));
        make.right.equalTo(self.navBar.mas_right).offset(-FKYWH(60));
        make.bottom.equalTo(@(FKYWH(-7)));
        make.height.equalTo(@(FKYWH(30)));
    }];
    search.placeholder = @"搜索商品名称/订单号/供应商";
    search.inputTextField.text = self.searchText;
    self.searchBar = search;
}

//创建右边搜索按钮
- (void)createSearchBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navBar).offset(FKYWH(-10));
        make.left.equalTo(self.searchBar.mas_right).offset(FKYWH(10));
        make.height.equalTo(@(FKYWH(30)));
        make.centerY.equalTo(self.searchBar.mas_centerY);
    }];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = FKYSystemFont(FKYWH(16));
    @weakify(self);
    [btn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self.searchBar.inputTextField resignFirstResponder];
        [self searchBarSearchButtonClicked:self.searchBar];
    } forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn = btn;
}
#pragma mark - Public

- (void)clearData
{
    [self.dataArr removeAllObjects];
    [self.mainTableView reloadData];
}


#pragma mark - Private

//- (void)emptyViewAppear
//{
//    return;
//    if(self.isOrderSearch){
//        [self.view bringSubviewToFront:self.searchEmptyView];
//    }else{
//        [self.view bringSubviewToFront:self.emptyView];
//    }
//
//}


/// 结束刷新动画
/// @param type 1还有数据结束  2已经拉倒最底部没有数据了
- (void)stopAnimation:(NSInteger )type
{
    @weakify(self);
    if (type == 1) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             @strongify(self);
             [self.mainTableView.mj_footer endRefreshing];
         });
    }else if (type == 2){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            [self.mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
        });
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        @strongify(self);
//        //
//        [self.mainTableView.mj_footer endRefreshing];
////        [self disposeRecommendProductData];
////        [self.mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
//    });
}

- (NSString *)jsonStringFromArray:(NSArray *)array
{
    if (!array.count) {
        return  @"[]";
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

// 获取当前时间戳
- (NSTimeInterval)getCurrentTimestamp
{
    return [[NSDate date] timeIntervalSince1970];
}


#pragma mark - NoUser

- (void)addTimerToController
{
    self.runningTime = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:NSRunLoopCommonModes repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timeChange
{
    self.runningTime++;
}


#pragma mark - Notification

- (void)p_OrderStatusRelodData
{
    [self requestData];
}
- (void)resetRefreshSatut
{
    self.noNeedResh = false;
}


- (void)updateOrderListForCompleted
{
    [self requestData];
}


#pragma mark - Request

/// 处理数据
- (void)ProcessingData{
    
    if (self.orderSevice.totalCount == 0 || self.dataArr.count >= self.orderSevice.totalCount) {// 当前没有订单 或者订单已经加载完毕
        
    }else{
        return;
    }
    
    // 查找出以前的已经加进去的商品列表
    NSMutableArray *tempHomeModel = [[NSMutableArray alloc]init];
    for (NSObject *model in self.dataArr) {
        if ([model isKindOfClass:[HomeCommonProductModel class]]) {
            [tempHomeModel addObject:model];
        }
    }
    
    // 移除以前的已经加进去的商品列表
    for (HomeCommonProductModel *model in tempHomeModel) {
        [self.dataArr removeObject:model];
    }
    
    /// 插入套餐优惠的活动入口
    if (![self.discountPackageViewModel.discountPackage.imgPath isEqual:[NSNull null]] && self.discountPackageViewModel.discountPackage.imgPath.length > 0){
        //FKYOrderModel *tempModel = nil;
        FKYDiscountPackageModel *tempModel = nil;
        for (id model in self.dataArr) {
            if ([model isKindOfClass:[FKYDiscountPackageModel class]]) {
                FKYDiscountPackageModel *orderModel = (FKYDiscountPackageModel *)model;
                tempModel = orderModel;
            }
        }
        if (tempModel != nil) {
            [self.dataArr removeObject:tempModel];
        }
        [self.dataArr addObject:self.discountPackageViewModel.discountPackage];
    }
    
    [self apendRecommendProductList:[self.recommendProductList copy]];
}

/// 请求优惠套餐入口信息
- (void)requestDiscountPackageEntryInfo{
    [self.discountPackageViewModel requestDiscountPackageInfoWithBlock:^(BOOL isSuccess, NSString * _Nonnull msg) {
        if (!isSuccess) {
            [self toast:msg];
            return;
        }
        
        [self ProcessingData];
    }];
}

// 请求当前状态下的订单列表数据
- (void)requestData
{
    if (self.isRequesting) {
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    self.isRequesting = true;
    // 刷新...<每次显示时均刷新>
    if (self.noNeedResh) {
        self.noNeedResh = false;
        self.isRequesting = false;
        [self requestForCartData];
        return;
    }
    [self removeRecommendProductModel];
    [self.orderSevice nowPageToZero];
    [self.dataArr removeAllObjects];
    
    [self showLoading];
    @weakify(self);
    [self.orderSevice getOrderListWithOrderType:self.statusString keyWord:self.searchText  success:^(NSMutableArray *orderList){
        @strongify(self);
        self.isRequesting = false;
        [self dismissLoading];
        self.timestamp4GetData = [self getCurrentTimestamp]; // 保存当前时间戳
        self.dataArr = orderList.mutableCopy;
#pragma mark 订单列表赋值
        if (self.dataArr && self.dataArr.count > 0) {
            [self.view bringSubviewToFront:self.mainTableView];
            [self.mainTableView reloadData];
        }
        else {
            //            [self emptyViewAppear];
        }
        [self stopAnimation:1];
        [self disposeRecommendProductData];
        if (self.sendExpiredTips) {
            self.sendExpiredTips([self.orderSevice getQualificationReminder]);
        }
        [self ProcessingData];
    } failure:^(NSString *reason) {
        @strongify(self);
        self.isRequesting = false;
        [self stopAnimation:1];
        [self dismissLoading];
        [self toast:reason];
        [self ProcessingData];
    }];
}

//请求购物车数量
// 请求购物车商品列表数据
- (void)requestForCartData
{
    for(int i=0 ;i<self.dataArr.count;i++){
        NSObject *cellModel = self.dataArr[i];
        if ([cellModel isKindOfClass:[HomeCommonProductModel class]]){// 商品cell
            HomeCommonProductModel *homeModel = (HomeCommonProductModel *)cellModel;
            for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
                if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:homeModel.spuCode] && cartModel.supplyId.integerValue == homeModel.supplyId){
                    homeModel.carId = cartModel.cartId.intValue;
                    homeModel.carOfCount = cartModel.buyNum.intValue;
                    break;
                }else{
                    homeModel.carId = 0;
                    homeModel.carOfCount = 0;
                }
            }
        }
    }
    [self.mainTableView reloadData];
}

// 开始搜索
- (void)searchBarSearchButtonClicked:(FKYSearchBar *)searchBar
{
    @weakify(self);
    NSString *searchText = searchBar.text;
    if (searchText && searchText.length > 0) {
        //订单搜索
        self.searchText = searchText;
        [self.service save:self.searchText type:@(4) shopId:nil success:^(BOOL mutiplyPage) {
            //@strongify(self);
            // 刷新搜索历史
        } failure:^(NSString *reason) {
            @strongify(self);
            [self toast:reason];
        }];
        [self requestData];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // (自营)确认收货
        
        // 非指定alert
        if ((alertView.tag - 888) >= self.dataArr.count || (alertView.tag - 888) < 0) {
            return;
        }
        
        FKYOrderModel *model = self.dataArr[alertView.tag-888];
        [self showLoading];
        @weakify(self);
        // 收货清单
        [self.orderSevice geiReceiveProductListWithOrderId:model.orderId success:^(FKYReceiveModel *receiveModel) {
            // 获取当前订单下的商品列表成功
            @strongify(self);
            NSMutableArray *temp = [NSMutableArray array];
            for (FKYReceiveProductModel *obj in receiveModel.productList) {
                NSMutableDictionary *dic = @{}.mutableCopy;
                dic[@"orderDetailId"] = obj.orderDetailId;
                dic[@"batchId"] = obj.batchId;
                dic[@"buyNumber"] = obj.deliveryProductCount;
                [temp addObject:dic];
            } // for
            @weakify(self);
            // 拒收 补货
            [self.orderSevice refusedOrReplenishOrderWithOrderId:model.orderId andProductList:[self jsonStringFromArray:temp] andApplyType:@"" andApplyCause:@"" andAddressId:nil success:^(NSString *message){
                @strongify(self);
                [self dismissLoading];
                //[self toast:message];
                // 操作成功后重新刷新订单列表数据
                [self requestData];
                //自营店点击收货后跳转到评价界面
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                    destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",ORDER_PJ_HOST,model.orderId];
                    destinationViewController.pushType = 1;
                } isModal:NO animated:YES];
                if (self.clickIndex) {
                    self.clickIndex(4);
                }
            } failure:^(NSString *reason) {
                @strongify(self);
                [self dismissLoading];
                [self toast:reason];
            }];
        } failure:^(NSString *reason) {
            // 获取当前订单下的商品列表失败
            @strongify(self);
            [self dismissLoading];
            [self toast:reason];
        }];
    }
}


#pragma mark - UserAction

// 查看物流
- (void)pushToLogisticsDetailJSControllerWithModel:(FKYOrderModel *)model
{
    if ([[model getDeliveryMethod] isEqualToString:deliveryMethod_third]) {
        // 查看第三方物流
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsDetailController) setProperty:^(FKYLogisticsDetailViewController *destinationViewController) {
            destinationViewController.orderId = model.orderId;
        } isModal:NO animated:YES];
    }
    else {
        // 查看自有物流
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsController) setProperty:^(FKYLogisticsViewController *destinationViewController) {
            destinationViewController.deliveryType = deliveryMethod_own;
            destinationViewController.orderId = model.orderId;
        } isModal:NO animated:YES];
    }
}

// 拒收 or 补货
- (void)pushToJSControllerWithModel:(FKYOrderModel *)model
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController) setProperty:^(FKYJSOrderDetailViewController*destinationViewController) {
        destinationViewController.orderModel = model;
        NSString *code = @"";
        if (model.orderStatus.integerValue < 900 && model.orderStatus.integerValue >= 800) {
            code = @"800";
        }
        else if (model.orderStatus.integerValue >= 900) {
            code = @"900";
        }
        else {
            code = model.orderStatus;
        }
        destinationViewController.statusCode = code;
    } isModal:NO animated:YES];
}

// 分享支付信息...<线下支付之未付款>
- (void)shareOrderPayInfo:(FKYOrderModel *)model
{
    // 更新当前订单model
    self.currentOrderItem = model;
    
    // 线下支付传3
    [self startShareAction:model.orderId payType:@"3"];
}

// 找人代付...<线上支付之未付款>
- (void)findPeoplePay:(FKYOrderModel *)model
{
    // 更新当前订单model
    self.currentOrderItem = model;
    
    // 线上支付传1
    [self startShareAction:model.orderId payType:@"1"];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count ? self.dataArr.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *cellModel = self.dataArr[indexPath.section];
    if ([cellModel isKindOfClass:[FKYOrderModel class]]) {// 订单cell
        FKYOrderModel *orderModel = (FKYOrderModel *)cellModel;
        if (orderModel.cellType == 1) {// 进一步校验是订单cell
            return FKYWH(165);
        }
        return tableView.rowHeight;
    }else if ([cellModel isKindOfClass:[HomeCommonProductModel class]]){// 商品cell
        HomeCommonProductModel *homeModel = (HomeCommonProductModel *)cellModel;
        if (homeModel.cellType == 2) {
            CGFloat cellHeight = [self.cellHeightManager getContentCellHeight:homeModel.spuCode :[NSString stringWithFormat:@"%ld",homeModel.supplyId] :@"couponProduct"];
            if (cellHeight == 0) {
                CGFloat conutCellHeight = [SearchProductInfoCell getCellContentHeight:homeModel];
                [self.cellHeightManager addContentCellHeight:homeModel.spuCode :[NSString stringWithFormat:@"%ld",homeModel.supplyId] :@"couponProduct" :conutCellHeight];
                return conutCellHeight;
            }else{
                return cellHeight;
            }
        }
    }else if ([cellModel isKindOfClass:[FKYEmptyOrderCellModel class]]){// 空态视图
        FKYEmptyOrderCellModel *emptyModel = (FKYEmptyOrderCellModel *)cellModel;
        if (emptyModel.cellType == 3) {
            return FKYWH(250);
        }
    }else if ([cellModel isKindOfClass:[FKYDiscountPackageModel class]]){
        return tableView.rowHeight;
    }
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    NSObject *cellModel = self.dataArr[indexPath.section];
    if ([cellModel isKindOfClass:[FKYOrderModel class]]) {// 订单cell
        FKYOrderModel *orderModel = (FKYOrderModel *)cellModel;
        if (orderModel.cellType == 1) {// 进一步校验是订单cell
            FKYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderCell" forIndexPath:indexPath];
            [self configOrderCell:cell andCellModel:orderModel];
            return cell;
        }
    }else if ([cellModel isKindOfClass:[HomeCommonProductModel class]]){// 商品cell
        HomeCommonProductModel *homeModel = (HomeCommonProductModel *)cellModel;
        if (homeModel.cellType == 2) {
            SearchProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchProductInfoCell class]) forIndexPath:indexPath];
            [self configRecommendProductCell:cell andCellModel:homeModel andIndexPath:indexPath];
            return cell;
        }
    }else if ([cellModel isKindOfClass:[FKYEmptyOrderCellModel class]]){// 空态视图
        FKYEmptyOrderCellModel *emptyModel = (FKYEmptyOrderCellModel *)cellModel;
        if (emptyModel.cellType == 3) {
            FKYOrderEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKYOrderEmptyCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if ([cellModel isKindOfClass:[FKYDiscountPackageModel class]]){// 优惠套餐 套餐优惠入口
        FKYDiscountPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKYDiscountPackageCell class]) forIndexPath:indexPath];
        [cell configEntryWithModelWithModel:self.discountPackageViewModel.discountPackage];
        [self performSelector:@selector(addDiscountBaoGuangBi) withObject:nil afterDelay:3];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    NSObject *cellModel = self.dataArr[section];
    if ([cellModel isKindOfClass:[FKYDiscountPackageModel class]]) {
        return 0.001;
    }else if (section == self.dataArr.count - self.recommendProductList.count) {// 为你推荐的分区头
        return FKYWH(40);
    }else if (section > self.dataArr.count - self.recommendProductList.count){
        return 0.001;
    }else{
        return FKYWH(10);
    }
}

// 此方法加上是为了适配iOS 11出现的问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSObject *cellModel = self.dataArr[section];
    if ([cellModel isKindOfClass:[FKYDiscountPackageModel class]]) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }else if (section == self.dataArr.count - self.recommendProductList.count) {// 为你推荐的分区头
        return [[FKYRecommendProductSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(40))];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.dataArr.count) {
        return 0.01;
    }
    NSObject *model = self.dataArr[section];
    if ([model isKindOfClass:[FKYOrderModel class]]) {
        FKYOrderModel *orderModel = (FKYOrderModel *)model;
        BOOL showFlag = [orderModel getHandleBarShowStatus];
        return showFlag ? FKYWH(45+48) : FKYWH(48+5);
    }else if ([model isKindOfClass:[HomeCommonProductModel class]]){
        return 0.01;
    }else{
        return 0.01;
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!(self.dataArr && self.dataArr.count > 0)) {
        return [UIView new];
    }
    
    NSObject *model = self.dataArr[section];
    if ([model isKindOfClass:[FKYOrderModel class]]) {
        FKYOrderModel *orderModel_t = (FKYOrderModel *)model;
        if (orderModel_t.cellType == 4) {// 优惠套餐入口
            return [[UIView alloc]initWithFrame:CGRectZero];
        }
        // 单个订单cell底部的操作栏视图
        FKYOrderCellFooter *view = (FKYOrderCellFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYOrderCellFooter"];
        if (!view) {
            view = [[FKYOrderCellFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(44))];
        }
        
        // 当前时间戳
        NSTimeInterval currentTime = [self getCurrentTimestamp];
        // 时间偏移量
        NSTimeInterval offsetTime = currentTime - self.timestamp4GetData;
        
        // 设置view
        FKYOrderModel *orderModel = (FKYOrderModel *)model; // 订单model
        orderModel.offlineDescribe4Self = [self.orderSevice getOfflineDescribe4Self];
        orderModel.offlineDescribe4Mp = [self.orderSevice getOfflineDescribe4Mp];
        
        // config
        [view configViewWithModel:orderModel andTimeOffset:offsetTime];
        
        @weakify(self);
        
        // 确认收货
        view.receiveBlock = ^(){
            @strongify(self);
            if (orderModel.isZiYingFlag == 1) {
                // 自营确认收货...<一次收完>
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认收货?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = section + 888;
                [alert show];
            }
            else {
                // mp确认收货...<跳转界面，用户可设置不同商品的收货数量后再提交>
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ReceiveController) setProperty:^(FKYReceiveProductViewController *destinationViewController) {
                    destinationViewController.orderId = orderModel.orderId;
                    destinationViewController.isZiYingFlag = orderModel.isZiYingFlag;
                    destinationViewController.selectDeliveryAddressId = orderModel.selectDeliveryAddressId;
                    destinationViewController.supplyId = [NSString stringWithFormat:@"%d",orderModel.supplyId];
                    //全部收回返回则选择到已完成订单
                    destinationViewController.clickAllProudct = ^{
                        @strongify(self);
                        if (self.clickIndex) {
                            self.clickIndex(4);
                        }
                    };
                } isModal:NO];
            }
            
            [self addBIRecordWithItemName:@"确认收货" itemContent:orderModel.orderId itemPosition:9];
        };
        // 延期收货
        view.delayBlock = ^{
            @strongify(self);
            [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"取消" rightTitle:@"确定" message:@"确定延期收货？" handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                @strongify(self);
                if (isRight) {
                    // 延期收货请求
                    [self.orderSevice delayProductionWithOrderId:orderModel.orderId success:^(NSString *reason) {
                        //
                        @strongify(self);
                        [self toast:reason];
                        [self requestData];
                    } failure:^(NSString *reason) {
                        //
                        @strongify(self);
                        [self toast:reason];
                    }];
                }
            }];
            
            [self addBIRecordWithItemName:@"延期收货" itemContent:orderModel.orderId itemPosition:4];
        };
        
        // 支付
        view.payBlock = ^(){
            @strongify(self);
            if ([orderModel.getPayType isEqualToString:payType_xxzz]) {
                // 线下支付
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfflinePayInfo) setProperty:^(COOfflinePayDetailController *destinationViewController) {
                    destinationViewController.supplyId = [NSString stringWithFormat:@"%d", orderModel.supplyId];
                    destinationViewController.flagFromCO = NO;
                }];
                
                [self addBIRecordWithItemName:@"线下转账" itemContent:orderModel.orderId itemPosition:14];
            }
            else {
                // 线上支付
                
                // 计算最终的订单失效时间间隔
                NSString *countTime = nil;
                if (orderModel.residualTime && orderModel.residualTime.intValue > 0) {
                    NSTimeInterval total = orderModel.residualTime.intValue;
                    NSTimeInterval final = total - offsetTime - 2;
                    if (final > 0) {
                        countTime = [NSString stringWithFormat:@"%f", final];
                    }
                }
                
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SelectOnlinePay) setProperty:^(id<FKY_SelectOnlinePay> destinationViewController) {
                    destinationViewController.orderId = orderModel.orderId;
                    //destinationViewController.orderType =
                    destinationViewController.countTime = countTime;
                    if(orderModel.parentOrderFlag == 1){
                        //有子订单
                        destinationViewController.supplyIdList = orderModel.supplyIds;
                    }else{
                        destinationViewController.supplyId = [NSString stringWithFormat:@"%d", orderModel.supplyId];
                    }
                    
                    destinationViewController.orderMoney = [NSString stringWithFormat:@"%.2f", orderModel.finalPay.floatValue];
                    destinationViewController.flagFromCO = NO;
                } isModal:NO animated:YES];
                
                [self addBIRecordWithItemName:@"立即支付" itemContent:orderModel.orderId itemPosition:3];
            }
        };
        
        // 取消订单
        view.cancleBlock = ^{
            @strongify(self);
            if (self.orderSevice.reasonsArray.count > 0) {
                FKYCancelReasonView *reasonView = [[FKYCancelReasonView alloc] initWithFrame:CGRectZero];
                reasonView.closeClouser = ^{
                    [self.cmdPopView  hidePopView];
                };
                
                reasonView.confirmClouser = ^(NSString * type, NSString * reasonStr, NSString *biReason, NSInteger itemPosition) {
                    [self.cmdPopView  hidePopView];
                    [self cancelOrderWithOrder:orderModel type:type str:reasonStr biReason:biReason itemPosition:itemPosition];
                };
                
                CGFloat height = 528.0 * SCREEN_HEIGHT / 667.0;
                [self.cmdPopView showSubViewWithSubView:reasonView toVC:self.parentViewController subHeight:height];
                [reasonView reloadReasonsTableWithData:self.orderSevice.reasonsArray];
                return ;
            }
            
            [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"取消" rightTitle:@"确定" message:@"你确定要取消订单吗" handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                //
                @strongify(self);
                if (isRight) {
                    [self addBIRecordWithItemName:@"取消订单" itemContent:orderModel.orderId itemPosition:1];
                    
                    BOOL isSelf = NO;
                    if (orderModel.isZiYingFlag == 1 && [orderModel.orderStatus integerValue] == 2) {
                        isSelf = YES;
                    }
                    // 取消订单请求
                    [self.orderSevice cancelOrderWithOrderId:orderModel  isSelf:isSelf success:^(NSString *reason) {
                        //
                        @strongify(self);
                        if (orderModel.payTypeId) {
                            if (orderModel.payTypeId.integerValue == 17) {
                                [self toast:@"订单取消成功，1药贷额度预计2个工作日恢复"];
                            } else {
                                [self toast:reason];
                            }
                        } else {
                            [self toast:reason];
                        }
                        
                        [self requestData];
                    } failure:^(NSString *reason) {
                        @strongify(self);
                        if (isSelf) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                        }
                        else {
                            [self toast:reason];
                        }
                    }];
                }
            }];
        };
        
        // 再次购买
        view.buyAgainBlock = ^{
            @strongify(self);
            [self showLoading];
            [self.orderSevice buyAgainOrderType:orderModel.orderType
                                     andOrderId:orderModel.orderId success:^(NSNumber *data) {
                @strongify(self);
                [self dismissLoading];
                //[self toast:@"加入购物车成功"];
                if (data && data.integerValue > 0) {
                    // failCount>0 部分成功
                    NSString *tip = [NSString stringWithFormat:@"订单中有%ld个商品未加入购物车，其余商品已加入！\n未加入的商品包含已下架，无库存或者无采购权。", (long)data.integerValue];
                    [self toast:tip];
                    //return;
                }
                // 跳转到购物车...<全部成功>
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
                    destinationViewController.index = 3;
                } isModal:YES];
            } failure:^(NSString *reason) {
                @strongify(self);
                [self dismissLoading];
                [self toast: (reason && reason.length > 0) ? reason : @"加入购物车失败"];
            }];
            // 加车埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9999" itemPosition:@"0" itemName:@"再次购买" itemContent:orderModel.orderId itemTitle:nil extendParams:@{@"pageCode":@"orderManage"} viewController:self];
        };
        
        // 查看订单/评价订单
        view.commentBlock = ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",@"http://m.yaoex.com",orderModel.orderId];
                destinationViewController.pushType = 2;
            } isModal:NO animated:YES];
            
            [self addBIRecordWithItemName:@"去评价" itemContent:orderModel.orderId itemPosition:5];
        };
        
        // 查看入库价
        //    view.lookStorePriceBlock = ^{
        //        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
        //            destinationViewController.urlPath = [NSString stringWithFormat: @"%@/incoming_price.html?orderId=%@",ORDER_PJ_HOST,model.orderId];
        //        } isModal:NO animated:YES];
        //
        //        [self addBIRecordWithItemName:@"查看入库价" itemContent:model.orderId itemPosition:6];
        //    };
        
        // 查看物流
        view.checkBlock = ^{
            @strongify(self);
            [self pushToLogisticsDetailJSControllerWithModel:orderModel];
            
            [self addBIRecordWithItemName:@"查看物流" itemContent:orderModel.orderId itemPosition:7];
        };
        
        // 拒收
        view.rejectionBlock = ^{
            @strongify(self);
            [self pushToJSControllerWithModel:orderModel];
            
            [self addBIRecordWithItemName:@"查看拒收详情" itemContent:orderModel.orderId itemPosition:10];
        };
        
        // 补货
        view.replenishmentBlock = ^{
            @strongify(self);
            [self pushToJSControllerWithModel:orderModel];
            
            [self addBIRecordWithItemName:@"查看补货详情" itemContent:orderModel.orderId itemPosition:11];
        };
        
        // 倒计时结束
        view.timeIsOverBlock = ^{
            @strongify(self);
            [self requestData];
        };
        
        // 分享支付信息
        view.sharePayInfoBlock = ^{
            @strongify(self);
            [self shareOrderPayInfo:orderModel];
            
            [self addBIRecordWithItemName:@"分享支付信息" itemContent:orderModel.orderId itemPosition:2];
        };
        
        // 找人代付
        view.findPeoplePayBlock = ^{
            @strongify(self);
            [self findPeoplePay:orderModel];
            
            [self addBIRecordWithItemName:@"找人代付" itemContent:orderModel.orderId itemPosition:12];
        };
        //投诉商家
        view.complainActionBlock = ^{
            if ([orderModel.complaintFlag isEqualToString:@"0"]){
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_BuyerComplainController) setProperty:^(BuyerComplainInputController *destinationViewController) {
                    destinationViewController.orderModel = orderModel;
                } isModal:NO animated:YES];
                [self addBIRecordWithItemName:@"投诉商家" itemContent:orderModel.orderId itemPosition:8];
            }else if ([orderModel.complaintFlag isEqualToString:@"1"]){
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_BuyerComplainDetailController) setProperty:^(BuyerComplainDetailController *destinationViewController) {
                    destinationViewController.orderModel = orderModel;
                } isModal:NO animated:YES];
                [self addBIRecordWithItemName:@"查看投诉" itemContent:orderModel.orderId itemPosition:15];
            }
        };
        // 申请退换货
        view.returnBlock = ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AfterSaleListController) setProperty:^(AfterSaleListController *destinationViewController) {
                destinationViewController.paytype = orderModel.payType.intValue;
                destinationViewController.orderModel = orderModel;
            } isModal:NO animated:YES];
            
            [self addBIRecordWithItemName:@"申请售后" itemContent:orderModel.orderId itemPosition:13];
        };
        
        return view;
    }else if ([model isKindOfClass:[HomeCommonProductModel class]]){
        return [UIView new];
    }else{
        return [UIView new];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MARK: - 测试方法，务必删除或注释
//    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MatchingPackageVC) setProperty:^(id destinationViewController) {
//
//    }];
//    return;
    
    NSObject *cellModel = self.dataArr[indexPath.section];
    if ([cellModel isKindOfClass:[FKYOrderModel class]]) {// 如果是入口，则不处理
        FKYOrderModel *orderModel = (FKYOrderModel *)cellModel;
        if (orderModel.cellType == 4){
            return ;
        }
    }
    
    if (!self.dataArr.count) {
        return;
    }
    
    // 跳转订单详情
    FKYOrderModel *model = self.dataArr[indexPath.section];
    if (![model isKindOfClass:[FKYOrderModel class]]) {
        return;
    }
    @weakify(self);
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderDetailController) setProperty:^(FKYOrderDetailViewController *destinationViewController) {
        destinationViewController.orderModel = model;
        destinationViewController.changeBtnBlock = ^(BOOL ischange) {
            @strongify(self);
            if (!ischange) {
                self.noNeedResh = true;
            }else{
                self.noNeedResh = false;
            }
        };
    } isModal:NO animated:YES];
    
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9203" itemPosition:STRING_FORMAT(@"%zd",indexPath.section + 1) itemName:@"点进订单详情" itemContent:model.orderId itemTitle:nil extendParams:nil viewController:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ShareAction

// 微信好友分享
- (void)WXShare
{
    // 只设置标题，不设置描述
    [FKYShareManage shareToWXWithOpenUrl:[self shareUrl] title:[self shareTitle] andMessage:nil andImage:[self shareImage]];
    // [self BI_Record:@"product_yc_share_wechat"];
}

// QQ好友分享
- (void)QQShare
{
    [FKYShareManage shareToQQWithOpenUrl:[self shareUrl] title:[self shareTitle] andMessage:nil andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_qq"];
}

// 复制链接
- (void)copyShare
{
    // 保存支付链接
    [UIPasteboard generalPasteboard].string = [self shareUrl];
    [self toast:@"支付链接自动复制成功，请立即粘贴支付信息发送给贵司财务！"];
}


#pragma mark - Private

// 开始分享操作
- (void)startShareAction:(NSString *)orderid payType:(NSString *)payType
{
    if (self.currentOrderItem.sharePayUrl && self.currentOrderItem.sharePayUrl.length > 0) {
        // 已获取分享链接
        [self showShareView];
    }
    else {
        // 未获取分享链接
        [self showLoading];
        
        @weakify(self);
        [self.submitService getOrderShareSign:orderid payType:payType success:^(BOOL mutiplyPage, id data) {
            @strongify(self);
            [self dismissLoading];
            // 保存分享链接
            if (data && [data isKindOfClass:[NSString class]]) {
                NSString *shareUrl = (NSString *)data;
                if (shareUrl && shareUrl.length > 0) {
                    self.currentOrderItem.sharePayUrl = shareUrl;
                    [self showShareView];
                    return;
                }
            }
            [self toast:@"获取分享链接失败"];
        } failure:^(NSString *reason, id data) {
            @strongify(self);
            [self dismissLoading];
            [self toast:@"获取分享链接失败"];
        }];
    }
}

// 显示分享视图
- (void)showShareView
{
    if (self.shareView.superview == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.shareView];
    }
    self.shareView.appearClourse();
}

// 分享图片
- (NSString *)shareImage
{
    return nil;
}

// 分享标题
- (NSString *)shareTitle
{
    return [NSString stringWithFormat:@"我在1药城采购了一批商品，总金额为￥%.2f，点击链接帮我支付吧！", self.currentOrderItem.finalPay.floatValue];
}

// 分享链接
- (NSString *)shareUrl
{
    return self.currentOrderItem.sharePayUrl;
}


#pragma mark - Property

- (FKYOrderService *)orderSevice
{
    if (!_orderSevice) {
        _orderSevice = [[FKYOrderService alloc] init];
    }
    return _orderSevice;
}

- (NSString *)statusString
{
    if (self.orderStatus == AllType) {
        return @"0";
    }
    if (self.orderStatus == UnpayType) {
        return @"1";
    }
    if (self.orderStatus == UndelivereType) {
        return @"2";
    }
    if (self.orderStatus == DelivereType) {
        return @"3";
    }
    if (self.orderStatus == CompleteType) {
        return @"7";
    }
    if (self.orderStatus == RejectedType) {
        return @"800";
    }
    if (self.orderStatus == ReplenishmentType) {
        return @"900";
    }
    return @"10";
}

- (ShareView4Pay *)shareView
{
    if (_shareView == nil) {
        _shareView = [[ShareView4Pay alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        @weakify(self);
        // 微信分享
        self.shareView.WeChatShareClourse = ^(){
            @strongify(self);
            [self WXShare];
        };
        // QQ分享
        self.shareView.QQShareClourse = ^(){
            @strongify(self);
            [self QQShare];
        };
        // 复制链接
        self.shareView.CopyLinkShareClourse = ^(){
            @strongify(self);
            [self copyShare];
        };
    }
    return _shareView;
}
#pragma mark - Property

- (FKYDiscountPackageViewModel *)discountPackageViewModel{
    if (!_discountPackageViewModel) {
        _discountPackageViewModel = [[FKYDiscountPackageViewModel alloc]init];
        _discountPackageViewModel.type = @"33";
    }
    return _discountPackageViewModel;
}

- (FKYCartSubmitService *)submitService
{
    if (!_submitService) {
        _submitService = [[FKYCartSubmitService alloc] init];
    }
    return _submitService;
}

- (FKYSearchService *)service
{
    if (!_service) {
        _service = [[FKYSearchService alloc] init];
    }
    return _service;
}

- (FKYCmdPopView *)cmdPopView {
    if (!_cmdPopView) {
        _cmdPopView = [[FKYCmdPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _cmdPopView;
}

#pragma mark -- 推荐品相关逻辑--------------------------------------------------------------------
#pragma mark -- 推荐品相关私有方法
- (void)disposeRecommendProductData{
    
    /// 订单搜索页，不需要展示推荐品
    if (self.isOrderSearch == true) {
        return;
    }
    
    if (self.orderSevice.totalCount == 0) {// 当前没有订单 插入空态视图
        BOOL isHaveEmptyCell = false;
        if (self.dataArr.count > 0) {
            if ([self.dataArr[0] isKindOfClass:[FKYEmptyOrderCellModel class]]) {
                isHaveEmptyCell = true;
            }
        }
        
        if (isHaveEmptyCell == false) {
            FKYEmptyOrderCellModel *emptyModel = [[FKYEmptyOrderCellModel alloc]init];
            [self.dataArr insertObject:emptyModel atIndex:0];
        }
    }else{// 移除空态视图
        NSArray *temp = [self.dataArr copy];
        for (NSObject *model in temp) {
            if ([model isKindOfClass:[FKYEmptyOrderCellModel class]]) {
                FKYEmptyOrderCellModel *empty = (FKYEmptyOrderCellModel *)model;
                if (empty.cellType == 3) {// 空态视图
                    [self.dataArr removeObject:empty];
                }
            }
        }
    }
    
    if (self.dataArr.count >= self.orderSevice.totalCount) {// 说明已经加载完了 需要加载推荐品
        if (self.recommendProductList.count > 0) {// 加载更多
            if (self.orderSevice.recommendCurrentPage == self.orderSevice.recommendTotalPages) {// j最后一页已经加载
                [self stopAnimation:2];
                return;
            }else{
                [self requestRecommendProduct:2];
            }
        }else{
            [self requestRecommendProduct:1];
        }
    }else{// 移除推荐品列表
        [self removeRecommendProductModel];
    }
}

/// 将推荐品Model添加进去
- (void)apendRecommendProductList:(NSArray <HomeCommonProductModel *>*)recommendProductList {
    
    // 查找出以前的已经加进去的商品列表
    NSMutableArray *tempHomeModel = [[NSMutableArray alloc]init];
    for (NSObject *model in self.dataArr) {
        if ([model isKindOfClass:[HomeCommonProductModel class]]) {
            [tempHomeModel addObject:model];
        }
    }
    
    // 移除以前的已经加进去的商品列表
    for (HomeCommonProductModel *model in tempHomeModel) {
        [self.dataArr removeObject:model];
    }
    
    // 将新的商品列表添加进去
    [self.dataArr addObjectsFromArray:recommendProductList];
    [self.mainTableView reloadData];
}

/// 移除已经添加进去的推荐品
- (void)removeRecommendProductModel{
    // 查找出以前的已经加进去的商品列表
    NSMutableArray *tempHomeModel = [[NSMutableArray alloc]init];
    for (NSObject *model in self.dataArr) {
        if ([model isKindOfClass:[HomeCommonProductModel class]]) {
            [tempHomeModel addObject:model];
        }
    }
    
    // 移除以前的已经加进去的商品列表
    for (HomeCommonProductModel *model in tempHomeModel) {
        [self.dataArr removeObject:model];
    }
    
    // 移除已经加载的推荐品列表
    [self.recommendProductList removeAllObjects];
    [self.mainTableView reloadData];
}

/// 配置商品cell
- (void)configRecommendProductCell:(SearchProductInfoCell *)cell andCellModel:(HomeCommonProductModel *)cellData andIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cellData.showSequence = indexPath.row + 1;
    //    [cell configCell:cellData];
    [cell configCell:cellData];
    [cell resetCanClickShopAreaForOrder:cellData];
    
    //更新加车数量
    @weakify(self);
    cell.addUpdateProductNum = ^{
        @strongify(self);
        self.selectIndexPath = indexPath;
        [self popAddCarView:cellData];
        NSInteger index = [self.recommendProductList indexOfObject:cellData] + 1;
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S9201" sectionPosition:@"1" sectionName:@"系统推荐商品" itemId:@"I9999" itemPosition:STRING_FORMAT(@"%ld", index) itemName:@"加车" itemContent:STRING_FORMAT(@"%@|%ld", cellData.spuCode,cellData.supplyId) itemTitle:nil extendParams:@{@"storage":[cellData getStorageValue],@"pm_pricez":[cellData getPm_priceValue],@"pm_pmtn_type":[cellData getPm_pmtn_typeValue]} viewController:self];
    };
    
    //到货通知
    cell.productArriveNotice = ^{
        [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_ArrivalProductNoticeVC) setProperty:^(id destinationViewController) {
            ArrivalProductNoticeVC *shopItemVC = (ArrivalProductNoticeVC *)destinationViewController;
            shopItemVC.productId = cellData.spuCode;
            shopItemVC.venderId = [NSString stringWithFormat:@"%ld",cellData.supplyId];
            shopItemVC.productUnit = cellData.packageUnit;
        }];
    };
    
    //跳转到聚宝盆商家专区
    cell.clickJBPContentArea = ^{
        @strongify(self);
        self.noNeedResh = true;
        [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_ShopItem) setProperty:^(id destinationViewController) {
            FKYNewShopItemViewController *shopItemVC = (FKYNewShopItemViewController *)destinationViewController;
            shopItemVC.shopId = [NSString stringWithFormat:@"%ld",(long)cellData.supplyId];
            shopItemVC.shopType = @"1";
            
        }];
    };
    
    //登录
    cell.touchItem = ^{
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil];
    };
    
    //跳转到店铺详情
    cell.clickShopContentArea = ^{
        @strongify(self);
        self.noNeedResh = true;
        NSInteger index = [self.recommendProductList indexOfObject:cellData] + 1;
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S9201" sectionPosition:@"1" sectionName:@"系统推荐商品" itemId:@"I9997" itemPosition:STRING_FORMAT(@"%ld", index) itemName:@"点进店铺" itemContent:STRING_FORMAT(@"%@|%ld", cellData.spuCode,cellData.supplyId) itemTitle:nil extendParams:@{@"storage":[cellData getStorageValue],@"pm_pricez":[cellData getPm_priceValue],@"pm_pmtn_type":[cellData getPm_pmtn_typeValue]} viewController:self];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItem) setProperty:^(id destinationViewController) {
            if ([destinationViewController isKindOfClass:[FKYNewShopItemViewController class]]) {
                FKYNewShopItemViewController *shopVC = (FKYNewShopItemViewController *)destinationViewController;
                shopVC.shopId = [NSString stringWithFormat:@"%ld",cellData.supplyId];
                shopVC.shopType = @"2";
            }
        }];
    };
    
    // 商详
    cell.touchItem = ^{
        @strongify(self);
        self.noNeedResh = true;
        //        weakSelf.itemDetailBI_Record BI埋点参考CouponProductListViewController
        NSInteger index = [self.recommendProductList indexOfObject:cellData] + 1;
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S9201" sectionPosition:@"1" sectionName:@"系统推荐商品" itemId:@"I9998" itemPosition:STRING_FORMAT(@"%ld", index) itemName:@"点进商详" itemContent:STRING_FORMAT(@"%@|%ld", cellData.spuCode,cellData.supplyId) itemTitle:nil extendParams:@{@"storage":[cellData getStorageValue],@"pm_pricez":[cellData getPm_priceValue],@"pm_pmtn_type":[cellData getPm_pmtn_typeValue]} viewController:self];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id destinationViewController) {
            @strongify(self);
            id<FKY_ProdutionDetail> productDelegate = destinationViewController;
            productDelegate.productionId = cellData.spuCode;
            productDelegate.vendorId = [NSString stringWithFormat:@"%ld",cellData.supplyId];
            productDelegate.updateCarNum = ^(NSNumber *carId, NSNumber *num) {
                if (carId != nil) {
                    cellData.carId = carId.intValue;
                }
                if (num != nil) {
                    cellData.carOfCount = num.intValue;
                }
                if (indexPath.row < self.dataArr.count) {
                    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];//reloadRows(at: [indexPath], with: .none)
                }
                else {
                    [self.mainTableView reloadData];
                }
            };
        }];
    };
}

/// 配置订单cell
- (void)configOrderCell:(FKYOrderCell *)orderCell andCellModel:(FKYOrderModel *)cellModel {
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    FKYOrderModel *model = nil;
    //    if (self.dataArr.count) {
    //        model = self.dataArr[indexPath.section];
    //    }
    [orderCell configCellWithModel:cellModel];
    @weakify(self);
    orderCell.settingBtnBlock = ^(NSString *supplyId) {
        @strongify(self);
        [self addBIRecordWithItemName:@"联系客服" itemContent:cellModel.orderId itemPosition:0];
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }else{
            if (cellModel != nil) {
                // flowId：订单id  amount：订单金额 productTypeCount：药品种类
                // orderTime: 下单时间 orderStatus订单状态
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC  *destinationViewController) {
                    NSMutableDictionary *extDic = [NSMutableDictionary new];
                    extDic[@"type"] = @"1";
                    extDic[@"data"] = @{@"flowId":cellModel.orderId,@"amount":cellModel.finalPay,@"productTypeCount":cellModel.varietyNumber,@"orderTime":cellModel.createTime,@"orderStatus":[cellModel getOrderStatus]};
                    destinationViewController.urlPath = [NSString stringWithFormat:@"%@?platform=3&supplyId=%@&ext=%@&openFrom=%d",API_IM_H5_URL,supplyId,extDic.jsonString,2];
                    destinationViewController.navigationController.navigationBarHidden = YES;
                } isModal:false];
            }
        }
    };
}

#pragma mark -- 推荐品cell的响应事件
- (void)popAddCarView:(NSObject *)productModel{
    //    NSString *sourceType = HomeString.
    [self.addCarView configAddCarViewController:productModel :@""];
    [self.addCarView showOrHideAddCarPopView:true :self.view];
    //[self.addCarView showOrHideAddCarPopView:true];
}

/// 刷新单个cell
- (void)refreshSingleCell{
    if (self.selectIndexPath != nil && self.dataArr.count > self.selectIndexPath.section){
        HomeCommonProductModel *product = self.dataArr[self.selectIndexPath.section];
        for (FKYCartModel *cartModel in [FKYCartModel shareInstance].productArr) {
            if ([cartModel isKindOfClass:[FKYCartOfInfoModel class]]) {
                FKYCartOfInfoModel *cartOfInfoModel = (FKYCartOfInfoModel *)cartModel;
                if (cartOfInfoModel.supplyId != nil && [cartOfInfoModel.spuCode isEqualToString:product.spuCode] && cartOfInfoModel.supplyId.intValue == product.supplyId) {
                    product.carOfCount = cartOfInfoModel.buyNum.intValue;
                    product.carId = cartOfInfoModel.cartId.intValue;
                    break;
                }
            }
        }
        [self.mainTableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -- 推荐品相关网络请求

/// 请求推荐品列表
/// @param type 请求类型 1 刷新从第一条数据开始请求  2 加载更多，从最后一条数据开始请求
- (void)requestRecommendProduct:(NSInteger )type{
    if (self.isRequesting) {
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    self.isRequesting = true;
    NSString *pageNo = @"1";
    if (type == 1) {
        pageNo = @"1";
    }else if (type == 2){
        pageNo = [NSString stringWithFormat:@"%ld",self.orderSevice.recommendCurrentPage + 1];
    }
    NSDictionary *param = @{
        @"page":pageNo,
        @"pageSize":[NSString stringWithFormat:@"%ld",(long)self.recommendProductPageSize]
    };
//    @weakify(self);
    [self.orderSevice requestRecommendProductList:param callBack:^(BOOL isSucceed, NSError *error, id response, id model) {
//        @strongify(self);
        self.isRequesting = false;
        if (isSucceed == false) {
            [self toast:error.localizedDescription];
            return ;
        }
        NSDictionary *responseDic = (NSDictionary *)response;
        NSArray *recommendList = responseDic[@"result"];
        for (NSDictionary *productDic in recommendList) {
            HomeCommonProductModel *homeModel = [HomeCommonProductModel transformOrderListModelToHomeCommonProductModel:productDic];
            [self.recommendProductList addObject:homeModel];
        }
        [self apendRecommendProductList:[self.recommendProductList copy]];
        [self ProcessingData];
    }];
}



#pragma mark -- 按钮埋点
- (void)addBIRecordWithItemName:(NSString *)itemName itemContent:(NSString *)itemContent itemPosition:(NSInteger)itemPosition {
    NSString *sectionName  = nil;
    if (self.isOrderSearch) {
        //订单搜索埋点
        sectionName = @"订单搜索结果列表";
    }
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:sectionName itemId:@"I9200" itemPosition:STRING_FORMAT(@"%zd", itemPosition) itemName:itemName itemContent:itemContent itemTitle:nil extendParams:nil viewController:self];
}

/// 套餐优惠曝光埋点
- (void)addDiscountBaoGuangBi{
    if (self.isUploadedDiscountEntryBI == true){
        return;
    }
    self.isUploadedDiscountEntryBI = true;
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I1999" itemPosition:nil itemName:@"有效曝光" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
}


/// 套餐优惠点击埋点
- (void)addDiscountClickBI{
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I0004" itemPosition:@"1" itemName:self.discountPackageViewModel.discountPackage.name itemContent:nil itemTitle:nil extendParams:nil viewController:self];
}

//取消订单增加原因
- (void)cancelOrderWithOrder:(FKYOrderModel *)model  type:(NSString *)type str:(NSString *)str biReason:(NSString *)biReason itemPosition:(NSInteger)itemPosition {
    
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"选择取消订单原因" itemId:@"I9204" itemPosition:STRING_FORMAT(@"%zd", itemPosition) itemName:biReason itemContent:model.orderId itemTitle:nil extendParams:nil viewController:self];
    
    BOOL isSelf = NO;
    if (model.isZiYingFlag == 1 && [model.orderStatus integerValue] == 2) {
        isSelf = YES;
    }
    // 取消订单请求
    @weakify(self);
    [self.orderSevice cancelOrderWithOrderId:model  isSelf:isSelf type:type reason:str success:^(NSString *reason) {
        //
        @strongify(self);
        if (model.payTypeId) {
            if (model.payTypeId.integerValue == 17) {
                [self toast:@"订单取消成功，1药贷额度预计2个工作日恢复"];
            } else {
                [self toast:reason];
            }
        } else {
            [self toast:reason];
        }
        
        [self requestData];
    } failure:^(NSString *reason) {
        @strongify(self);
        if (isSelf) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else {
            [self toast:reason];
        }
    }];
}
#pragma mark ------ view响应事件 --------

-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:FKY_copyButtonClicked]) {/// 复制订单按钮点击 用于埋点的
        NSString *orderID = (NSString *)userInfo[FKYUserParameterKey];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9200" itemPosition:@"16" itemName:@"复制订单号" itemContent:orderID itemTitle:nil extendParams:@{@"pageCode":@"orderManage"} viewController:self];
    }else if ([eventName isEqualToString:@"goInDiscountPackage"]) {// 进入优惠套餐
        //MARK: - 测试方法，务必删除或注释
//        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MatchingPackageVC) setProperty:^(id destinationViewController) {
//
//        }];
//        return;
        [self addDiscountClickBI];
        FKYDiscountPackageModel *entryModel = (FKYDiscountPackageModel *)userInfo[FKYUserParameterKey];
        [(AppDelegate *)[UIApplication sharedApplication].delegate p_openPriveteSchemeString:entryModel.jumpInfo];
    }
}



#pragma mark ------ 懒加载--------
- (ContentHeightManager *)cellHeightManager{
    if (_cellHeightManager == nil) {
        _cellHeightManager = [[ContentHeightManager alloc]init];
    }
    return _cellHeightManager;
}

- (NSMutableArray<HomeCommonProductModel *> *)recommendProductList{
    if (_recommendProductList == nil) {
        _recommendProductList = [[NSMutableArray alloc]init];
    }
    return _recommendProductList;
}

- (JSBadgeView *)badgeView{
    if (_badgeView == nil) {
        _badgeView = [[JSBadgeView alloc]initWithFrame:CGRectZero];
        
    }
    return _badgeView;
}

- (FKYAddCarViewController *)addCarView{
    if (_addCarView == nil) {
        _addCarView = [[FKYAddCarViewController alloc]init];
        _addCarView.finishPoint = CGPointZero;// 无动画
        MJWeakSelf
        _addCarView.addCarSuccess = ^(BOOL isSuccess, NSInteger type, NSInteger productNum, id _Nonnull productModel) {
            
            [weakSelf refreshSingleCell];
        };
        
        _addCarView.clickAddCarBtn = ^(id _Nonnull productModel) {
            if ([productModel isKindOfClass:[HomeCommonProductModel class]]) {
                //                HomeCommonProductModel *homeModel = (HomeCommonProductModel *)productModel;
                // 埋点 参考CouponProductListViewController ->addCarBI_Record
            }
        };
    }
    return _addCarView;
}
@end

