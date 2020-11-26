//
//  FKYFindPeoplePayViewController.m
//  FKY
//
//  Created by 夏志勇 on 2017/10/24.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYFindPeoplePayViewController.h"
#import "UILabel+FKYKit.h"
#import "FKYCartSubmitService.h"


@interface FKYFindPeoplePayViewController ()

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) UIView *viewTip;
@property (nonatomic, strong) UIButton *btnPay;
@property (nonatomic, strong) UIButton *btnOrder;

/// 抽奖入口按钮
@property (nonatomic, strong) UIButton *btnAds;

// 分享视图
@property (nonatomic, strong) ShareView4Pay *shareView;

// 请求加密签名service
@property (nonatomic, strong) FKYCartSubmitService *service;
// 加密签名
@property (nonatomic, copy) NSString *orderShareSign;

/// 抽奖模型
@property (nonatomic,strong)FKYOrderPayStatusViewModel *drawViewModel;
@end


@implementation FKYFindPeoplePayViewController
@synthesize enterpriseId;
@synthesize orderid;
@synthesize orderMoney;
@synthesize flagFromCO;


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self requestData];
    [self requestDrawInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - SetupView

// 创建基本内容页面
- (void)setupView
{
    [self fky_setupNavigationBar];
    self.navBar = [self fky_NavigationBar];
    
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"找人代付"];
    [self fky_setTitleColor:[UIColor blackColor]];
    @weakify(self);
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        @strongify(self);
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:@"" floorPosition:@"" floorName:@"" sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I9430" itemPosition:@"1" itemName:@"返回" itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
        //[self backAction];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    [self fky_setNavigationBarBottomLineHidden: false];
    
    // 内容视图
    [self.view addSubview:self.viewTip];
    [self.viewTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.equalTo(@(FKYWH(237)));
    }];
    
    // 分享视图
    [self.view addSubview:self.shareView];
    
    // 1药贷广告
    [self.view addSubview:self.btnAds];
    [self.btnAds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.viewTip.mas_bottom).offset(30);
        make.height.mas_equalTo((SCREEN_WIDTH-30) * 168 / 710);
        //make.height.equalTo(@(FKYWH(73)));
    }];
}


#pragma mark - Request


/// 请求抽奖信息
- (void)requestDrawInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *orderID = [defaults valueForKey:@"NewestPayOrderID"];
    
//    let userDefault = UserDefaults.standard
//    self.orderNO = userDefault.value(forKey: FKY_NewestPayOrderID) as? String ?? ""
    MJWeakSelf
    
    [self.drawViewModel requestDrawInfoFromPage:@"" orderNo:orderID block:^(BOOL isSuccess, NSString * _Nullable Msg) {
        if (isSuccess == false) {
            [self toast:Msg];
            return ;
        }
        if (weakSelf.drawViewModel.drawRawData.drawPic.length > 0 || weakSelf.drawViewModel.drawRawData.orderDrawRecordDto.drawPic.length > 0){
            weakSelf.btnAds.hidden = false;
            NSString *imgUrl = @"";
            if (weakSelf.drawViewModel.drawRawData.drawPic.length > 0 ){
                imgUrl = weakSelf.drawViewModel.drawRawData.drawPic;
            }else if (weakSelf.drawViewModel.drawRawData.orderDrawRecordDto.drawPic.length > 0) {
                imgUrl = weakSelf.drawViewModel.drawRawData.orderDrawRecordDto.drawPic;
            }
            [self.btnAds sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
            
        }else{
            weakSelf.btnAds.hidden = true;
        }
    }];
}

// 请求数据
- (void)requestData
{
    //
}


#pragma mark - ShareAction

