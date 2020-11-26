//
//  FKYLogisticsViewController.m
//  FKY
//
//  Created by mahui on 16/9/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYLogisticsViewController.h"
#import "FKYNavigator.h"
#import "UIViewController+NavigationBar.h"
#import "FKYOrderModel.h"
#import "FKYOrderService.h"


@interface FKYLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) FKYDeliveryModel *deliveryModel;

@end


@implementation FKYLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self requestData];
}

- (void)requestData {
    FKYOrderService *service = [[FKYOrderService alloc] init];
    [service getDeliveryInfoWithType:@"1" andOrderId:self.orderId success:^(FKYDeliveryModel *model) {
        self->_deliveryModel = model;
        [self->_tableView reloadData];
    } failure:^(NSString *reason) {
        [self toast:reason];
    }];
}

- (void)tableBar {
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
    [self fky_setupNavigationBarWithTitle:self.deliveryType];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)setupView {
    [self tableBar];
    self.tableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self->_navBar.mas_bottom);
        }];
        [view registerClass:[FKYSingleTitleCell class] forCellReuseIdentifier:@"FKYSingleTitleCell"];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = UIColorFromRGB(0xf4f4f4);
        view;
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.deliveryType isEqualToString:deliveryMethod_own]) {
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FKYSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYSingleTitleCell" forIndexPath:indexPath];
    if ([self.deliveryType isEqualToString:deliveryMethod_own]) {
        if (indexPath.row == 0) {
            [cell configCellWithText:_deliveryModel.deliveryDate cellType:FKYSingleTitleCellTypeReceiveTime];
        }
        if (indexPath.row == 1) {
            [cell configCellWithText:_deliveryModel.deliveryPerson cellType:FKYSingleTitleCellTypePersonName];
        }
        if (indexPath.row == 2) {
            [cell configCellWithText:_deliveryModel.deliveryContactPhone cellType:FKYSingleTitleCellTypeTelephone];
        }
    }else{
        if (indexPath.row == 0) {
            [cell configCellWithText:_deliveryModel.deliveryContactPerson cellType:FKYSingleTitleCellTypeFactory];
        }
        
        if (indexPath.row == 1) {
            [cell configCellWithText:_deliveryModel.deliveryExpressNo cellType:FKYSingleTitleCellTypeLogisticsId];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FKYWH(35);
}


@end
