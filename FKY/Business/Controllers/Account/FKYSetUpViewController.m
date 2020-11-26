//
//  FKYSetUpViewController.m
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYSetUpViewController.h"
#import "FKYSetUpCell.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "UIViewController+ToastOrLoading.h"
#import "FKYLoginAPI.h"
#import "FKYVersionCheckService.h"
#import "AppDelegate.h"
#import "FKYAccountSchemeProtocol.h"
#import "FKYAlertView.h"
#import "FKYProductAlertView.h"


@interface FKYSetUpViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  UITableView *mainTableView;
@property (nonatomic, strong)  NSArray *dataArray;
@property (nonatomic, strong)  UIButton *logoutBtn;

@end


@implementation FKYSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        self.dataArray = @[@"版本号",@"隐私条款",@"用户协议",@"关于我们",@"修改密码"];
    }else{
        self.dataArray = @[@"版本号",@"隐私条款",@"用户协议",@"关于我们"];
    }
    // FKYLoginAPI.currentUser.mobile = @"13707196529";
    [self p_createBar];
    [self p_createTableView];
}

- (void)p_createBar
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
    view.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [self fky_setupNavigationBarWithTitle:@"设置"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    bar.backgroundColor = [UIColor whiteColor];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
}

- (void)p_createTableView
{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView registerClass:[FKYSetUpCell class] forCellReuseIdentifier:@"FKYSetUpCell"];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    NSInteger cellCount = self.dataArray.count;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - FKYWH(44 * (cellCount) + 8*(cellCount-1) + 64 + 18))];
    _mainTableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:_mainTableView];
    UIView *bar = [self fky_NavigationBar];
    
    __weak typeof(self) weakSelf = self;
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-FKYWH(60));
    }];
    
    UIView *footView =  [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(FKYWH(60)));
    }];
    
    
    self.logoutBtn = [UIButton new];
    _logoutBtn.backgroundColor = UIColorFromRGB(0xfe5050);
    _logoutBtn.titleLabel.font = FKYSystemFont(FKYWH(16));
    [_logoutBtn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    _logoutBtn.layer.cornerRadius = FKYWH(3);
    _logoutBtn.layer.masksToBounds = YES;
    @weakify(self);
    [_logoutBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        // 注销
        [FKYLoginAPI logoutSuccess:^(BOOL mutiplyPage) {
            // 返回
            [[FKYNavigator sharedNavigator] pop];
        } failure:^(NSString *reason) {
            [self toast:reason];
        }];
        // 百度移动统计之事件统计
       // [[BaiduMobStat defaultStat] logEvent:@"logout" eventLabel:@"退出登录"];
    } forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_logoutBtn];
    [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(FKYWH(15)));
        make.right.equalTo(@(FKYWH(-15))).priority(999);
        make.height.equalTo(@(FKYWH(44)));
        make.bottom.equalTo(@(FKYWH(-15)));
    }];
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        self.logoutBtn.hidden = NO;
    }else{
        self.logoutBtn.hidden = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKYSetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYSetUpCell" forIndexPath:indexPath];
    cell.dotView.hidden = true;
    cell.subLabel.text = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.dataArray[indexPath.section];
    if (indexPath.section == 0){
        if ([FKYVersionCheckService shareInstance].hasNewVersion) {
            cell.subLabel.text = @"更新版本";
            cell.dotView.hidden = false;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.subLabel.text = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        }
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    //    if (section == 0) {
//    //        return 0;
//    //    }
//    return FKYWH(8);
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = UIColorFromRGB(0xf3f3f3);
//    return headView;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL hasNewVersion = [FKYVersionCheckService shareInstance].hasNewVersion;
    switch (indexPath.section) {
        case 1:{
            //隐私条款
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                destinationViewController.urlPath = API_PRIVATE_CONTENT_H5;
                destinationViewController.isShutDown = true;
                destinationViewController.barStyle = FKYBarStyleWhite;
                destinationViewController.title = @"隐私条款";
            }];
            break;
        }
        case 2:{
            //用户协议
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                destinationViewController.urlPath =  API_SEVERVE_CONTENT_H5;
                destinationViewController.isShutDown = true;
                destinationViewController.barStyle = FKYBarStyleWhite;
                destinationViewController.title = @"用户协议";
            }];
            break;
        }
        case 0:{
            if (hasNewVersion) {
                NSString *message = [FKYVersionCheckService shareInstance].updateMessage;
                message = [message stringByReplacingOccurrencesOfString:@"<br/> " withString:@"\n"];
                [FKYProductAlertView showAlertViewWithTitle:nil
                                                  leftTitle:@"更新"
                                                 rightTitle:@"稍后更新"
                                                    message:message
                                                    handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                    if(!isRight) {
                        // TODO: 跳转到方块1 appleStore 地址
                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:AppStoreUrl]]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreUrl]];
                        }
                    }
                }];
            }
        }
            break;
        case 3:{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AboutUsController)];
            break;
        }
        case 4:{
            // 跳转修改密码页面
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SetPassword) setProperty:^(FKYSetPasswordViewController *destinationViewController) {
                destinationViewController.phoneStr = FKYLoginAPI.currentUser.userName;
                destinationViewController.type = 1;
            } isModal:NO animated:YES];
            
            break;
        }
    }
}

@end