// 微信好友分享
- (void)WXShare
{
    // 只设置标题，不设置描述
    [FKYShareManage shareToWXWithOpenUrl:[self shareUrl] title:[self shareTitle] andMessage:nil andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_share_wechat"];
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

/*
 说明：当前找人代付界面，只可能从检查订单入口进来；订单列表界面无入口。
 */

// 返回
- (void)backAction
{
    if (flagFromCO) {
        // 从检查订单入口过来...<返回到购物车>
//        UIViewController *vc = nil;
//        NSArray *listVC = self.navigationController.viewControllers;
//        for (UIViewController *controller in listVC) {
//            if ([controller isKindOfClass:NSClassFromString(@"FKYCartViewController")]) {
//                vc = controller;
//                break;
//            }
//        }
//        if (!vc) {
//            // 未找到
//            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
//                destinationViewController.index = 3;
//            }];
//        }
//        else {
//            // 已找到
//            [self.navigationController popToViewController:vc animated:YES];
//        }
        
        // 跳转到订单列表...<待付款>
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            destinationViewController.index = 4;
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"1";
            }];
        }];
    }
    else {
        // 从订单列表入口过来...<返回到订单列表>
        UIViewController *vc = nil;
        NSArray *listVC = self.navigationController.viewControllers;
        for (UIViewController *controller in listVC) {
            if ([controller isKindOfClass:NSClassFromString(@"FKYAllOrderViewController")]) {
                vc = controller;
                break;
            }
        }
        if (!vc) {
            // 未找到
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                destinationViewController.index = 4;
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                    destinationViewController.status = @"0";
                }];
            }];
        }
        else {
            // 已找到
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

// 跳转到订单列表界面
- (void)jumpToOrderList
{
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fky://account/allorders"]]) {
//        if (iOS10Later()) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/allorders"] options:@{} completionHandler:nil];
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/allorders"]];
//        }
//    }
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:@"" floorPosition:@"" floorName:@"" sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I9431" itemPosition:@"2" itemName:@"我的订单" itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
    if (flagFromCO) {
        // 从检查订单入口过来...<跳转到订单列表>
//        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
//            destinationViewController.index = 4;
//            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
//                destinationViewController.status = @"1";
//            }];
//        }];
        
        // 初始化界面vc
        FKYAllOrderViewController *orderVC = [[FKYAllOrderViewController alloc] init];
        orderVC.status = @"1";
        // 先移除当前vc，再跳转到下个vc
        NSMutableArray *list = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [list removeLastObject];
        [list addObject:orderVC];
        [self.navigationController setViewControllers:list animated:YES];
    }
    else {
        // 从订单列表入口过来...<返回到订单列表>
        UIViewController *vc = nil;
        NSArray *listVC = self.navigationController.viewControllers;
        for (UIViewController *controller in listVC) {
            if ([controller isKindOfClass:NSClassFromString(@"FKYAllOrderViewController")]) {
                vc = controller;
                break;
            }
        }
        if (!vc) {
            // 未找到
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                destinationViewController.index = 4;
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                    destinationViewController.status = @"0";
                }];
            }];
        }
        else {
            // 已找到
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

// 广告H5
- (void)adsBtnClick
{
//    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
//        destinationViewController.urlPath = @"https://m.yaoex.com/web/h5/maps/index.html?pageId=100247&type=release";
//    }];
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
        FKYOrderPayStatusVC *paySuccessVC = (FKYOrderPayStatusVC*)destinationViewController;
        paySuccessVC.fromePage = 4;
    } isModal:false animated:true];
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:@"" floorPosition:@"" floorName:@"" sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I9303" itemPosition:@"1" itemName:@"点击抽奖" itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
}

