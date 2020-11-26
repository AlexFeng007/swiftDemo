//
//  FKYAboutUsViewController.m
//  FKY
//
//  Created by yangyouyong on 15/10/9.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAboutUsViewController.h"
#import "FKYNavigator.h"
#import "UIViewController+NavigationBar.h"
#import "FKYAboutUsCell.h"
#import "FKYAlertView.h"
#import "FKYProductAlertView.h"
#import <Masonry/Masonry.h>
#import "GLMediator+VenderActions.h"

static NSString *const aboutUsCellIndentifier = @"aboutUsCellIndentifier";


@interface FKYAboutUsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIImageView *codeImage;
@property (nonatomic, strong) UIView *codeImageContainer;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *labelContainer;
@property (nonatomic, strong) UILabel *headerLine;
@property (nonatomic, strong) UILabel *copyright;
@property (nonatomic, strong) UILabel *descrip;

@end


@implementation FKYAboutUsViewController

- (void)loadView {
    [super loadView];
    [self setupView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)setupView {
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    [self fky_setupNavigationBar];
    
    self.navBar = ({
        UIView *bar = [self fky_NavigationBar];
        bar.backgroundColor = [UIColor whiteColor];
        
        // 下分隔线
        UIView *view = [[UIView alloc] init];
        [bar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bar.mas_left);
            make.right.equalTo(bar.mas_right);
            make.bottom.equalTo(bar.mas_bottom);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xcccccc);
        
        [self fky_setupNavigationBarWithTitle:@"关于我们"];
        [self fky_setTitleColor:[UIColor blackColor]];
        [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
            [[FKYNavigator sharedNavigator] pop];
        }];
        [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
        bar;
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        [tableView registerClass:[FKYAboutUsCell class] forCellReuseIdentifier:aboutUsCellIndentifier];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(408))];
            view.backgroundColor = UIColorFromRGB(0xffffff);
            
            self.logoImage = ({
                UIImageView *logoImage = [UIImageView new];
                [view addSubview:logoImage];
                logoImage.image = [UIImage imageNamed:@"icon_account_aboutus_logo"];
                [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view.mas_top).offset(FKYWH(30));
                    make.centerX.equalTo(view);
                }];
                logoImage;
            });
            
            self.codeImageContainer = ({
                UIView *v = [UIView new];
                [view addSubview:v];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.logoImage.mas_bottom).offset(FKYWH(30));
                    make.centerX.equalTo(view);
                    make.width.height.equalTo(@(FKYWH(119)));
                }];
                v.layer.borderWidth = 1;
                v.layer.borderColor = UIColorFromRGB(0xebedec).CGColor;
                v;
            });
            
            self.codeImage = ({
                UIImageView *image = [UIImageView new];
                image.image = [UIImage imageNamed:@"icon_account_codeimage"];
                [self.codeImageContainer addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self.codeImageContainer).offset(FKYWH(8));
                    make.bottom.right.equalTo(self.codeImageContainer).offset(FKYWH(-8));
                }];
                image;
            });
            
            self.remindLabel = ({
                UILabel *remindLabel = [UILabel new];
                [view addSubview:remindLabel];
                remindLabel.text = @"扫描二维码, 了解更多";
                remindLabel.font = FKYSystemFont(FKYWH(12));
                remindLabel.textColor = UIColorFromRGB(0x333333);
                [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.codeImageContainer.mas_bottom).offset(FKYWH(15));
                    make.centerX.equalTo(view);
                }];
                remindLabel;
            });
            
            self.labelContainer = ({
                UIView *labelContainer = [UIView new];
                [view addSubview:labelContainer];
                [labelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.remindLabel.mas_bottom);
                    make.left.right.bottom.equalTo(view);
                }];
                labelContainer;
            });
            
            self.descriptionLabel = ({
                UILabel *descriptionLabel = [UILabel new];
                descriptionLabel.numberOfLines = 0;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = FKYWH(5);
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"  \"1药城\"  (mall.yaoex.com)作为岗岭集团旗下的电商三方平台,  以医药批发流通行业(B2B)为目标市场,  以生产企业营销解决方案为核心价值,  专注于打造服务于生产企业的线上促销中心,  为药品批发企业及药品零售企业提供一站式在线交易平台。" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666), NSFontAttributeName:FKYSystemFont(FKYWH(12)), NSParagraphStyleAttributeName:paragraphStyle}];
                
                [self.labelContainer addSubview:descriptionLabel];
                [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.labelContainer);
                    make.left.equalTo(self.labelContainer.mas_left).offset(FKYWH(36)).priority(999);
                    make.right.equalTo(self.labelContainer.mas_right).offset(FKYWH(-36)).priority(999);
                }];
                descriptionLabel;
            });
        
            view;
        });
        
        tableView.tableFooterView = ({
            UIView *view = [UIView new];
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(84));
            view.backgroundColor = UIColorFromRGB(0xf3f3f3);
            
            self.descrip = ({
                UILabel *descrip = [UILabel new];
                [view addSubview:descrip];
                descrip.textColor = UIColorFromRGB(0x999999);
                descrip.text = @"1药城 mall.yaoex.com版权所有";
                descrip.font = FKYSystemFont(FKYWH(12));
                [descrip mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(view.mas_bottom).offset(FKYWH(-20));
                    make.centerX.equalTo(view.mas_centerX);
                }];
                descrip;
            });
            
            self.copyright = ({
                UILabel *copyright = [UILabel new];
                [view addSubview:copyright];
                copyright.textColor = UIColorFromRGB(0x999999);
                copyright.text = @"Copyright © 2014-2019";
                copyright.font = FKYSystemFont(FKYWH(12));
                [copyright mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.descrip.mas_top).offset(FKYWH(-4));
                    make.centerX.equalTo(view.mas_centerX);
                }];
                copyright;
            });
            view;
        });
        
        // iPhoneX适配
        CGFloat marginBottom = 0;
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                // iPhoneX
                marginBottom = iPhoneX_SafeArea_BottomInset;
            }
        }
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-marginBottom);
        }];
        
        tableView;
    });
}


