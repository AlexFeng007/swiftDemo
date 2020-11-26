//
//  FKYOrderDetailMoreInfoViewController.m
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailMoreInfoViewController.h"
#import "FKYNavigator.h"
#import "UIViewController+NavigationBar.h"
#import <Masonry/Masonry.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

#import "FKY-Swift.h"

#import "FKYOrderService.h"
#import "FKYOrderModel.h"
#import "FKYMoreInfoModel.h"

@interface FKYOrderDetailMoreInfoViewController () <UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong)  UITableView *mainTabelView;
@property (nonatomic, strong) FKYMoreInfoModel *moreInfoModel;

@end

@implementation FKYOrderDetailMoreInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self P_setNavigationBar];
    [self p_setupUI];
    [self requestData];
    self.view.backgroundColor = UIColorFromRGB(0xebedec);
}

- (void)requestData{
    FKYOrderService *service = [[FKYOrderService alloc] init];
    [self showLoading];
    [service orderDetailMoreInfo:self.orderModel.orderId success:^(FKYMoreInfoModel *model){
        [self dismissLoading];
        self.moreInfoModel = model;
        [self.mainTabelView reloadData];
        
    } failure:^(NSString *reason) {
        [self dismissLoading];
        [self toast:reason];
    }];
}

- (void)P_setNavigationBar{
    [self fky_setupNavigationBar];
    UIView *bar = [self fky_NavigationBar];
    UIView *view = [[UIView alloc] init];
    [bar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bar.mas_left);
        make.right.equalTo(bar.mas_right);
        make.bottom.equalTo(bar.mas_bottom);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"取消订单详情"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)p_setupUI{
    self.mainTabelView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectMake(0, FKYWH(64), SCREEN_WIDTH, SCREEN_HEIGHT - FKYWH(64))];
        [self.view addSubview:view];
        view.dataSource = self;
        view.delegate = self;
        [view registerClass:[FKYSingleTitleCell class] forCellReuseIdentifier:@"FKYSingleTitleCell"];
        view.backgroundColor = UIColorFromRGB(0xf4f4f4);
        view;
    });
    
    [self.mainTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo([self fky_NavigationBar].mas_bottom);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.detailModel numberOfPropertyForOrderStatus:self.orderStatus];
    return 2;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    FKYSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYSingleTitleCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell configCellWithText:self.moreInfoModel.cancelResult cellType:FKYSingleTitleCellTypeCancleReason];
    }else{
        [cell configCellWithText:self.moreInfoModel.cancelTime cellType:FKYSingleTitleCellTypeCancleTime];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FKYWH(44);
}


@end
