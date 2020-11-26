//
//  FKYRootViewController.m
//  FKY
//
//  Created by yangyouyong on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYTabBarController.h"
//#import "CartSwitchViewController.h"
//#import "FKYAccountViewController.h"
#import "FKYProductAlertView.h"
#import "FKYCartModel.h"
#import "FKYLoginAPI.h"
#import "FKYVersionCheckService.h"
#import "FKYAccountSchemeProtocol.h"
#import "GLMediator+HomeActions.h"
#import "GLMediator+CategoryActions.h"
#import "FKYKeyboardManager.h"
#import "FKYNavigator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Aspects/Aspects.h>
#import "FKY-Swift.h"


@interface FKYTabBarController ()

@property (nonatomic, assign, readwrite) CGFloat tabbarHeight;
@property (nonatomic, strong)  JSBadgeView *badgeView;

@end


@implementation FKYTabBarController
@synthesize index = _index;

#pragma mark - singleton

+ (FKYTabBarController *)shareInstance
{
    static dispatch_once_t onceToken;
    static FKYTabBarController *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    
//    [staticInstance aspect_hookSelector:@selector(setSelectedIndex:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> instance){
//        FKYTabBarController *controller = instance.instance;
//        if (controller.selectedIndex == 1) {
//            // 分类
//           // [staticInstance BI_Record:@"home_yc_classify"];
//        }
//        if (controller.selectedIndex == 2) {
//            // 购物车
//           // [staticInstance BI_Record:@"home_yc_shopcart"];
//        }
//        if (controller.selectedIndex == 3) {
//            // 个人中心
//            //[staticInstance BI_Record:@"home_yc_usercenter"];
//        }
//     }error:nil];
    
    return staticInstance;
}


#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化键盘监听
        [FKYKeyboardManager defaultManager];
    }
    return self;
}


#pragma mark - lifecircle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tabbarHeight = 49;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            _tabbarHeight = 49 + iPhoneX_SafeArea_BottomInset;
        }
    }
    self.tabBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, _tabbarHeight);
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self p_configControllers];
    [self p_syncBadgeValue];
    
    [self syncCartBadgeNumber];
    [self setTabbarShadowLayer];
    
    NDC_ADD_SELF_NOBJ(@selector(syncCartBadgeNumber), FKYLoginSuccessNotification);
    NDC_ADD_SELF_NOBJ(@selector(syncCartBadgeNumber), FKYLogoutCompleteNotification);
    
    // 请求接口时返回-2(token过期)，故强制退出登录
    NDC_ADD_SELF_NOBJ(@selector(presentLoginView), FKYTokenOverDateNotification);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusLoginComplete) {
        RDVTabBarItem *item = [[self.tabBar items] objectAtIndex:2];
        item.badgeValue = nil;
        return;
    }
    
    [self syncCartBadgeNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public

- (void)checkUpdate
{
    if ([FKYVersionCheckService shareInstance].hasNewVersion) {
        NSString *message = [FKYVersionCheckService shareInstance].updateMessage;
        message = [message stringByReplacingOccurrencesOfString:@"<br/> " withString:@"\n"];
        NSString *rightTitle = @"稍后更新";
        BOOL mustUpdate = NO;
        if ([FKYVersionCheckService shareInstance].mustUpdate) {
            rightTitle = nil;
            mustUpdate = YES;
        }
        [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"更新" rightTitle:rightTitle message:message dismiss:mustUpdate  handler:^(FKYProductAlertView *alertView, BOOL isRight) {
            if (!isRight) {
                // TODO: goto apple store
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:AppStoreUrl]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreUrl]];
                }
            }
        }];
    }
}

- (void)syncCartBadgeNumber
{
    [[FKYVersionCheckService shareInstance] syncMixCartNumberSuccess:nil failure:nil];
    if ([FKYLoginService loginStatus] == FKYLoginStatusUnlogin) {
        [self setTabbarVipBadgeValue:nil];
    }
}


#pragma mark - Private

