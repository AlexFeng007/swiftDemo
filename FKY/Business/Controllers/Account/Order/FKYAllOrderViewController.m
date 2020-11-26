//
//  FKYAllOrderViewController.m
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAllOrderViewController.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "FKYAllOrderStatusView.h"
#import "UIViewController+ToastOrLoading.h"
#import <Masonry/Masonry.h>
#import "FKYTabBarSchemeProtocol.h"
#import "FKYTabBarController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "FKYOrderStatusViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface FKYAllOrderViewController () <UIScrollViewDelegate, FKYNavigationControllerDragBackDelegate>

@property (nonatomic, strong)  UIScrollView *mainScrollView;
@property (nonatomic, strong)  FKYAllOrderStatusView *headerView;
@property (nonatomic, strong)  NSString *statusString;
@property (nonatomic, strong)  NSString *tipsStr;
@property (nonatomic, assign)  NSInteger originIndex;
@property (nonatomic, assign)  NSInteger selectedIndex;
@property (nonatomic, copy) NSArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) OrderExpireTipsHeadView *tipsHeadView;
@end


@implementation FKYAllOrderViewController
@synthesize popToCartController = _popToCartController;

#pragma mark - LifeCircle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.vcArray = [NSMutableArray array];
    self.originIndex = 0;
    self.selectedIndex = 0;
    
    [self p_createBar];
    [self p_setupUI];
    
    if (self.status && self.status.integerValue >= 0 && self.status.integerValue <= 4) {
        // 更新
        NSInteger index = self.status.integerValue;
        self.selectedIndex = index;
        self.originIndex = index;
    }
    
    @weakify(self);
    self.popToCartBlock = ^{
        @strongify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController *destinationViewController) {
            @strongify(self);
            destinationViewController.index = 1;
            self.popToCartController = NO;
        } isModal:NO animated:YES];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[IQKeyboardManager sharedManager] setEnable:YES];
    //    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    // 状态栏为黑
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:NO];
    }
    
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = self;
    
    // 刷新...<每次显示时均刷新>
    [self.headerView allOrderStatusViewSelectedButtonTag:self.selectedIndex];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 状态栏为黑
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = nil;
}

#pragma mark -

- (void)p_createBar
{
    [self fky_setupNavigationBar];
    
    UIView *bar = [self fky_NavigationBar];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [bar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bar.mas_left);
        make.right.equalTo(bar.mas_right);
        make.bottom.equalTo(bar.mas_bottom);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"我的订单"];
    [self fky_setTitleColor:[UIColor blackColor]];
    @weakify(self);
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        @strongify(self);
        if (self.popToCartController == YES) {
            safeBlock(self.popToCartBlock);
        }else{
            [[FKYNavigator sharedNavigator] pop];
        }
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I9201" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    [self fky_setNavitationBarRightButtonImage:[UIImage imageNamed:@"order_search_icon"]];
    // 订单搜索
    [self fky_addNavitationBarRightButtonEventHandler:^(id sender) {
        @strongify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Search) setProperty:^(FKYSearchViewController* destinationViewController) {
            destinationViewController.vcSourceType = SourceTypeOrder;
            destinationViewController.searchType = SearchTypeOrder;
        } isModal:NO animated:NO];
        
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I9201" itemPosition:@"2" itemName:@"订单搜索" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }];
}