// 开始分享操作
- (void)startShareAction
{
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:@"" floorPosition:@"" floorName:@"" sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I9431" itemPosition:@"1" itemName:@"找人代付" itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
    if (self.orderShareSign && self.orderShareSign.length > 0) {
        // 已获取签名
        self.shareView.appearClourse();
    }
    else {
        // 未获取签名
        
        if (!self.orderid) {
            [self toast:@"无订单id"];
            return;
        }
        
        [self showLoading];
        
        if (self.service == nil) {
            self.service = [[FKYCartSubmitService alloc] init];
        }
        @weakify(self);
        [self.service getOrderShareSign:self.orderid payType:@"1" success:^(BOOL mutiplyPage, id data) {
            @strongify(self);
            [self dismissLoading];
            // 保存分享签名
            if (data && [data isKindOfClass:[NSString class]]) {
                NSString *shareUrl = (NSString *)data;
                if (shareUrl && shareUrl.length > 0) {
                    self.orderShareSign = shareUrl;
                    if ([self.shareView respondsToSelector:@selector(appearClourse)]){
                         self.shareView.appearClourse();
                    }
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

// 分享图片
- (NSString *)shareImage
{
    return nil;
}

// 分享标题
- (NSString *)shareTitle
{
    return [NSString stringWithFormat:@"我在1药城采购了一批商品，总金额为￥%.2f，点击链接帮我支付吧！", self.orderMoney];
}

/*
 线下转账支付信息分享链接：http://m.yaoex.com/repay/offline_pay.html?orderid=XXX&sign=XXX
 找人代付支付信息分享链接：http://m.yaoex.com/bind/repay_pay.html?orderid=XXX&sign=XXX
 */

// 分享链接
- (NSString *)shareUrl
{
    // 订单id， 订单sign
    //return [NSString stringWithFormat:@"http://m.yaoex.com/bind/repay_pay.html?orderid=%@&sign=%@", self.orderid, self.orderShareSign];
    
    // 接口直接返回了分享链接...<不再需要本地手动拼接>
    return self.orderShareSign;
}


#pragma mark - Property

- (UIView *)viewTip
{
    if (_viewTip == nil) {
        _viewTip = [UIView new];
        _viewTip.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgIcon = [UIImageView new];
        imgIcon.image = [UIImage imageNamed:@"icon_account_register_success"];
        [_viewTip addSubview:imgIcon];
        [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_viewTip);
            make.width.height.equalTo(@(FKYWH(60)));
            make.top.equalTo(self->_viewTip.mas_top).offset(FKYWH(40));
        }];
        
        UILabel *lblTip = [UILabel new];
        lblTip.font = [UIFont systemFontOfSize:FKYWH(17)];
        lblTip.textColor = UIColorFromRGB(0x333333);
        lblTip.text = @"提交订单成功";
        [_viewTip addSubview:lblTip];
        [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_viewTip);
            make.top.equalTo(imgIcon.mas_bottom).offset(FKYWH(20));
        }];
        
        UILabel *lblDes = [UILabel new];
        lblDes.fontTuble = T22;
        //lblDes.text = @"请点击“找人代付”按钮分享代付链接给贵司财务！";
        lblDes.numberOfLines = 2;
        lblDes.textAlignment = NSTextAlignmentCenter;
        [_viewTip addSubview:lblDes];
        [lblDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_viewTip);
            make.top.equalTo(lblTip.mas_bottom).offset(FKYWH(5));
            //make.width.equalTo(@(FKYWH(266)));
            //make.height.equalTo(@(FKYWH(40)));
            make.left.equalTo(self->_viewTip).offset(10);
            make.right.equalTo(self->_viewTip).offset(-10);
        }];
        
        NSString *des = @"请点击“找人代付”按钮分享代付链接给贵司财务！";
        NSValue *rang = [NSValue valueWithRange:NSMakeRange(4, 4)];
        NSAttributedString *desString = FKYAttributedStringForStringAndRangesOfSubString(des, FKYWH(12), UIColorFromRGB(0x333333), @[rang], FKYWH(12), UIColorFromRGB(0xfe5050));
        lblDes.attributedText = desString;
        
        [_viewTip addSubview:self.btnPay];
        [self.btnPay mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblDes.mas_bottom).offset(FKYWH(30));
            make.left.equalTo(self->_viewTip).offset(FKYWH(15));
            make.height.equalTo(@(FKYWH(40)));
            make.width.equalTo(@(FKYWH(165)));
        }];
        
        [_viewTip addSubview:self.btnOrder];
        [self.btnOrder mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblDes.mas_bottom).offset(FKYWH(30));
            make.right.equalTo(self->_viewTip).offset(FKYWH(-15));
            make.height.equalTo(@(FKYWH(40)));
            make.width.equalTo(@(FKYWH(165)));
            
        }];
    }
    return _viewTip;
}

