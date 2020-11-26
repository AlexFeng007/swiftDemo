//
//  FKYLogisticsDetailViewController.m
//  FKY
//
//  Created by zengyao on 2017/6/6.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYLogisticsDetailViewController.h"
#import "FKYSplitDetailHeaderView.h"
#import "FKYLogisticFollowCell.h"
#import "FKYSplitDetailCell.h"
#import "FKYOrderService.h"


@interface FKYLogisticsDetailViewController () <UITableViewDelegate, UITableViewDataSource, FKYSplitDetailHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSMutableArray *modelsArr;
@property (nonatomic, strong) FKYDeliveryHeadModel *deliveryHeadModel;
@property (nonatomic, strong) FKYSplitDetailHeaderView *headerView;     // 物流顶部信息栏

@end


@implementation FKYLogisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self requestData];
}

- (void)requestData {
    self.modelsArr = [NSMutableArray array];
    if (_isRCType) {
        [self.modelsArr addObjectsFromArray:self.expressList];
        self->_deliveryHeadModel = [[FKYDeliveryHeadModel alloc] init];
        _deliveryHeadModel.carrierName = self.expresssName;
        _deliveryHeadModel.expressNum = self.expresssID;
        _deliveryHeadModel.status = self.expressState;
         [self->_headerView bindModel:self.deliveryHeadModel];
         [self.tableView reloadData];
    }
    else {
        FKYOrderService *service = [[FKYOrderService alloc] init];
        [self showLoading];
        // 物流title数据
        [service getDeliveryTitleWithOrderId:self.orderId success:^(FKYDeliveryHeadModel *model) {
            [self dismissLoading];
            self->_deliveryHeadModel = model;
            [self->_headerView bindModel:self.deliveryHeadModel];
            [self->_tableView reloadData];
        } failure:^(NSString *reason) {
            [self dismissLoading];
            [self toast:reason];
        }];
        
        // 物流详情数据
        [service getDeliveryDetailWithOrderId:self.orderId success:^(NSMutableArray *modelsArr) {
            [self dismissLoading];
            self->_modelsArr = modelsArr;
            [self->_tableView reloadData];
        } failure:^(NSString *reason) {
            [self dismissLoading];
            [self toast:reason];
        }];
    }
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
    [self fky_setupNavigationBarWithTitle:@"物流详情"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)setupView {
    [self tableBar];
    self.tableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:table];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self->_navBar.mas_bottom);
        }];
        [table registerClass:[FKYSplitDetailCell class] forCellReuseIdentifier:@"FKYSplitDetailCell"];
        [table registerClass:[FKYLogisticFollowCell class] forCellReuseIdentifier:@"FKYLogisticFollowCell"];
        table.dataSource = self;
        table.delegate = self;
        table.backgroundColor = UIColorFromRGB(0xf4f4f4);
        table.tableHeaderView = self.headerView;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FKYLogisticFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLogisticFollowCell" forIndexPath:indexPath];
        return cell;
    }

    static NSString *identifier = @"FKYSplitDetailCell";
    FKYSplitDetailCell *splitCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!splitCell) {
        splitCell = [[FKYSplitDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_isRCType) {
        if ([[self.modelsArr objectAtIndex:indexPath.row - 1] isKindOfClass:[RCExpressInfoModel class]]) {
            RCExpressInfoModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row - 1];
            [splitCell configureModel:splitModel indexPath:indexPath];
        }
        else {
            RCLogistInfoModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row - 1];
            [splitCell configureModel:splitModel indexPath:indexPath];
        }
    }
    else {
        FKYDeliveryItemModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row -1];
        [splitCell configureModel:splitModel indexPath:indexPath];
    }
    return splitCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return FKYWH(45);
    }
    
    static NSString *identifier = @"FKYSplitDetailCell";
    static FKYSplitDetailCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FKYSplitDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    });
    
    if (_isRCType) {
        if ([[self.modelsArr objectAtIndex:indexPath.row -1] isKindOfClass:[RCExpressInfoModel class]]) {
            RCExpressInfoModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row -1];
            NSString *remark = splitModel.context;
            if (!remark || remark.length == 0) {
                return CGFLOAT_MIN;
            }
            CGFloat height = [cell calulateHeightWithModel:splitModel indexPath:indexPath];
            return height;
        }
        else if ([[self.modelsArr objectAtIndex:indexPath.row -1] isKindOfClass:[RCLogistInfoModel class]]) {
            RCLogistInfoModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row -1];
            NSString *remark = splitModel.remark;
            if (!remark || remark.length == 0) {
                return CGFLOAT_MIN;
            }
            CGFloat height = [cell calulateHeightWithModel:splitModel indexPath:indexPath];
            return height;
        }
        return 0;
    }
    else {
        FKYDeliveryItemModel *splitModel = [self.modelsArr objectAtIndex:indexPath.row-1];
        NSString *remark = splitModel.remark;
        if (!remark || remark.length == 0) {
            return CGFLOAT_MIN;
        }
        CGFloat height = [cell calulateHeightWithModel:splitModel indexPath:indexPath];
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    return separator;
}


#pragma mark - property

- (FKYSplitDetailHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[FKYSplitDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        _headerView.delegate = self;
        @weakify(self);
        _headerView.copyBlock = ^(){
            @strongify(self);
            [self toast:@"复制成功"];
        };
    }
    return _headerView;
}

@end
