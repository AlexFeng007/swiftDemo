//
//  FKYRefuseListViewController.m
//  FKY
//
//  Created by yangyouyong on 2016/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYRefuseListViewController.h"
#import "FKYOrderCell.h"
#import "FKYTopBar.h"
#import <Masonry/Masonry.h>
#import "UIViewController+ToastOrLoading.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "FKYOrderModel.h"
#import "FKYRefuseOrderService.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "FKYAccountSchemeProtocol.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYJSOrderDetailViewController.h"
#import "FKYStaticView.h"
#import "FKYOrderCellFooter.h"
#import "FKYProductAlertView.h"


@interface FKYRefuseListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, assign) NSInteger buttonSelectedIndex;
@property (nonatomic, strong) FKYTopBar *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *addTableView;
@property (nonatomic, strong) UITableView *refuseTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *refuseDataArray;
@property (nonatomic, strong) FKYRefuseOrderService *service;
@property (nonatomic, strong) FKYStaticView *emptyView;
@property (nonatomic, strong) FKYStaticView *refuseEmptyView;
@property (nonatomic, strong) FKYAllAfterSaleListView *saleListView;//退换货/售后
@property (nonatomic, strong) RCViewModel *rcAllViewModel;//请求model

@end

@implementation FKYRefuseListViewController

-(RCViewModel *)rcAllViewModel{
    if (!_rcAllViewModel) {
        _rcAllViewModel = [RCViewModel new];
    }
    return _rcAllViewModel;
}

-(FKYAllAfterSaleListView *)saleListView{
    if (!_saleListView) {
        _saleListView = [FKYAllAfterSaleListView new];
         @weakify(self);
        _saleListView.reloadMoreSaleListData = ^(NSInteger typeIndex){
            @strongify(self);
            if (typeIndex == 1) {
                //刷新
                [self getApplyList:@"1"];
            }else {
                //加载更多
                [self getApplyList:@"0"];
            }
        };
        //取消申请
        _saleListView.calcelRCOrderBlock = ^(FKYAllAfterSaleModel *model){
             @strongify(self);
            [self calcelRcOrder:model];
        };
        //toast
        _saleListView.viewControllerToast= ^(NSString *toast){
             @strongify(self);
            [self toast:toast];
        };
    }
    return _saleListView;
}

- (void)loadView
{
    [super loadView];
    [self setupView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.service = [FKYRefuseOrderService new];
    
    @weakify(self);
    [self.refuseTableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self getNext:@"800"];
    } position:SVPullToRefreshPositionBottom];
    
    [self.addTableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self getNext:@"900"];
    } position:SVPullToRefreshPositionBottom];
    
    if (self.listType == DEFAULT) {
        //退换货/售后
        [self.headerView allOrderStatusViewSelectedButtonTag:101];
    }else if (self.listType == JS){
        //拒收
        [self.headerView allOrderStatusViewSelectedButtonTag:102];
        
    }else if (self.listType == BH){
        //补货
        [self.headerView allOrderStatusViewSelectedButtonTag:103];
    }
    [self getApplyList:@"1"];
    [self getOrderList:@"800"];
    [self getOrderList:@"900"];
}

#pragma mark - UI

