//
//  FKYReceiveProductViewController.m
//  FKY
//
//  Created by mahui on 16/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYReceiveProductViewController.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "FKYOrderService.h"
#import "FKYAccountSchemeProtocol.h"
#import "FKYReceiveProductModel.h"
#import "FKYReceiveModel.h"
#import "UIViewController+ToastOrLoading.h"
#import "FKYJSBHApplyViewController.h"
#import "FKY-Swift.h"


@interface FKYReceiveProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) FKYReceiveConmitView *conmitView;

@property (nonatomic, strong) FKYOrderService *service;
@property (nonatomic, strong) FKYReceiveModel *receiveModel;
@property (nonatomic, strong) NSMutableArray *paraArray;

@end


@implementation FKYReceiveProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self requestDataWithOrderId:self.orderId];
}


#pragma mark - UI

- (void)setupView
{
    [self p_createBar];
    [self createConmitView];
    
    self.mainTableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self->_conmitView.mas_top);
            make.top.equalTo(self->_navBar.mas_bottom);
        }];
        view.dataSource = self;
        view.delegate = self;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        [view registerClass:[FKYReceiveProductCell class] forCellReuseIdentifier:@"FKYReceiveProductCell"];
        view;
    });
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)p_createBar
{
    [self fky_setupNavigationBar];
    
    _navBar = [self fky_NavigationBar];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [_navBar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_navBar.mas_left);
        make.right.equalTo(self->_navBar.mas_right);
        make.bottom.equalTo(self->_navBar.mas_bottom);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"确认收货"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)createConmitView
{
    _conmitView = ({
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
        //@weakify(view);
        __weak typeof(self) weakSelf = self;
        // 确定
        view.conmitCallBack = ^{
            //@strongify(view);
            if ([weakSelf checkReceiveAllOrNot:weakSelf.paraArray]) {
                // 全部收货
                [weakSelf showLoading];
                // 拒收 补货
                [weakSelf.service refusedOrReplenishOrderWithOrderId:weakSelf.orderId andProductList:[weakSelf jsonStringFromArray:weakSelf.paraArray] andApplyType:@"" andApplyCause:@"" andAddressId:nil success:^(NSString *message){
                    // 成功
                    [weakSelf dismissLoading];
//                    if (message && message.length > 0) {
//                        [weakSelf toast:message];
//                    }
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                        destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",ORDER_PJ_HOST,self.orderId];
                        destinationViewController.pushType = 3;
                    } isModal:NO animated:YES];
                    if (self.clickAllProudct) {
                        self.clickAllProudct();
                    }
                    [[FKYNavigator sharedNavigator] removeViewControllerFromNvc:self];
                    //safeBlock(view.cancleCallBack);
                } failure:^(NSString *reason) {
                    // 失败
                    [weakSelf dismissLoading];
                    NSString *tip = @"操作失败";
                    if (reason && reason.length > 0) {
                        tip = reason;
                    }
                    [weakSelf toast:tip];
                }];
            }
            else {
                // 部分收货...<跳转“申请拒收/补货”>
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSBUApplyController) setProperty:^(FKYJSBHApplyViewController *destinationViewController) {
                    destinationViewController.supplyId = self.supplyId;
                    destinationViewController.orderId = self.orderId;
                    destinationViewController.isZiYingFlag = self.isZiYingFlag;
                    destinationViewController.selectDeliveryAddressId = self.selectDeliveryAddressId;
                    destinationViewController.paraString = [self jsonStringFromArray:self.paraArray];
                } isModal:NO];
            }
        };
        // 取消
        view.cancleCallBack =  ^{
            [[FKYNavigator sharedNavigator] pop];
        };
        view;
    });
}


#pragma mark - Request

// 请求当前订单下的商品列表
- (void)requestDataWithOrderId:(NSString *)orderId
{
    [self showLoading];
    @weakify(self);
    [self.service geiReceiveProductListWithOrderId:orderId success:^(FKYReceiveModel *receiveModel) {
        @strongify(self);
        [self dismissLoading];
        self.receiveModel = receiveModel;
        [self getParaArrarData];
        [self.mainTableView reloadData];
    } failure:^(NSString *reason) {
        @strongify(self);
        [self dismissLoading];
        NSString *tip = @"数据请求失败，请返回重试";
        if (reason && reason.length > 0) {
            tip = reason;
        }
        [self toast:tip];
    }];
}


#pragma mark - Private

// 生成下个接口所需的参数
- (void)getParaArrarData
{
    [self.paraArray removeAllObjects];
    if (self.receiveModel && self.receiveModel.productList && self.receiveModel.productList.count > 0) {
        for (FKYReceiveProductModel *model in self.receiveModel.productList) {
            // 请求到数据后，需要更新inputNumber及对应商品索引
            model.inputNumber = model.deliveryProductCount.integerValue;
            //
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"orderDetailId"] = model.orderDetailId ? model.orderDetailId : @"";
            dic[@"batchId"] = model.batchId ? model.batchId : @"";
            dic[@"buyNumber"] = model.deliveryProductCount ? model.deliveryProductCount : @"";
            [self.paraArray addObject:dic];
        } // for
    }
}

// 参数转json
- (NSString *)jsonStringFromArray:(NSArray *)array
{
    if (!array.count) {
        return  @"[]";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

// 判断用户对订单中的商品是否全收
- (BOOL)checkReceiveAllOrNot:(NSArray *)array
{
    for (FKYReceiveProductModel *model in self.receiveModel.productList) {
        for (NSDictionary *dic in array) {
            NSNumber *pid = dic[@"orderDetailId"];
            if (pid && model.orderDetailId && pid.integerValue == model.orderDetailId.integerValue) {
                NSNumber *bNumber = dic[@"buyNumber"];
                if (bNumber && model.deliveryProductCount && bNumber.integerValue != model.deliveryProductCount.integerValue) {
                    // 非全收
                    return NO;
                }
            }
        }
    }
    // 全收
    return YES;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.receiveModel && self.receiveModel.productList && self.receiveModel.productList.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.receiveModel.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKYReceiveProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYReceiveProductCell" forIndexPath:indexPath];
    // 配置cell
    FKYReceiveProductModel *model = self.receiveModel.productList[indexPath.row];
    [cell configCellWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 更改数量
    @weakify(self);
    cell.nowCountBolock = ^(NSInteger count, FKYReceiveProductModel *item){
        @strongify(self);
        item.inputNumber = count;
        for (NSMutableDictionary *dic in self.paraArray) {
            NSNumber *pid = dic[@"orderDetailId"];
            if (pid && item && item.orderDetailId && pid.integerValue == item.orderDetailId.integerValue) {
                dic[@"buyNumber"] = [NSNumber numberWithInteger:count];
                break;
            }
        } // for
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FKYWH(120);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FKYReceiveHeader *header = (FKYReceiveHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYReceiveHeader"];
    if (!header) {
        header = [[FKYReceiveHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(80))];
        header.backgroundColor = [UIColor whiteColor];
    }
    [header configCellWithModel:self.receiveModel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FKYWH(80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - getter

- (FKYOrderService *)service
{
    if (!_service) {
        _service = [[FKYOrderService alloc] init];
    }
    return _service;
}

- (NSMutableArray *)paraArray
{
    if (!_paraArray) {
        _paraArray = @[].mutableCopy;
    }
    return _paraArray;
}


@end