- (void)setTabbarShadowLayer
{
    CGFloat alpha = 1.0;
    [self.tabBar.backgroundView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    self.tabBar.backgroundView.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.backgroundView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.tabBar.backgroundView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    self.tabBar.backgroundView.layer.shadowRadius = 2;//阴影半径，默认3
}

- (void)p_configControllers
{
    // <本地>首页
    HomeController *homeVC = [[HomeController alloc] init];
    // <H5>分类
    UIViewController *categoryVC = [[GLMediator sharedInstance] glMediator_fetchNativeCategoryViewController];
    //<本地>店铺馆
    FKYShopHomeViewController *shopVC = [[FKYShopHomeViewController alloc] init];
    // <本地>购物车(购物车)
    CartSwitchViewController *cartVC = [[CartSwitchViewController alloc] init];
    // <本地>个人中心
    AccountViewController *accoutVC = [[AccountViewController alloc] init];
    // 设置
    [self setViewControllers:@[homeVC, categoryVC, shopVC, cartVC, accoutVC]];
    
    // 设置选中图片
    NSArray *tabBarItemSelectedImages = @[@"icon_tabbar_home_red",
                                          @"icon_tabbar_category_red",
                                          @"icon_tabbar_shop_red",
                                          @"icon_tabbar_cart_red",
                                          @"icon_tabbar_user_red"];
    // 设置未选中图片
    NSArray *tabBarItemImages = @[@"icon_tabbar_home_gray",
                                  @"icon_tabbar_category_gray",
                                  @"icon_tabbar_shop_gray",
                                  @"icon_tabbar_cart_gray",
                                  @"icon_tabbar_user_gray"];
    // 设置名称
    NSArray *tabBarItemTitles = @[@"首页",@"分类",@"店铺馆",@"购物车",@"我的"];
    
    //
    NSInteger index = 0;
    UIImage *finishedImage =  [[UIImage imageNamed:@"icon_tabbar_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] ;
    UIImage *unfinishedImage =  [[UIImage imageNamed:@"icon_tabbar_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.backgroundColor = UIColorFromRGB(0xffffff);
        item.title = tabBarItemTitles[index];
        item.selectedTitleAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0xfa3a15) };//UIColorFromRGB(0xFF2D5C)
        item.unselectedTitleAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x666666) };
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        
        NSString *itemSelectedName = [tabBarItemSelectedImages objectAtIndex:index];
        NSString *itemName         = [tabBarItemImages objectAtIndex:index];
        UIImage *selectedimage     = [UIImage imageNamed:itemSelectedName];
        UIImage *unselectedimage   = [UIImage imageNamed:itemName];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                item.imagePositionAdjustment = UIOffsetMake(0, -10);
                item.titlePositionAdjustment = UIOffsetMake(0, -10);
                item.badgePositionAdjustment = UIOffsetMake(-5, 3);
            }
        }
        
        index++;
    }
    
    [self setSelectedIndex:self.index];
}

// 同步购物车中商品数量
- (void)p_syncBadgeValue
{
    RDVTabBarItem *item = [[self.tabBar items] objectAtIndex:3];
    self.badgeView = ({
        JSBadgeView *view = [[JSBadgeView alloc] initWithParentView:item alignment:JSBadgeViewAlignmentTopRight];
        view.badgeBackgroundColor = UIColorFromRGB(0xFF2D5C);
        view.badgeTextColor = [UIColor whiteColor];
        view.badgePositionAdjustment = CGPointMake(FKYWH(-20), FKYWH(11));
        view.badgeTextFont = FKYSystemFont(FKYWH(11));
        view;
    });
    //普通商品数量
    [RACObserve([FKYCartModel shareInstance], productCount) subscribeNext:^(NSNumber *count) {
        NSInteger carNum = count.integerValue + [FKYCartModel shareInstance].togeterBuyProductCount;
        if (carNum>0 && carNum<100) {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)carNum];
        }else if(carNum>=100){
            self.badgeView.badgeText  = @"99+";
        }else{
            self.badgeView.badgeText  = @"";
        }
        //[item setupRedpoint];
        //[item updateRedpointVisiblityWithCount:carNum];
    }];
    //一起购商品数量
    [RACObserve([FKYCartModel shareInstance], togeterBuyProductCount) subscribeNext:^(NSNumber *count) {
        NSInteger carNum = count.integerValue + [FKYCartModel shareInstance].productCount;
        if (carNum>0 && carNum<100) {
            self.badgeView.badgeText  = [NSString stringWithFormat:@"%ld",(long)carNum];
        }else if(carNum>=100){
            self.badgeView.badgeText  = @"99+";
        }else{
            self.badgeView.badgeText  = @"";
        }
        //[item setupRedpoint];
        //[item updateRedpointVisiblityWithCount:carNum];
    }];
}