- (void)setupView
{
    self.navBar = [self fky_NavigationBar];
    self.navBar.backgroundColor = UIColorFromRGB(0xffffff);
    [self fky_setNavigationBarTitle:@"退换货/售后"];
    [self fky_setTitleColor:UIColorFromRGB(0x0)];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
    self.headerView = [[FKYTopBar alloc] init];
    self.headerView.backgroundColor = UIColorFromRGB(0xffffff);
    self.headerView.selectedColor = UIColorFromRGB(0xFF3563);
    self.headerView.titleArray = @[@"退换货/售后",@"拒收",@"补货"];
    self.headerView.frame = CGRectMake(0,FKYWH(64), SCREEN_WIDTH, FKYWH(44));
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            self.headerView.frame = CGRectMake(0,FKYWH(iPhoneX_SafeArea_TopInset), SCREEN_WIDTH, FKYWH(44));
        }
    }
    //self.headerView.lineWidth = FKYWH(40);
    self.headerView.lineHeight = FKYWH(2);
    self.headerView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, FKYWH(44));
    @weakify(self);
    self.headerView.buttonClickBlock = ^(NSInteger integer){
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake((integer - 101) * SCREEN_WIDTH, 0) animated:YES];
        if (integer == 101) {
            //退换货/售后接口
            self.buttonSelectedIndex = 0;
        }else if (integer == 102){
            //拒收列表
            self.buttonSelectedIndex = 1;
        }else if (integer == 103){
            //补货列表
            self.buttonSelectedIndex = 2;
        }
    };
    [self.view addSubview:self.headerView];
    
    self.scrollView = ({
        UIScrollView *sv = [UIScrollView new];
        sv.backgroundColor = UIColorFromRGB(0xf2f2f2);
        sv.pagingEnabled = true;
        sv.delegate = self;
        sv.bounces = NO;
        sv.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:sv];
        [sv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        sv;
    });
    
    self.contentView =({
        UIView *v = [UIView new];
        [self.scrollView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        v;
    });
    [self.contentView addSubview:self.saleListView];
    [self.saleListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.bottom.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    self.refuseTableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [tv registerClass:[FKYOrderCell class] forCellReuseIdentifier:@"FKYOrderRefuseCell"];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.tag = 800;
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                tv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                tv.scrollIndicatorInsets = tv.contentInset;
            }
        }
        
        [self.contentView addSubview:tv];
        [tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.saleListView.mas_right);
            make.width.top.bottom.equalTo(self.saleListView);
        }];
        tv;
    });
    
    self.addTableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [tv registerClass:[FKYOrderCell class] forCellReuseIdentifier:@"FKYOrderCell"];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.tag = 900;
        [self.contentView addSubview:tv];
        [tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.refuseTableView.mas_right);
            make.width.top.bottom.equalTo(self.refuseTableView);
        }];
        tv;
    });
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addTableView.mas_right);
    }];
    
    self.emptyView = ({
        FKYStaticView *view = [FKYStaticView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.addTableView);
        }];
        [view configView:@"icon_search_empty"
                   title:@"暂无结果"
                btnTitle:@"去首页逛逛"];
        view.actionBlock = ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
                destinationViewController.index = 0;
            }];
        };
        [self.contentView insertSubview:view belowSubview:self.addTableView];
        view;
    });
    
    self.refuseEmptyView = ({
        FKYStaticView *view = [FKYStaticView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.refuseTableView);
        }];
        [view configView:@"icon_search_empty"
                   title:@"暂无结果"
                btnTitle:@"去首页逛逛"];
        view.actionBlock = ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
                destinationViewController.index = 0;
            }];
        };
        [self.contentView insertSubview:view belowSubview:self.refuseTableView];
        view;
    });
}


#pragma mark - Request

- (void)getOrderList:(NSString *)status
{
    [self showLoading];
    [self.service getOrderList:status Success:^(BOOL mutiplyPage) {
           [self dismissLoading];
           if (status.integerValue == 800) {
               [self.refuseTableView reloadData];
               if (self.service.refuseOrderArray.count <= 0) {
                   [self.contentView insertSubview:self.refuseEmptyView
                                      aboveSubview:self.refuseTableView];
               }else{
                   [self.contentView insertSubview:self.refuseEmptyView
                                      belowSubview:self.refuseTableView];
               }
           }else{
               [self.addTableView reloadData];
               if (self.service.addOrderArray.count <= 0) {
                   [self.contentView insertSubview:self.emptyView
                                      aboveSubview:self.addTableView];
               }else{
                   [self.contentView insertSubview:self.emptyView
                                      belowSubview:self.addTableView];
               }
           }
    } failure:^(NSString *reason) {
           [self dismissLoading];
           [self toast:reason];
           if (status.integerValue == 800) {
               [self.contentView insertSubview:self.refuseEmptyView
                                  aboveSubview:self.refuseTableView];
           }else{
               [self.contentView insertSubview:self.emptyView
                                  aboveSubview:self.addTableView];
           }
    }];
}

- (void)getNext:(NSString *)status
{
    if ([self.service hasNext:status]) {
        [self showLoading];
        [self.service getNext:status Success:^(BOOL mutiplyPage) {
            [self dismissLoading];
            if (status.integerValue == 800) {
                [self.refuseTableView reloadData];
                [self.refuseTableView.pullToRefreshView stopAnimating];
            }else{
                [self.addTableView reloadData];
                [self.addTableView.pullToRefreshView stopAnimating];
            }
        } failure:^(NSString *reason) {
            [self dismissLoading];
            [self toast:reason];
            if (status.integerValue == 800) {
                [self.refuseTableView.pullToRefreshView stopAnimating];
            }else{
                [self.addTableView.pullToRefreshView stopAnimating];
            }
            
        }];
    }else{
        [self.refuseTableView.pullToRefreshView stopAnimating];
        [self.addTableView.pullToRefreshView stopAnimating];
    }
}
//获取申请记录
-(void)getApplyList:(NSString *)type{
    [self showLoading];
    @weakify(self);
    [self.rcAllViewModel getAllWorkOrderListWithParams:type callback:^(NSArray<FKYAllAfterSaleModel *> *dataArr) {
        @strongify(self);
        [self dismissLoading];
        [self.saleListView configDataWithArr:self.rcAllViewModel.applyList :[self.rcAllViewModel hasNextPage]];
    } fail:^(NSString *msg) {
        @strongify(self);
        [self.saleListView endFreshView:[self.rcAllViewModel hasNextPage]];
        [self dismissLoading];
        [self toast:msg];
    }];
}
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

