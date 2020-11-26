//
//  FKYJSBHApplyViewController.m
//  FKY
//
//  Created by mahui on 16/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYJSBHApplyViewController.h"
#import "FKYNavigator.h"
#import "UIViewController+NavigationBar.h"
#import "FKYOrderService.h"
#import "FKYWarnView.h"
#import "FKYRefuseListViewController.h"
//#import "FKYAccountViewController.h"
#import "FKY-Swift.h"


@interface FKYJSBHApplyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) FKYOrderService *service;
@property (nonatomic, strong) FKYReceiveConmitView *conmitView;
@property (nonatomic, strong) FKYWarnView *warnView;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *reason;

@end


@implementation FKYJSBHApplyViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Data

- (void)setupData
{
    self.selectedIndex = -1;
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
}


#pragma mark - UI

- (void)setupView
{
    [self createNavbar];
    [self createCommitView];
    [self creatTableView];
}

- (void)createNavbar
{
    [self fky_setupNavigationBar];
    _navBar = [self fky_NavigationBar];
    UIView *view = [[UIView alloc] init];
    [_navBar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_navBar.mas_left);
        make.right.equalTo(self->_navBar.mas_right);
        make.bottom.equalTo(self->_navBar.mas_bottom);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"申请拒收/补货"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)createCommitView
{
    self.conmitView = ({
        FKYReceiveConmitView *view = [[FKYReceiveConmitView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(FKYWH(60)));
            // iPhoneX适配
            if (@available(iOS 11, *)) {
                UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
                if (insets.bottom > 0) {
                    // iPhoneX
                    make.bottom.equalTo(self.view).offset(-FKYWH(iPhoneX_SafeArea_BottomInset));
                } else {
                    make.bottom.equalTo(self.view);
                }
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
        // 确定
        view.conmitCallBack = ^{
            if (self.selectedIndex < 0) {
                [self toast:@"请先选择类型"];
                return;
            }
            __weak typeof(self) weakSelf = self;
            [self.service refusedOrReplenishOrderWithOrderId:self.orderId andProductList:self.paraString andApplyType:[self getType] andApplyCause:self.reason andAddressId:self.selectDeliveryAddressId success:^(NSString *message){
                [weakSelf dismissLoading];
                [weakSelf toast:message];
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 4;
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RefuseOrder) setProperty:^(FKYRefuseListViewController* destinationViewController) {
                        destinationViewController.listType = self.selectedIndex == 1 ? BH : JS;
                        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                            destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",ORDER_PJ_HOST,self.orderId];
                            destinationViewController.pushType = 4;
                        } isModal:NO animated:YES];
                    }];
                }];
            } failure:^(NSString *reason) {
                [weakSelf dismissLoading];
                [weakSelf toast:reason];
            }];
        };
        // 取消
        view.cancleCallBack =  ^{
            [[FKYNavigator sharedNavigator] pop];
        };
        view;
    });
}

- (void)creatTableView
{
    self.warnView = ({
        FKYWarnView *view = [[FKYWarnView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_navBar.mas_bottom);
            make.left.right.equalTo(_navBar);
            make.height.equalTo(@(FKYWH(30)));
        }];
        [view configViewWithType:FKYWarnViewTypeJSBU];
        view;
    });
    
    self.mainTableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(FKYWH(250)));
            make.top.equalTo(_warnView.mas_bottom);
        }];
        [view registerClass:[FKYJSTypeCell class] forCellReuseIdentifier:@"FKYJSTypeCell"];
        [view registerClass:[FKYJSReasonCell class] forCellReuseIdentifier:@"FKYJSReasonCell"];
        view.dataSource = self;
        view.delegate = self;
        view.scrollEnabled = NO;
        view;
    });
}


#pragma mark - Private

- (NSString *)getType
{
    // 申请类型(4:拒收,3:补货)
    return self.selectedIndex == 1 ? @"3" : @"4";
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? (self.isZiYingFlag == 1 ? 1 : 2): 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        FKYJSTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYJSTypeCell" forIndexPath:indexPath];
        cell.cellIsSelected(self.selectedIndex == indexPath.row);
        if (indexPath.row == 0) {
            [cell configCellWithTypw:FKYJSTypeCellTypeJs];
        }
        if (indexPath.row == 1) {
            [cell configCellWithTypw:FKYJSTypeCellTypeBh];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        FKYJSReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYJSReasonCell" forIndexPath:indexPath];
        cell.textViewDidEndEditing = ^(NSString *title){
            self.reason = title;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? FKYWH(45) : FKYWH(160);
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.selectedIndex = indexPath.row;
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? FKYWH(10) : FKYWH(0.01);
}


#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.mainTableView endEditing:YES];
}


#pragma mark - Property

- (FKYOrderService *)service
{
    if (!_service) {
        _service = [[FKYOrderService alloc] init];
    }
    return _service;
}


@end
