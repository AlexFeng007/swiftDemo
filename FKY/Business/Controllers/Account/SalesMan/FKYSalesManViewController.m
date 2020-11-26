//
//  FKYSalesManViewController.m
//  FKY
//
//  Created by 寒山 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSalesManViewController.h"
#import <Masonry/Masonry.h>
#import "FKYNavigator.h"
#import "FKYNavigationController.h"
#import "UIViewController+NavigationBar.h"
#import "FKYSalesManInfoTableViewCell.h"
#import "FKYSalesManEmptyView.h"
#import "FKYSalesManService.h"
#import "FKYSalesManModel.h"
#import "UIViewController+ToastOrLoading.h"
#import <MJRefresh/MJRefresh.h>

@interface FKYSalesManViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  UITableView *mainTableView;
@property (nonatomic, strong)  NSMutableArray *dataSoure;
@property (nonatomic, strong)  FKYSalesManService *salesManService;
@property (nonatomic, strong)  FKYSalesManEmptyView *emptyView;
@end

@implementation FKYSalesManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSoure = [NSMutableArray array];
    self.salesManService = [FKYSalesManService new];
    [self p_setupUI];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)requestData
{
    [self.salesManService getSalesManListInfoSuccess:^(BOOL mutiplyPage) {
        [self.dataSoure addObject: self.salesManService.salesManModel];
        //[self emptyViewStatus];
        [self.mainTableView reloadData];
    } failure:^(NSString *reason) {
        [self toast:reason];
    }];
}

- (void)p_setupUI
{
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
    [self fky_setupNavigationBarWithTitle:@"负责业务员"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    bar.backgroundColor = [UIColor whiteColor];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
    self.mainTableView = ({
        UITableView *view = [[UITableView alloc] init];
        [view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(bar.mas_bottom);
        }];
        [view registerClass:[FKYSalesManInfoTableViewCell class] forCellReuseIdentifier:@"FKYSalesManInfoTableViewCell"];
        view.delegate = self;
        view.backgroundColor = UIColorFromRGB(0xeae9e9);
        view.dataSource = self;
        view;
    });
    
    self.emptyView = ({
        FKYSalesManEmptyView *view = [[FKYSalesManEmptyView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(FKYWH(64));
        }];
        view;
    });
    [self.view sendSubviewToBack:self.emptyView];
}

- (void)emptyViewStatus
{
    if (self.dataSoure.count != 0) {
        [self.view sendSubviewToBack:self.emptyView];
    }else{
        [self.view bringSubviewToFront:self.emptyView];
    }
}


#pragma mark - tabelView delegate datasore

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FKYSalesManInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYSalesManInfoTableViewCell" forIndexPath:indexPath];
    [cell configCell:self.dataSoure[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FKYWH(50);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