#pragma mark - Private

- (void)uploadErrorFile {
    [self showLoading];
    [WUMonitorInstance uploadErrorFileWithCallback:^(BOOL ret, NSString *msg) {
        [self dismissLoading];
        [self toast:msg];
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = aboutUsCellIndentifier;
    FKYAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FKYAboutUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        //cell.nameLabel.text = @"官方网站";
        cell.nameLabel.text = @"咨询电话";
    } else {
        NSString *uuid = [[GLMediator sharedInstance] glMediator_deviceIdentifierInAboutUsPage];
        cell.nameLabel.text = [NSString stringWithFormat:@"日志上报（%@）", uuid];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://m.yaoex.com"]];
        [FKYProductAlertView showAlertViewWithTitle:nil
                                          leftTitle:@"拨号"
                                         rightTitle:@"取消"
                                            message:@"4009215767"
                                            handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                                                if (!isRight) {
                                                    NSURL *tel = [NSURL URLWithString:@"tel:4009215767"];
                                                    [[UIApplication sharedApplication] openURL:tel];
                                                }
                                            }];
    } else {
        if ([WUMonitorInstance isWiFiMode]) {
            [self uploadErrorFile];
        } else {
            WUPopItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    [self uploadErrorFile];
                }
            };
            NSArray *items = @[WUPopItemMake(@"确定", WUPopItemTypeHighlight, block),
                               WUPopItemMake(@"不了", WUPopItemTypeNormal, block)];
            WUAlertView *av = [[WUAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前网络环境不是WiFi哦，确定继续上传吗？" items:items];
            [av show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FKYWH(47);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FKYWH(8);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

@end