//撤销退换货申请
-(void)calcelRcOrder:(FKYAllAfterSaleModel *)model {
    [self showLoading];
    @weakify(self);
    BOOL isMp = ([model.popFlag isEqual: @"3"] ? true : false);
    NSString *desId = @"";
    if(isMp) {
        desId = model.asAndWorkOrderNo;
    }else{
        desId = model.asAndWorkOrderId;
    }
    [self.rcAllViewModel cancleOcsRmaApplyDataWithParams:desId :isMp callback:^(NSArray<RCListModel *> *dataArr) {
        @strongify(self);
        [self dismissLoading];
        model.easOrderstatus = @"ASWD";
        model.easOrderstatusStr = @"已取消";
        [self.saleListView configDataWithArr:self.rcAllViewModel.applyList :[self.rcAllViewModel hasNextPage]];
    } fail:^(NSString *msg) {
        @strongify(self);
         [self dismissLoading];
         [self toast:msg];
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 800) {
        return self.service.refuseOrderArray.count;
    }
    return self.service.addOrderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.refuseTableView) {
        FKYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderRefuseCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FKYOrderModel *model = self.service.refuseOrderArray[indexPath.section];
        [cell configCellWithModel:model];
        return cell;
    }else{
        FKYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FKYOrderModel *model = self.service.addOrderArray[indexPath.section];
        [cell configCellWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FKYWH(165);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? FKYWH(0.001) : FKYWH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    FKYOrderModel *model = nil;
    if (tableView == self.refuseTableView) {
        model = self.service.refuseOrderArray[section];
    }else{
        model = self.service.addOrderArray[section];
    }
    NSString *string = [model getOrderStatus];
    if ([string isEqualToString:orderStatus_receive]) {
        BOOL showFlag = [model getHandleBarShowStatus];
        return showFlag ? FKYWH(45+48) : FKYWH(48+5);
    }else{
        return FKYWH(0.001);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    FKYOrderModel *model = nil;
    if (tableView == self.refuseTableView) {
        model = self.service.refuseOrderArray[section];
    } else {
        model = self.service.addOrderArray[section];
    }
    NSString *string = [model getOrderStatus];
    if ([string isEqualToString:orderStatus_receive]) {
        FKYOrderCellFooter *view = (FKYOrderCellFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYOrderCellFooter"];
        if (!view) {
            view = [[FKYOrderCellFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(44))];
        }
        [view configViewWithModel:model andTimeOffset:0];
        @weakify(self);
        view.receiveBlock = ^(){
             @strongify(self);
            [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"否" rightTitle:@"是" message:@"是否确认收货" handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                if (isRight) {
                    [self showLoading];
                    NSString *exceptionId = [NSString stringWithFormat:@"%@",model.exceptionOrderId];
                    [self.service commitOrder:exceptionId success:^(BOOL mutiplyPage) {
                        [self getOrderList:@"900"];
                    } failure:^(NSString *reason) {
                        [self dismissLoading];
                        [self toast:reason];
                    }];
                }
            }];
        };
        // 查看物流
        view.checkBlock = ^{
            @strongify(self);
            [self pushToLogisticsDetailJSControllerWithModel:model];
        };
        return view;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(10))];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKYOrderModel *model = nil;
    NSString *statusCode = @"";
    if (tableView == self.refuseTableView) {
        model = self.service.refuseOrderArray[indexPath.section];
        statusCode = @"800";
    }else{
        model = self.service.addOrderArray[indexPath.section];
        statusCode = @"900";
    }
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController)
                                   setProperty:^(FKYJSOrderDetailViewController *destinationViewController) {
                                       destinationViewController.orderModel = model;
                                       destinationViewController.statusCode = statusCode;
                                   }];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]
                             animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x == 0 && self.buttonSelectedIndex != 0) {
            self.buttonSelectedIndex = 0;
            UIButton *btn = [self.headerView viewWithTag:101];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else if (scrollView.contentOffset.x == SCREEN_WIDTH && self.buttonSelectedIndex != 1) {
            self.buttonSelectedIndex = 1;
            UIButton *btn = [self.headerView viewWithTag:102];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else if (scrollView.contentOffset.x == 2*SCREEN_WIDTH && self.buttonSelectedIndex != 2){
            self.buttonSelectedIndex = 2;
            UIButton *btn = [self.headerView viewWithTag:103];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}


@end