- (void)setTabbarVipBadgeValue:(FKYVipDetailModel *)vipModel
{
    RDVTabBarItem *item = [[self.tabBar items] objectAtIndex:4];
    if ((item.badgeBackgroundImage != nil && vipModel.vipSymbol == 1) || (item.badgeBackgroundImage == nil && vipModel.vipSymbol != 1)) {
        //判断状态是否改变了，未改变则不需要更新vip图标
        return;
    }
    if (vipModel != nil && vipModel.vipSymbol == 1) {
        item.badgePositionAdjustment = UIOffsetMake(0, 4);
        item.badgeBackgroundColor = [UIColor clearColor];
        if ( item.selected == true){
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_pic"];
        }else{
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_h_pic"];
        }
    }else{
        item.badgeBackgroundImage = nil;
    }
    item.badgeValue = @" ";
}

- (void)setTabbarVipBadgeValueForAcount:(BOOL)isVip
{
    RDVTabBarItem *item = [[self.tabBar items] objectAtIndex:4];
   
    if ((item.badgeBackgroundImage != nil && isVip == true) || (item.badgeBackgroundImage == nil &&  isVip == false)) {
        //判断状态是否改变了，未改变则不需要更新vip图标
        return;
    }

    if (isVip == true) {
        item.badgePositionAdjustment = UIOffsetMake(0, 4);
        item.badgeBackgroundColor = [UIColor clearColor];
        if ( item.selected == true){
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_pic"];
        }else{
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_h_pic"];
        }
    }else{
        item.badgeBackgroundImage = nil;
    }
    item.badgeValue = @" ";
}
#pragma mark - Notification

// token过期，先注销，然后再弹出登录界面
- (void)presentLoginView
{
    // 移除本地登录记录
    [FKYLoginAPI logoutSuccess:^(BOOL mutiplyPage) {
        // 登录界面已弹出...<在栈顶>
        if ([[FKYNavigator sharedNavigator].topNavigationController.topViewController isKindOfClass:[LoginController class]]) {
            return;
        }
        
        // 登录界面已弹出...<不在栈顶>
        __block BOOL loginStatus = NO;
        NSArray *arrayVC = [FKYNavigator sharedNavigator].topNavigationController.viewControllers;
        if (arrayVC && arrayVC.count > 0) {
            [arrayVC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIViewController *vc = (UIViewController *)obj;
                if ([vc isKindOfClass:[LoginController class]]) {
                    loginStatus = YES;
                    *stop = YES;
                }
            }];
        }
        if (loginStatus) {
            return;
        }
        
        // 登录界面已弹出...<modal方式>
        if ([FKYLoginAPI checkLoginExistByModelStyle]) {
            return;
        }
        
        // 弹出登录界面相关逻辑
        if (kAppDelegate.showType == ShowLoginTypeSplashFirst) {
            // 若当前app启动时正在显示广告图， 则需要延迟弹出登录界面
            kAppDelegate.showType = ShowLoginTypeAfterSplash;
            return;
        }
        else if (kAppDelegate.showType == ShowLoginTypeAfterSplash) {
            // 若当前登录界面需要延迟弹出，则不重复
            return;
        }
        else if (kAppDelegate.showType == ShowLoginTypeNow) {
            // 若当前登录界面已经弹出，则不重复
            return;
        }
        else if (kAppDelegate.showType == ShowLoginTypeOver) {
            // 可直接弹登录
            kAppDelegate.showType = ShowLoginTypeNow;
        }
        
        // 弹出登录界面
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES];
    } failure:^(NSString *reason) {
        //
    }];
}


#pragma mark - Property

- (void)setIndex:(NSInteger)index
{
    _index = index;
    [self setSelectedIndex:index];
    [self resetVipTag:index];
}

- (void)resetVipTag:(NSInteger)index
{
    RDVTabBarItem *item = [[self.tabBar items] objectAtIndex:4];
    if (item.badgeBackgroundImage != nil) {
        if (index==4){
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_pic"];
        }else{
            item.badgeBackgroundImage = [UIImage imageNamed:@"vip_tag_h_pic"];
        }
    }
}

@end