- (UIButton *)btnPay
{
    if (_btnPay == nil) {
        UIImage *imgNormal = [UIImage imageWithColor:UIColorFromRGB(0xFF2D5C) size:CGSizeMake(2, 2)];
        UIImage *imgSelect = [UIImage imageWithColor:[UIColor colorWithRed:113.0/255 green:0 blue:0 alpha:1] size:CGSizeMake(2, 2)];
        
        _btnPay = [UIButton new];
        _btnPay.backgroundColor = [UIColor clearColor];
        [_btnPay setTitle:@"找人代付" forState:UIControlStateNormal];
        _btnPay.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnPay.titleLabel setFont:[UIFont boldSystemFontOfSize:FKYWH(15)]];
        [_btnPay setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_btnPay setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_btnPay setBackgroundImage:imgNormal forState:UIControlStateNormal];
        [_btnPay setBackgroundImage:imgSelect forState:UIControlStateHighlighted];
        _btnPay.layer.masksToBounds = YES;
        _btnPay.layer.cornerRadius = 4.0;
        @weakify(self);
        [[_btnPay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"找人代付");
            [self startShareAction];
        }];
    }
    return _btnPay;
}

- (UIButton *)btnOrder
{
    if (_btnOrder == nil) {
        UIImage *imgNormal = [UIImage imageWithColor:UIColorFromRGB(0xFFFFFF) size:CGSizeMake(2, 2)];
        UIImage *imgSelect = [UIImage imageWithColor:UIColorFromRGB(0xFFEDE7) size:CGSizeMake(2, 2)];
        
        _btnOrder = [UIButton new];
        _btnOrder.backgroundColor = [UIColor clearColor];
        [_btnOrder setTitle:@"我的订单" forState:UIControlStateNormal];
        _btnOrder.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnOrder.titleLabel setFont:[UIFont boldSystemFontOfSize:FKYWH(15)]];
        [_btnOrder setTitleColor:UIColorFromRGB(0xFF2D5C) forState:UIControlStateNormal];
        [_btnOrder setTitleColor:UIColorFromRGBA(0xFF2D5C, 0.5) forState:UIControlStateHighlighted];
        [_btnOrder setBackgroundImage:imgNormal forState:UIControlStateNormal];
        [_btnOrder setBackgroundImage:imgSelect forState:UIControlStateHighlighted];
        _btnOrder.layer.masksToBounds = YES;
        _btnOrder.layer.cornerRadius = 4.0;
        _btnOrder.layer.borderWidth = 1.0;
        _btnOrder.layer.borderColor = UIColorFromRGB(0xfe5050).CGColor;
        @weakify(self);
        [[_btnOrder rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
             NSLog(@"我的订单");
             [self jumpToOrderList];
         }];
    }
    return _btnOrder;
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

- (UIButton *)btnAds
{
    if (!_btnAds) {
        _btnAds = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAds setBackgroundImage:[UIImage imageNamed:@"lonans_ad_image"] forState:UIControlStateNormal];
        [_btnAds addTarget:self action:@selector(adsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //_btnAds.adjustsImageWhenHighlighted = NO;
    }
    return _btnAds;
}

- (FKYOrderPayStatusViewModel *)drawViewModel{
    if (_drawViewModel == nil){
        _drawViewModel = [[FKYOrderPayStatusViewModel alloc]init];
    }
    return _drawViewModel;
}

@end