- (void)p_setupUI
{
    // 资质过期提醒视图
    self.tipsHeadView = [OrderExpireTipsHeadView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expireTipsTap)];
    [self.tipsHeadView addGestureRecognizer:tap];
    [self.view addSubview:self.tipsHeadView];
    [self.tipsHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo([self fky_NavigationBar].mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    // 顶部分类视图
    self.headerView = [FKYAllOrderStatusView new];
    self.headerView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 5 * 6, FKYWH(44));
    @weakify(self);
    self.headerView.buttonClickBlock = ^(NSInteger integer){
        @strongify(self);
        [UIView animateWithDuration:0.2 animations:^{
            NSArray *controllers = [self childViewControllers];
            // 请求列表
            [controllers[integer] requestData];
            //
            for (int i = 0; i < controllers.count; i ++) {
                if (i == integer) {
                    continue;
                }
                [controllers[i] clearData];
            }
            self.mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * integer, 0);
            self.selectedIndex = integer;
            
        } completion:nil];
    };
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tipsHeadView.mas_bottom);
        make.height.mas_equalTo(FKYWH(44));
    }];
    
    CGFloat height = 108; // 64+44
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            height = iPhoneX_SafeArea_TopInset + 44;// iPhoneX导航高度为88
        }
    }
    
    // 容器视图
    self.mainScrollView = ({
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, FKYWH(height), SCREEN_WIDTH, SCREEN_HEIGHT - FKYWH(height))];
        view.pagingEnabled = YES;
        view.bounces = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT - FKYWH(height));
        view.delegate = self;
        view;
    });
    [self.view addSubview:self.mainScrollView];
    [self.vcArray removeAllObjects];
    // 各类型的内容视图
    int i = 0;
    while (i < 5) {
        FKYOrderStatusViewController *controller = [[FKYOrderStatusViewController alloc] init];
        controller.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH,  SCREEN_HEIGHT - FKYWH(height));
        [self.mainScrollView addSubview:controller.view];
 
        @weakify(self);
        [self.vcArray addObject:controller];
        controller.clickIndex = ^(NSInteger index) {
            @strongify(self);
            [UIView animateWithDuration:0.2 animations:^{
                NSArray *controllers = [self childViewControllers];
                [controllers[index] requestData];
                for (int i = 0; i < controllers.count; i ++) {
                    if (i == index) {
                        continue;
                    }
                    [controllers[i] clearData];
                }
                self.mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
                self.selectedIndex = index;
            } completion:nil];
            
            [self addBIRecordWithItemNameWithitemPosition:index];
        };
         controller.sendExpiredTips = ^(NSString *tips) {
             @strongify(self);
             if (![tips isEqual:[NSNull null]] && tips != nil && (self.tipsStr != nil || ![self.tipsStr isEqualToString:tips])){
                 [self updateContentHieght:tips];
             }
         };
        [self addChildViewController:controller];
        switch (i) {
            case 0:
                controller.orderStatus = AllType;
                break;
            case 1:
                controller.orderStatus = UnpayType;
                break;
            case 2:
                controller.orderStatus = UndelivereType;
                break;
            case 3:
                controller.orderStatus = DelivereType;
                break;
            case 4:
                controller.orderStatus = CompleteType;
                break;
            default:
                break;
        }
        i++;
    }
}
#pragma mark - action
//因为资质过期文描更新各个高度
- (void)updateContentHieght:(NSString *)tipsStr{
    self.tipsStr = tipsStr;
    if (tipsStr.length == 0){
        return;
    }
    [self.tipsHeadView configTipView:tipsStr];
    
    float tipsHeight = [OrderExpireTipsHeadView configTipViewHeight:tipsStr];
    [self.tipsHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tipsHeight);
    }];
    CGFloat height = 108 ; // 64+44
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            height = iPhoneX_SafeArea_TopInset + 44 ;// iPhoneX导航高度为88
        }
    }
    self.mainScrollView.frame = CGRectMake(0, FKYWH(height) + tipsHeight, SCREEN_WIDTH, SCREEN_HEIGHT - FKYWH(height) - tipsHeight);
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT - FKYWH(height) - tipsHeight);
    
    for (int i = 0;i<self.vcArray.count;i++){
        FKYOrderStatusViewController *controller = self.vcArray[i];
        controller.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH,  SCREEN_HEIGHT - FKYWH(height) - tipsHeight);
    }
}
- (void)expireTipsTap{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CredentialsController) setProperty:^(id destinationViewController) {
        //CredentialsViewController *vc = destinationViewController;
        id<FKY_CredentialsController> vc = destinationViewController;
        vc.fromType = @"expireData";
    }];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger x = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (_originIndex != x) {
        _originIndex = x;
        [self.headerView allOrderStatusViewSelectedButtonTag:_originIndex];
        _selectedIndex = _originIndex;
    }
}


#pragma mark - FKYNavigationControllerDragBackDelegate

- (BOOL)dragBackShouldStartInNavigationController:(FKYNavigationController *)navigationController
{
    if (self.popToCartController) {
        safeBlock(self.popToCartBlock);
        [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = nil;
        return NO;
    }
    return NO;
}


- (void)addBIRecordWithItemNameWithitemPosition:(NSInteger)itemPosition {
    if (self.titlesArray.count > itemPosition) {
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"切换tab" itemId:@"I9202" itemPosition:STRING_FORMAT(@"%d", itemPosition + 1) itemName:self.titlesArray[itemPosition] itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }
}


- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"全部", @"待付款", @"待发货", @"待收货", @"已完成"];
    }
    return _titlesArray;
}

@end
