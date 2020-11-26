//
//  FKYProductionDetailViewController.m
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

// Controller
#import "FKYProductionDetailViewController.h"
#import "FKYProductionBaseInfoController.h"
#import "FKYProductionInstructionController.h"
// View
#import "FKYBlankView.h"
#import "FKYProductionDetailView.h"
#import "FKYNetworkErrorView.h"
#import "FKYProductAlertView.h"
#import "PurchaseCarAnimationTool.h"
// Model
#import "FKYCartModel.h"
// Protocol
#import "FKYTabBarSchemeProtocol.h"
#import "FKYAccountSchemeProtocol.h"
// Service
#import "FKYCartService.h"
#import "FKYProductionDetailService.h"
#import "FKYShareManage.h"
// Others
#import "FKYNavigator.h"
#import "UIWindow+Hierarchy.h"
#import "UIImage+FKYKit.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+ToastOrLoading.h"
#import "IQKeyboardManager.h"
// Swift
#import "FKY-Swift.h"


#define ADD_NUM_H  FKYWH(157)


@interface FKYProductionDetailViewController () <UIScrollViewDelegate, FKYNavigationControllerDragBackDelegate, FKYArrivalNoticeSheetViewDelegate>

@property (nonatomic, strong) PDBottomView *bottomView;
//@property (nonatomic, strong) PDProductAddNumView *addNumBottomView;
@property (nonatomic, strong) FKYAddCarViewController *addCarView;
@property (nonatomic, strong) FKYProductionDetailService *detailService;
@property (nonatomic, strong) FKYCartService *cartService;
@property (nonatomic, strong) FKYProductObject *productModel;

@property (nonatomic, strong) PDPopExceptionDetailVC *exceptionDetailVC;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) PDSameProductRecommendView *recommendView;
@property (nonatomic, strong) FKYBlankView *blankView;
@property (nonatomic, strong) FKYNetworkErrorView *errorView;
@property (nonatomic, strong) JSBadgeView *badgeView;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIView *navBar;

// 基本信息vc & 说明书vc
@property (nonatomic, strong) FKYProductionBaseInfoController *baseInfoController;
@property (nonatomic, strong) FKYProductionInstructionController *instructionController;

// 套餐vc
@property (nonatomic, strong) PDComboVC *comboVC; // 支持搭配套餐&固定套餐
@property (nonatomic, strong) PDFixedComboFailVC *fixedComboFailVC; // 固定套餐加车失败vc

// 不可购买之缺少经营范围弹出视图
@property (nonatomic, strong) PDTipsView *viewPop;

@property (nonatomic, assign) BOOL isAddAnimate; // 加车动画


@property (nonatomic, assign) BOOL showContact; //显示联系供应商

@property (nonatomic, strong) dispatch_source_t timer;

@end


@implementation FKYProductionDetailViewController
@synthesize  productionId = _productionId, schemeString = _schemeString, vendorId = _vendorId, updateCarNum = _updateCarNum,pushType = _pushType;

#pragma mark - LiftCircle

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 登录状态 //不能释放控制器暂时解决方式（后期优化）
    NDC_ADD_SELF_NOBJ(@selector(p_syncLoginStatus), FKYLoginSuccessNotification);
    NDC_ADD_SELF_NOBJ(@selector(p_syncLoginStatus), FKYLogoutCompleteNotification);
    // 提交购物车成后
    NDC_ADD_SELF_NOBJ(@selector(p_syncLoginStatus), FKYRefreshProductDetailNotification);
    // 监控键盘
   // NDC_ADD_SELF_NOBJ(@selector(keyboardWillShow:), UIKeyboardWillShowNotification);
    //NDC_ADD_SELF_NOBJ(@selector(keyboardWillHide:), UIKeyboardWillHideNotification);
    
    // UI
    [self setupView];
    // Request
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:NO];
    }
    
    //[[FKYAnalyticsManager sharedInstance] BI_Record:self extendParams:@{@"PageValue":[NSString stringWithFormat:@"%@/%@",_productionId,_vendorId]} eventId:nil];
    
    if (self.productModel) {
        [self updateCartNumber];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = nil;
    
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:NO];
    }
    // [[BaiduMobStat defaultStat] pageviewStartWithName:@"商详"];
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 3.0*NSEC_PER_SEC), 3.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self sendStrollInfoForCoupon];
            if (self.timer != nil){
                dispatch_cancel(self.timer);
                self.timer = nil;
            }
        });
    });
    //开启计时器
    dispatch_resume(_timer);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //  [[BaiduMobStat defaultStat] pageviewEndWithName:@"商详"];
    if (self.timer != nil){
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)dealloc
{
    NSLog(@"FKYProductionDetailViewController deinit~!@");
    [self dismissLoading];
    if (self.timer != nil){
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"内存不足");
}


#pragma mark - UI

- (void)setupView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.shareView];
    [self setupNavBar];
    [self errorNetwork];
    
    @weakify(self);
    // 底部操作栏
    PDBottomView *bottomView = [[PDBottomView alloc] initWithFrame:CGRectZero];
    [bottomView shadowWithColor:RGBACOLOR(0, 0, 0, 0.1) offset:CGSizeMake(0, -4) opacity:1 radius:4];
    // 跳转个人中心之修改经营范围
    bottomView.jumpToUpdateBlock = ^(){
        @strongify(self);
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            // 未登录
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }
        else {
            // 埋点
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6114" itemPosition:@"1" itemName:@"更新经营范围" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
            // 已登录，跳转资质管理
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CredentialsController) setProperty:^(id destinationViewController) {
                //CredentialsViewController *vc = destinationViewController;
                id<FKY_CredentialsController> vc = destinationViewController;
                vc.needJumpToDrugScope = 1;
            }];
        }
    };
    // 跳转购物车
    bottomView.jumpToCart = ^(){
        @strongify(self);
        // 埋点
        NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6109" itemPosition:@"3" itemName:@"购物车" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
        // 跳转购物车
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopCart) setProperty:^(id<FKY_ShopCart> destinationViewController) {
            destinationViewController.canBack = true;
        } isModal:false];
        // 百度移动统计之事件统计
        // [[BaiduMobStat defaultStat] logEvent:@"pd_cart" eventLabel:@"商详购物车入口"];
    };
    // 跳转店铺内
    bottomView.jumpToShopDetail = ^(){
        @strongify(self);
        // 埋点
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6109" itemPosition:@"2" itemName:@"店铺" itemContent:nil itemTitle:nil extendParams:dic viewController:self];
        // 跳转 店铺ID 有同品推荐的 取同品推荐里面的ID
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItem) setProperty:^(FKYNewShopItemViewController *destinationViewController) {
            @strongify(self);
            if (self.productModel.recommendModel.enterpriseInfo != nil &&self.productModel.recommendModel.enterpriseInfo.zhuanquTag == true){
                destinationViewController.shopType = @"1";
                destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.recommendModel.enterpriseInfo.enterpriseId];
            }else{
                if (self.productModel.recommendModel.enterpriseInfo != nil &&self.productModel.recommendModel.enterpriseInfo.enterpriseId != nil){
                    destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.recommendModel.enterpriseInfo.enterpriseId];
                }else{
                    destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
                }
            }
            
        }];
        
    };
    //立即下单
    bottomView.addOrderClosure = ^(){
        @strongify(self);
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            // 未登录
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }
        else {
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.productModel getPm_price],@"pm_price",[self.productModel getStorageData],@"storage",[self.productModel getPm_pmtn_type],@"pm_pmtn_type",[NSString stringWithFormat:@"%@|%@",self.vendorId,self.productionId],@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I5000" itemPosition:@"0" itemName:@"立即下单" itemContent:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode) itemTitle:nil extendParams:extentDic  viewController:self];
            [self.addCarView configAddCarForImmediatelyOrder:self.productModel :HomeString.PRODUCT_ADD_SOURCE_TYPE :true];
            [self.addCarView showOrHideAddCarPopView:true :self.view];
            //[self.addCarView showOrHideAddCarPopView:YES];
        }
        
    };
    //加入购物车
    bottomView.addCartAction = ^(){
        @strongify(self);
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            // 未登录
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }
        else {
            if ([self.productModel getSigleCanBuy] == false){
                //弹出套餐
                [self showOrHideProductGroupsView:YES];
            }else{
                //弹出加车框
                // let sourceType = self.getTypeSourceStr()
                //  [self.addCarView configAddCarViewController:(self.productModel,HomeString.PRODUCT_ADD_SOURCE_TYPE)];
                [self.addCarView configAddCarViewController:self.productModel :HomeString.PRODUCT_ADD_SOURCE_TYPE];
                [self.addCarView showOrHideAddCarPopView:true :self.view];
                //[self.addCarView showOrHideAddCarPopView:YES];
            }
            
        }
        
    };
    // 客服
    bottomView.settingClosure = ^(){
        @strongify(self);
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6109" itemPosition:@"1" itemName:@"联系商家" itemContent:nil itemTitle:nil extendParams:dic viewController:self];
        
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
        }
        else {
            if (self.productModel != nil) {
                NSString *imgPath = @"";
                if (self.productModel.picsInfo.count > 0) {
                    imgPath = self.productModel.picsInfo[0];
                }
                //shorName:商品通用名称 spec:规格 imgPath 商品图片链接
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC  *destinationViewController) {
                    @strongify(self);
                    NSMutableDictionary *extDic = [NSMutableDictionary new];
                    extDic[@"type"] = @"2";
                    extDic[@"data"] = @{@"spuCode":self.productionId,@"supplyId":self.vendorId,@"shortName":self.productModel.shortName,@"spec":self.productModel.spec,@"imgPath":imgPath,@"showPrice":[self getShowStr]};
                    destinationViewController.urlPath = [NSString stringWithFormat:@"%@?platform=3&supplyId=%@&ext=%@&openFrom=%d",API_IM_H5_URL,self.vendorId,extDic.jsonString,1];
                    destinationViewController.navigationController.navigationBarHidden = YES;
                } isModal:false];
            }
        }
    };
    // 修改数据
//    bottomView.showCountClosure = ^(NSInteger count){
//        @strongify(self);
//        [self.addNumBottomView.stepper.countLabel becomeFirstResponder];
//        [self.addNumBottomView configViewWithProductDetailModel:self.productModel];
//    };
    // 加车／更新
    @weakify(bottomView);
    
    bottomView.addCartBlock = ^{
        //@strongify(self);
    };
    //
    bottomView.cartNumChangedBlock = ^{
        //@strongify(self);
    };
    //加车or更新数量
    //    bottomView.addCartClosure = ^(NSInteger count, NSInteger typeIndex) {
    //        @strongify(self);
    //        if (typeIndex == 2 || typeIndex == 3) {
    //            //加车动画
    //            if (typeIndex == 2) {
    //                [self addCarAnimation];
    //            }
    //            return;
    //        }
    //
    //    };
    // 提示按钮
    bottomView.clickAlertClosure = ^(NSInteger count) {
        @strongify(self);
        // 商品状态
        NSString *status = self.productModel.priceInfo.status;
        if ([status  isEqual: @"-1"]) { // 未登录
            
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES];
        }
        else if ([status  isEqual: @"-2"]) { // 未加入渠道
            //
        }
        else if ([status  isEqual: @"-3"]) { // 资质未认证
            UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
                [actionDone setValue:UIColorFromRGB(0xFE5050) forKey:@"titleTextColor"];
            }
            //
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"您可以去电脑上完善资质，认证成功即可购买！" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:actionDone];
            if (self.presentedViewController == nil) {
                //防止模态窗口错误
                [self presentViewController:alertVC animated:YES completion:^{
                    //
                }];
            }
        }
        else if ([status  isEqual: @"-5"]) {
            // 3.7.5 所有商品可售库存<最小起批量，库存显示缺货，并显示【到货通知】按钮 -- 产品张宇松
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.productModel getPm_price],@"pm_price",[self.productModel getStorageData],@"storage",[self.productModel getPm_pmtn_type],@"pm_pmtn_type",[NSString stringWithFormat:@"%@|%@",self.vendorId,self.productionId],@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9997" itemPosition:@"0" itemName:@"到货通知" itemContent:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode) itemTitle:nil extendParams:extentDic  viewController:self];
            [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_ArrivalProductNoticeVC) setProperty:^(id destinationViewController) {
                ArrivalProductNoticeVC *shopItemVC = (ArrivalProductNoticeVC *)destinationViewController;
                shopItemVC.productId = self.productModel.spuCode;
                shopItemVC.venderId = [NSString stringWithFormat:@"%@",self.productModel.sellerCode];
                shopItemVC.productUnit = self.productModel.unit;
            }];
        }
        else if ([status  isEqual: @"-13"]) { // 已达限购总数
            NSString *tip = [NSString stringWithFormat:@"此商品每周限购%@盒，您本周的采购数量已达上限，请下周再来看看吧", self.productModel.productLimitInfo.weekLimitNum];
            [self toast:tip];
        }
        //        else { // 加车
        //            //
        //            NSString *outOfStock = (status == -5) ? @"1" : @"0";
        //
        //            // (商详)单品加车请求
        //            @weakify(self);
        //            [self.detailService addToCartWithProductId:self.productModel.productId quantity:count success:^(BOOL mutiplyPage, id data) {
        //                @strongify(self);
        //                // 加车成功
        //                [self toast:@"加入购物车成功"];
        //            } falure:^(NSString *reason, id data) {
        //                @strongify(self);
        //                // 加车失败
        //                [self toast:reason];
        //                // 限购逻辑
        //                if (data && [data isKindOfClass:[NSDictionary class]]) {
        //                    NSDictionary *dic = (NSDictionary *)data;
        //                    NSNumber *limit = dic[@"limitCanBuyNum"];
        //                    if (limit) {
        //                        [self updateSetpperNumber:limit.intValue];
        //                    }
        //                }
        //                // <听云>自定义Event
        //                [NBSAppAgent trackEvent:@"商详之单品加车失败"];
        //            }];
        //        }
    };
    // toast
    bottomView.toastClosure = ^(NSString *msg){
        @strongify(self);
        [self toast:msg];
    };
    [self.view addSubview:bottomView];
    
    CGFloat bottomViewHeight = 64;
    CGFloat navigationBarHeight = 64;
    CGFloat bottomMargin = 0;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomViewHeight += iPhoneX_SafeArea_BottomInset;
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
            bottomMargin = iPhoneX_SafeArea_BottomInset;
        }
    }
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FKYWH(64));
        make.bottom.equalTo(self.view).offset(-bottomMargin);
    }];
    self.bottomView = bottomView;
    
    UIView *bottomBgView = [[UIView alloc]init];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(bottomMargin);
        make.bottom.equalTo(self.view);
    }];
    
    // 不可购买之缺少经营范围提示
    [self.view addSubview:self.viewPop];
    [self.viewPop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(FKYWH(0)));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    self.viewPop.hidden = YES;
    
    // 主容器视图
    self.mainScrollView = [UIScrollView new];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.viewPop.mas_top);
    }];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.mainScrollView.backgroundColor = [UIColor redColor];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    
    // 商品
    self.baseInfoController = [[FKYProductionBaseInfoController alloc] init];
    //@weakify(self);
    // 显示套餐视图
    self.baseInfoController.showGroupViewBlock = ^(NSString *promationName){
        @strongify(self);
        [self showOrHideProductGroupsView:YES];
    };
    self.baseInfoController.showSameProductRecommendViewBlock = ^{
        @strongify(self);
        [self.recommendView updateView:self.productModel.MPProducts];
        self.recommendView.appearClourse();
    };
    self.baseInfoController.loginActionBlock = ^{
        @strongify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
    };
    [self.mainScrollView addSubview:self.baseInfoController.view];
    [self addChildViewController:self.baseInfoController];
    [self.baseInfoController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.mainScrollView);
        make.height.equalTo(self.mainScrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    // 说明书
    self.instructionController = [[FKYProductionInstructionController alloc] init];
    [self.mainScrollView addSubview:self.instructionController.view];
    [self addChildViewController:self.instructionController];
    [self.instructionController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollView);
        make.height.equalTo(self.mainScrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.left.equalTo(self.baseInfoController.view.mas_right);
    }];
    
    //    // 导航栏右侧购物车按钮上面增加角标
    //    self.badgeView = ({
    //        @strongify(self);
    //        JSBadgeView *bv = [[JSBadgeView alloc] initWithParentView:[self fky_NavigationBarRightBarButton] alignment:JSBadgeViewAlignmentTopRight];
    //        bv.badgeBackgroundColor = UIColorFromRGB(0xFF2D5C);
    //        bv.badgeTextColor = [UIColor whiteColor];
    //        bv.badgePositionAdjustment = CGPointMake(FKYWH(-16), FKYWH(12));
    //        bv.badgeTextFont = FKYSystemFont(FKYWH(11));
    //        bv;
    //    });
    //
    //    // 购物车数量
    //    NSInteger badgeCount = [[FKYCartModel shareInstance] productCount];
    //    if (badgeCount > 0) {
    //        if (badgeCount > 99) {
    //            self.badgeView.badgeText = @"99+";
    //        }
    //        else {
    //            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)badgeCount];
    //        }
    //    }
    //    else {
    //        self.badgeView.badgeText = @"";
    //    }
    
    // 加车视图
//    self.addNumBottomView = [[PDProductAddNumView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ADD_NUM_H)];
//    [self.view addSubview:self.addNumBottomView];
//
//    self.addNumBottomView.addNumClosure = ^(NSInteger count){
//        @strongify(self);
//        [self.addNumBottomView.stepper.countLabel resignFirstResponder];
//        [self.bottomView resetStepperWithNum:count];
//    };
//    self.addNumBottomView.toastClosure = ^(NSString * msg) {
//        @strongify(self);
//        [self toast:msg];
//    };
    
    //    // KVO...<若检测到购物车数量有改变，则自动更新角标>
    //    [[RACObserve([FKYCartModel shareInstance], productCount) filter:^BOOL(NSNumber *count) {
    //        //        return count.integerValue > 0;
    //        return YES;
    //    }] subscribeNext:^(NSNumber *count) {
    //        @strongify(self);
    //        dispatch_time_t deadline;
    //        if (self.isAddAnimate) {
    //            deadline = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    //        }else {
    //            deadline = dispatch_time(DISPATCH_TIME_NOW, 0);
    //        }
    //        dispatch_after(deadline, dispatch_get_main_queue(), ^{
    //            @strongify(self);
    //            NSInteger num = count.integerValue;
    //            if (num <= 0) {
    //                self.badgeView.badgeText = @"";
    //            } else if (num > 99) {
    //                self.badgeView.badgeText = @"99+";
    //            } else {
    //                self.badgeView.badgeText = count.stringValue;
    //            }
    //        });
    //    }];
    //
}

- (void)setupNavBar
{
    self.navBar = [self fky_NavigationBar];
    self.navBar.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    // 返回
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        @strongify(self);
        NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I6101" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
        [[FKYNavigator sharedNavigator] pop];
    }];
    // 购物车
    [self fky_addNavitationBarRightButtonEventHandler:^(id sender) {
        @strongify(self);
        
        // 弹出分享视图
        self.shareView.appearClourse();
        // 百度移动统计之事件统计
        // [[BaiduMobStat defaultStat] logEvent:@"pd_share" eventLabel:@"商详分享入口"];
        // 埋点
        NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I6101" itemPosition:@"4" itemName:@"分享" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    [self fky_setNavitationBarRightButtonImage:[UIImage imageNamed:@"btn_pd_share"]];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"商品", @"说明书", nil]];
    control.backgroundColor = [UIColor clearColor];
    control.layer.borderColor = UIColorFromRGBA(0xFF2D5C, 1).CGColor;
    control.tintColor = UIColorFromRGB(0xFF2D5C);
    control.selectedSegmentIndex = 0;
    [control ensureiOS12Style];
    [control addTarget:self action:@selector(scrollViewContentOffsetChange) forControlEvents:UIControlEventValueChanged];
    self.segmentControl = control;
    [self.navBar addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar);
        make.height.mas_equalTo(FKYWH(28));
        make.bottom.equalTo(self.navBar).offset(-FKYWH(8));
    }];
    
    //    // 分享
    //    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    //    share.backgroundColor = [UIColor clearColor];
    //    [share setImage:[UIImage imageNamed:@"btn_pd_share"] forState:UIControlStateNormal];
    //    [[share rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //        @strongify(self);
    //        // 弹出分享视图
    //        self.shareView.appearClourse();
    //        // 百度移动统计之事件统计
    //        [[BaiduMobStat defaultStat] logEvent:@"pd_share" eventLabel:@"商详分享入口"];
    //        // 埋点
    //        NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.vendorId, self.productModel.spuCode),@"pageValue", nil];
    //        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I6101" itemPosition:@"4" itemName:@"分享" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
    //    }];
    //    self.shareButton = share;
    //
    //    [self.navBar addSubview:self.shareButton];
    //    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.navBar);
    //        make.size.mas_equalTo(CGSizeMake(FKYWH(44), FKYWH(44)));
    //        make.right.equalTo([self fky_NavigationBarRightBarButton].mas_left).offset(FKYWH(-2));
    //    }];
}

// 网络错误页
- (void)errorNetwork
{
    @weakify(self);
    self.errorView = ({
        @strongify(self);
        FKYNetworkErrorView *view = [[FKYNetworkErrorView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
        view;
    });
}


#pragma mark - UserAction

- (void)scrollViewContentOffsetChange
{
    NSInteger integer = [self.segmentControl selectedSegmentIndex];
    switch (integer) {
        case 0:
        {
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I6101" itemPosition:@"2" itemName:@"商品" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
            self.mainScrollView.contentOffset = CGPointZero;
        }
            break;
        case 1:
        {
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I6101" itemPosition:@"3" itemName:@"说明书" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
            self.mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }
            break;
        default:
            break;
    }
}


#pragma mark - Public

//


#pragma mark - Private

// 同步购物车数量
- (void)syncCartCount
{
    for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
        if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:self.productModel.spuCode] &&
            cartModel.supplyId.intValue == self.productModel.sellerCode.intValue) {
            self.productModel.carId = cartModel.cartId;
            self.productModel.carOfCount = cartModel.buyNum;
            break;
        }
    }
    // 更新底部操作栏
    [self.bottomView configView:self.productModel showBtn:self.showContact];
}

// 更新底部加车视图 & 整个商详控件布局
- (void)updateCartBarHeight:(BOOL)canBuy withStatus:(NSString *)statusDesc
{
    // 默认底部栏高度较大=64
    BOOL tall = YES;
    if (canBuy) {
        // 可以购买
        tall = YES;
    }
    else {
        // 不可购买
        if (statusDesc && [statusDesc  isEqual: @"2"]) {
            // 缺少经营范围之不可购买
            tall = YES;
        }else if([self.productModel getSigleCanBuy] == false){
            tall = YES;
        }
        else {
            // 其它之不可购买
            tall = NO;
        }
    }
    
    CGFloat bottomViewHeight = tall ? 64 : 50;
    CGFloat navigationBarHeight = 64;
    CGFloat viewHeight = tall ? 64 : 50;
    CGFloat bottomMargin = 0;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomViewHeight += iPhoneX_SafeArea_BottomInset;
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
            bottomMargin = iPhoneX_SafeArea_BottomInset;
        }
    }
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(FKYWH(viewHeight));
    }];
    [self.view layoutIfNeeded];
}

//
- (void)errorNetViewAppear
{
    [self.view bringSubviewToFront:self.errorView];
    // self.shareButton.hidden = YES;
    [self fky_NavigationBarRightBarButton].hidden = YES;
}

//
- (void)noProductViewAppearWithTitle:(NSString *)title
{
    self.blankView = ({
        FKYBlankView *view = [FKYBlankView FKYBlankViewInitWithFrame:CGRectZero andImage:[UIImage imageNamed:@"icon_production_face"] andTitle:title andSubTitle:nil];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
        [self.view bringSubviewToFront:view];
        view;
    });
    // self.shareButton.hidden = YES;
    [self fky_NavigationBarRightBarButton].hidden = YES;
}

//
- (void)updateSetpperNumber:(int)num
{
    [self.bottomView setSetpperNumber:num];
}

// 不可购买提示视图
- (void)showOrHidePopView
{
    // 默认隐藏
    self.viewPop.hidden = YES;
    if (self.productModel && self.productModel.priceInfo && self.productModel.priceInfo.tips.length > 0) {
        self.viewPop.hidden = NO;
        [self.viewPop mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(FKYWH(32)));
        }];
    }else{
        self.viewPop.hidden = true;
        [self.viewPop mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(FKYWH(0)));
        }];
    }
}
//点击去更新经营范围
-(void)updateBusinessScope{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        // 未登录
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
    }
    else {
        if ([self.productModel.priceInfo.status  isEqual: @"-3"]) { // 资质未认证
            UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
                [actionDone setValue:UIColorFromRGB(0xFE5050) forKey:@"titleTextColor"];
            }
            //
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"您可以去电脑上完善资质，认证成功即可购买！" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:actionDone];
            if (self.presentedViewController == nil) {
                //防止模态窗口错误
                [self presentViewController:alertVC animated:YES completion:^{
                    //
                }];
            }
        }
        else if ([self.productModel.priceInfo.status  isEqual: @"2"]) {
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6114" itemPosition:@"1" itemName:@"更新经营范围" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
            // 已登录，跳转资质管理
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CredentialsController) setProperty:^(id destinationViewController) {
                //CredentialsViewController *vc = destinationViewController;
                id<FKY_CredentialsController> vc = destinationViewController;
                vc.needJumpToDrugScope = 1;
            }];
        }
        
    }
}
// 显示or隐藏套餐视图
- (void)showOrHideProductGroupsView:(BOOL)showFlag
{
    if (showFlag) {
        // 显示
        if (_comboVC) {
            // 先释放之前的VC
            [_comboVC.view removeFromSuperview];
            _comboVC = nil;
        }
        
        // 重置套餐状态
        [self resetProductGroupStatus];
        
        // pop out
        [self.comboVC showOrHideGroupPopView:YES];
    }
    else {
        // 隐藏
        if (!_comboVC) {
            return;
        }
        UIView *popView = self.comboVC.view;
        if (!popView.superview) {
            return;
        }
        
        // dismiss
        [self.comboVC showOrHideGroupPopView:NO];
    }
}

// 每次弹出套餐前，均需要重置
- (void)resetProductGroupStatus
{
    if (self.productModel && self.productModel.dinnerInfo && self.productModel.dinnerInfo.dinnerList && self.productModel.dinnerInfo.dinnerList.count > 0) {
        // 遍历所有套餐
        for (FKYProductGroupModel *group in self.productModel.dinnerInfo.dinnerList) {
            if (group.productList && group.productList.count > 0) {
                // 遍历当前套餐下的所有商品
                for (FKYProductGroupItemModel *product in group.productList) {
                    product.unselected = NO;
                    product.inputNumber = 0;
                } // for
            }
            // 所有套餐数据默认为1
            group.groupNumber = 1;
        } // for
    }
}

// 显示固定套餐加车失败视图
- (void)showFixedComboFailView:(NSArray *)arrProducts andReason:(NSString *)reason
{
    self.fixedComboFailVC.arrayProduct = arrProducts;
    self.fixedComboFailVC.failTitle = reason;
    [self.fixedComboFailVC setupData];
    [self.fixedComboFailVC showOrHidePopView:YES];
}

// 固定套餐加车时，由于（超过）限购数，从而导致加车失败。用户在弹出的失败(列表)视图中点击确定后，需重新弹出加车视图
- (void)showFixedComboViewForLimitBuy:(NSInteger)count comboIndex:(NSInteger)index
{
    NSInteger maxCount = count > 0 ? count : 1;
    
    if (_comboVC) {
        // 先释放之前的VC
        [_comboVC.view removeFromSuperview];
        _comboVC = nil;
    }
    
    // 重置套餐状态
    [self resetProductGroupStatus];
    
    // 指定索引处的固定套餐的加车数量直接设置为最大加车数（限购数）
    if (self.productModel && self.productModel.dinnerInfo && self.productModel.dinnerInfo.dinnerList && self.productModel.dinnerInfo.dinnerList.count > 0 && self.productModel.dinnerInfo.dinnerList.count > index) {
        FKYProductGroupModel *combo = self.productModel.dinnerInfo.dinnerList[index];
        combo.groupNumber = maxCount; // 重置套餐数量
        for (FKYProductGroupItemModel *item in combo.productList) {
            NSInteger baseNumber = [item getBaseNumber];
            item.inputNumber = baseNumber * [combo getGroupNumber]; // 重置商品数量
        } // for
    }
    
    // pop out
    [self.comboVC showOrHideGroupPopView:YES];
    
    // 直接展示指定索引处的套餐
    [self.comboVC showCurrentComboForIndex:index];
}

// 加车动画
- (void)addCarAnimation
{
    UIImageView *desImageView = [UIImageView new];
    if (self.productModel.picsInfo.count > 0) {
        [desImageView sd_setImageWithURL:[NSURL URLWithString: [self.productModel.picsInfo[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
    }
    else {
        desImageView.image = [UIImage imageNamed:@"image_default_img"];
    }
    
    CGFloat desX = SCREEN_WIDTH/2.0;
    CGFloat desY = FKYWH(220)/2.0 - FKYWH(8);
    CGRect desRect = CGRectMake(desX, desY,FKYWH(40),FKYWH(40));
    CGPoint finishPoint = CGPointMake(SCREEN_WIDTH - FKYWH(10)-self.fky_NavigationBarRightBarButton.frame.size.width/2.0, [self fky_NavigationBarHeight]-FKYWH(5)-self.fky_NavigationBarRightBarButton.frame.size.height/2.0);
    [[FKYAddCarAnimatTool new] startAnimationWithBgView:self.view view:desImageView andRect:desRect andFinishedRect:finishPoint andFinishBlock:^(BOOL finish) {
        //
    }];
}

// 获取传给im使用的显示字符串
- (NSString *)getShowStr
{
    NSString *showStr = @"";
    if ([self.productModel.priceInfo.status  isEqual: @"-1"]){
        showStr = @"登录后可见";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-2"]) {
        showStr = @"控销";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-3"]) {
        showStr = @"资质认证后可见";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-4"]) {
        showStr = @"控销";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-7"]) {
        showStr = @"已下架";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-9"]) {
        showStr = @"申请权限后可见";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-10"]) {
        showStr = @"权限审核后可见";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-11"]) {
        showStr = @"申请权限后可见";
    }else if ([self.productModel.priceInfo.status  isEqual: @"-12"]) {
        showStr = @"申请权限后可见";
    }else {
        // 展示价格(原价)
        if (self.productModel.productPromotion.promotionPrice.floatValue > 0 ){
            // 有特价
            showStr = [NSString stringWithFormat:@"%.2f",self.productModel.productPromotion.promotionPrice.floatValue] ;
        }else if(self.productModel.vipPromotionInfo.vipPromotionId.length > 0 &&  self.productModel.vipPromotionInfo.visibleVipPrice.floatValue > 0 && self.productModel.vipModel.vipSymbol == 1) {
            // vip价
            showStr = [NSString stringWithFormat:@"%.2f",self.productModel.vipPromotionInfo.visibleVipPrice.floatValue];
        }else {
            // 现价
            showStr = [NSString stringWithFormat:@"%.2f",self.productModel.priceInfo.price.floatValue];
        }
    }
    return showStr;
}


#pragma mark - Notification

- (void)p_syncLoginStatus
{
    // 刷新数据
    [self requestData];
}

// 键盘将要出现
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    if (_comboVC != nil && _comboVC.viewShowFlag == true) {
//        return;
//    }
//
//    NSDictionary *userInfo = [notification userInfo];
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    [self.view bringSubviewToFront:self.addNumBottomView];
//    @weakify(self);
//    [UIView animateWithDuration:[duration floatValue] animations:^{
//        @strongify(self);
//        self.addNumBottomView.frame = CGRectMake(0, SCREEN_HEIGHT-ADD_NUM_H-keyboardRect.size.height, SCREEN_WIDTH, ADD_NUM_H);
//        [self.view layoutIfNeeded];
//    }];
//}

// 键盘将要消失
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    if (_comboVC != nil && _comboVC.viewShowFlag == true) {
//        return;
//    }
//
//    NSDictionary *userInfo = [notification userInfo];
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    @weakify(self);
//    [UIView animateWithDuration:[duration floatValue] animations:^{
//        @strongify(self);
//        self.addNumBottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ADD_NUM_H);
//        [self.view layoutIfNeeded];
//    }];
//}


#pragma mark - Request

// 请求商详数据
- (void)requestData
{
    [self showLoading];
    // <听云>自定义Trace...<begin>
    beginTracer(@"请求商详")
    @weakify(self);
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"spuCode"] = self.productionId;
    parameters[@"sellerCode"] = self.vendorId;
    if (self.pushType != nil && self.pushType.length > 0){
        parameters[@"pushType"] = self.pushType;
    }
    
    [self.detailService producationInfoWithParam:parameters success:^(FKYProductObject *model){
        @strongify(self);
        // 保存商品信息model
        self.productModel = model;
        if (model.priceNoticeMsg != nil && ![model.priceNoticeMsg isEqual:[NSNull null]] && model.priceNoticeMsg.length > 0){
            [self toast:model.priceNoticeMsg];
        }
        // 基本信息vc展示数据
        self.baseInfoController.productModel = self.productModel;
        [self.baseInfoController resetProductTableOffset];
        [self.baseInfoController showContent];
        [self.baseInfoController upLoadViewData];
        // 说明书vc展示数据
        self.instructionController.productModel = self.productModel;
        [self.instructionController showContent];
        // 底部操作栏
        if (self.productModel) {
            // 判断是否可购买
            [self.viewPop updatePurchaseStatus:self.productModel];
            // 更新底部操作栏高度
            [self updateCartBarHeight:model.priceInfo.productStatus withStatus:model.priceInfo.status];
        }
        // 不可购买提示视图
        [self showOrHidePopView];
        // 移除loading
        [self dismissLoading];
        // 请求联系客服按钮显示状态
        [self requestIMData];
        // 请求优惠券数据
        [self requestCouponData];
        // 请求推荐商品
        [self requestShopAndRecommendData];
        // 请求购物车中商品数量
        [self updateCartNumber];
        // <听云>自定义Trace...<end>
        endTracer(@"请求商详")
    } failure:^(NSString *reason) {
        @strongify(self);
        [self dismissLoading];
        // 之前已获取商详数据，后面刷新失败，则不做操作
        if (self.productModel) {
            return;
        }
        // 失败提示
        if (reason) {
            if ([reason containsString:@"该商品不存在"]) {
                [self noProductViewAppearWithTitle:reason];
            } else if ([reason containsString:@"查询商品详情失败"]){
                [self noProductViewAppearWithTitle:@"查询商品详情失败"];
            } else {
                [self errorNetViewAppear];
            }
        }
        // <听云>自定义Event
        [NBSAppAgent trackEvent:@"获取商详失败"];
        // <听云>自定义Trace...<end>
        endTracer(@"请求商详")
    }];
}

// 判断是否显示联系客服入口
- (void)requestIMData
{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        // 隐藏卖家入口
        self.showContact = false;
        // 更新
        [self.bottomView configView:self.productModel showBtn:self.showContact];
        return;
    }
    @weakify(self);
    [[FKYRequestService sharedInstance] requesImShowWithParam:@{@"enterpriseId":self.vendorId} completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        @strongify(self);
        // 保存
        if (isSucceed && [[NSString stringWithFormat:@"%@", response] isEqualToString:@"0"]) {
            // 展示卖家客服入口
            self.showContact = true;
        }
        else {
            // 隐藏卖家入口
            self.showContact = false;
        }
        // 更新
        [self.bottomView configView:self.productModel showBtn:self.showContact];
    }];
}

// 请求店铺信息及同品热卖数据...<包含两个商品列表>
- (void)requestShopAndRecommendData
{
    if (!self.productModel) {
        return;
    }
    
    //NSString *productId = self.productionId;
    //NSString *enterpriseId = self.vendorId;
    //NSDictionary *dic = @{@"productId": productId, @"enterpriseid": enterpriseId};
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.productionId && self.productionId.length > 0) {
        [dic setObject:self.productionId forKey:@"productId"];
    }
    if (self.vendorId && self.vendorId.length > 0) {
        [dic setObject:self.vendorId forKey:@"enterpriseId"];
    }
    if (self.productModel.secondCategory && self.productModel.secondCategory.length > 0) {
        [dic setObject:self.productModel.secondCategory forKey:@"secondCategory"];
    }
    if (self.productModel.thirdCategory && self.productModel.thirdCategory.length > 0) {
        [dic setObject:self.productModel.thirdCategory forKey:@"thirdCategory"];
    }
    //为同品推荐的接口慢做的改变
    self.productModel.recommendModel = nil;
    [self.baseInfoController refreshContentForList];
    @weakify(self);
    [[FKYRequestService sharedInstance] getProductListForRecommendWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        @strongify(self);
        if (!isSucceed) {
            NSLog(@"请求推荐商品失败");
            return;
        }
        if (model && [model isKindOfClass:[FKYProductRecommendListModel class]]) {
            self.productModel.recommendModel = (FKYProductRecommendListModel *)model;
            [self.baseInfoController refreshContentForList];
        }
    }];
}

// 请求优惠券数据
- (void)requestCouponData
{
    if (!self.productModel) {
        return;
    }
    
    // 只有商品状态为0 or -5时，才请求优惠券数据并显示入口
    if ( !([self.productModel.priceInfo.status  isEqual: @"0"] || [self.productModel.priceInfo.status  isEqual: @"-5"]) ) {
        return;
    }
    
    if (self.productModel.spuCode == nil) {
        self.productModel.spuCode = self.productionId;
    }
    if (self.productModel.sellerCode == nil) {
        self.productModel.sellerCode = @(self.vendorId.integerValue);
    }
    
    NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
    NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"enterprise_id"] = enterpriseId;
    dic[@"spu_code"] = spuCode;
    dic[@"mode"] = @"1";
    dic[@"amount"] = @"3";
    @weakify(self);
    [[FKYRequestService sharedInstance] getCommonCouponListInfoWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, NSArray<CommonCouponNewModel *> *model) {
        @strongify(self);
        if (isSucceed) {
            //请求成功
            self.productModel.couponList = model;
            [self.baseInfoController showContent];
        }else {
            //请求失败
        }
    }];
    // Swift
    //    @weakify(self);
    //    CouponProvider *couponProvider = [[CouponProvider alloc] init];
    //    [couponProvider fetchCouponReceiveListWithSpuCode:spuCode enterpriseId:enterpriseId needAll:1 callback:^(NSArray *couponItems, NSString *message) {
    //        @strongify(self);
    //        if (message) {
    //            NSLog(@"请求优惠券失败");
    //            // <听云>自定义Event
    //            [NBSAppAgent trackEvent:@"商详之请求优惠券失败"];
    //            return;
    //        }
    //        self.productModel.couponList = couponItems;
    //        [self.baseInfoController showContent];
    //    }];
}

// 搭配套餐加车请求
- (void)addCartForCombinedCombo:(FKYProductGroupModel *)group
{
    [self showLoading];
    @weakify(self);
    [self.detailService addToCartWithGroup:group success:^(BOOL mutiplyPage, id data) {
        @strongify(self);
        [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
            @strongify(self);
            [self dismissLoading];
            // 加车成功
            [self showOrHideProductGroupsView:NO];
            [self toast:@"加入购物车成功"];
            // 0.5s后刷新商详数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.baseInfoController resetProductTableOffset];
                [self requestData];
            });
            [self popAlertThousandCouponsVC:data];
        } failure:^(NSString *reason) {
            @strongify(self);
            [self dismissLoading];
            [self toast:reason];
        }];
    } falure:^(NSString *reason, id data) {
        @strongify(self);
        [self dismissLoading];
        // 加车失败
        if (reason && reason.length > 0) {
            [self toast:reason];
        }
        else {
            [self toast:@"加入购物车失败"];
        }
        [self showOrHideProductGroupsView:NO];
        // 0.5s后刷新商详数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.baseInfoController resetProductTableOffset];
            [self requestData];
        });
        // <听云>自定义Event
        [NBSAppAgent trackEvent:@"商详之搭配套餐加车失败"];
    }];
}

// 固定套餐加车请求
- (void)addCartForFixedCombo:(FKYProductGroupModel *)group withIndex:(NSInteger)index
{
    [self showLoading];
    @weakify(self);
    [self.detailService addToCartWithFixedGroup:group success:^(BOOL mutiplyPage, id data) {
        @strongify(self);
        [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
            @strongify(self);
            [self dismissLoading];
            // 加车成功
            [self showOrHideProductGroupsView:NO];
            [self toast:@"加入购物车成功"];
            // 0.5s后刷新商详数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.baseInfoController resetProductTableOffset];
                [self requestData];
            });
            [self popAlertThousandCouponsVC:data];
        } failure:^(NSString *reason) {
            @strongify(self);
            [self dismissLoading];
            [self toast:reason];
        }];
    } falure:^(NSString *reason, id data) {
        @strongify(self);
        [self dismissLoading];
        // 加车失败
        [self showOrHideProductGroupsView:NO];
        // 失败原因
        NSInteger status = 1; // 默认为加车失败，非限购
        NSString *title = (reason && reason.length > 0) ? reason : @"加入购物车失败";
        NSArray *list = @[];
        int maxCount = 1; // 若限购，则会返回最大可购买数量
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            // 1：失败，2：限购
            status = [dic[@"statusCode"] integerValue];
            // 商品列表
            NSArray *pList = [NSArray yy_modelArrayWithClass:[FKYFixedComboItemModel class] json:dic[@"cartResponseList"]]; // 套餐内商品加车失败原因...<失败时有>
            list = (pList != nil && pList.count > 0 ? pList : @[]);
            // 当前用户可购买的最大套餐数（套餐子品购买套数超过最大可购买套餐数）...<超过最大实际库存时有>
            if (![dic[@"surplusNum"] isEqual:[NSNull null]]){
                maxCount = [dic[@"surplusNum"] intValue];
            }
        }
        // (保存)传递最大限购数
        if (status == 2) {
            // 限购...<若是限购，则需重新弹出加车视图>
            self.fixedComboFailVC.maxCount = maxCount;
            self.fixedComboFailVC.reshowAddCart = NO;
            self.fixedComboFailVC.comboIndex = index;
        }
        else {
            // 失败
            self.fixedComboFailVC.maxCount = 1;
            self.fixedComboFailVC.reshowAddCart = NO;
            self.fixedComboFailVC.comboIndex = index;
        }
        // 显示弹出视图
        [self showFixedComboFailView:list andReason:title];
        // 0.5s后刷新商详数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.baseInfoController resetProductTableOffset];
            [self requestData];
        });
        // <听云>自定义Event
        [NBSAppAgent trackEvent:@"商详之固定套餐加车失败"];
    }];
}
//商品加车
-(void)addProductIntoCart:(NSInteger)count{
    [self showLoading];
    @weakify(self);
    if ([self.productModel.carOfCount integerValue] > 0 && self.productModel.carId) {
        // 更新购物车中商品数量...<更新or删除>
        [self showLoading];
        
        if (count == 0) {
            // 删除
            self.isAddAnimate = NO;
            [self.cartService deleteShopCart:@[self.productModel.carId] success:^(BOOL mutiplyPage) {
                [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
                    @strongify(self);
                    self.productModel.carId = [NSNumber numberWithInteger:0];
                    self.productModel.carOfCount = [NSNumber numberWithInteger:0];
                    
                    [self syncCartCount];
                    
                    if (self.updateCarNum) {
                        self.updateCarNum(self.productModel.carId, self.productModel.carOfCount);
                    }
                    [self dismissLoading];
                } failure:^(NSString *reason) {
                    @strongify(self);
                    [self dismissLoading];
                    [self toast:reason];
                    [self.bottomView resetStepperNum];
                }];
            } failure:^(NSString *reason) {
                // 更新失败
                @strongify(self);
                [self.bottomView resetStepperNum];
                [self toast:reason];
                [self dismissLoading];
            }];
        }
        else {
            // 更新购物车...<增加or减少>...<商品数量变化时需刷新数据>
            self.isAddAnimate = YES;
            [self.cartService updateShopCartForProduct:[NSString stringWithFormat:@"%@",self.productModel.carId] quantity:count allBuyNum:-1 success:^(BOOL mutiplyPage,id aResponseObject) {
                // 更新成功
                @strongify(self);
                [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
                    @strongify(self);
                    [self dismissLoading];
                    
                    self.productModel.carOfCount = [NSNumber numberWithInteger:count];
                    [self syncCartCount];
                    if (self.updateCarNum) {
                        self.updateCarNum(self.productModel.carId, self.productModel.carOfCount);
                    }
                } failure:^(NSString *reason) {
                    // 更新失败
                    @strongify(self);
                    
                    [self.bottomView resetStepperNum];
                    [self toast:reason];
                    [self dismissLoading];
                }];
            } failure:^(NSString *reason) {
                // 更新失败
                @strongify(self);
                
                [self.bottomView resetStepperNum];
                [self toast:reason];
                [self dismissLoading];
            }];
        }
    }
    else if (count > 0) {
        // 加车...<从0到1>
        [self showLoading];
        
        // 埋点
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9999" itemPosition:nil itemName:nil itemContent:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode) itemTitle:nil extendParams:nil viewController:self];
        
        // 购物车界面加车请求
        @weakify(self);
        [self.detailService addToCartWithProductId:self.productModel.productId quantity:count success:^(BOOL mutiplyPage, id data) {
            @strongify(self);
            // 加车成功
            [self dismissLoading];
            // 同步购物车中商品信息
            [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
                //
                @strongify(self);
                for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
                    if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:self.productModel.spuCode] && cartModel.supplyId.integerValue == self.productModel.sellerCode.integerValue){
                        self.productModel.carId = cartModel.cartId;
                        self.productModel.carOfCount = cartModel.buyNum;
                        break;
                    }
                }
                if (self.updateCarNum) {
                    self.updateCarNum(self.productModel.carId, self.productModel.carOfCount);
                }
                //修正客户组有最小起批数量的问题
                [self.bottomView configView:self.productModel showBtn:self.showContact];
                [self dismissLoading];
            } failure:^(NSString *reason) {
                @strongify(self);
                
                [self dismissLoading];
                [self toast:reason];
                [self.bottomView resetStepperNum];
            }];
        } falure:^(NSString *reason, id data) {
            @strongify(self);
            
            // 加车失败
            [self.bottomView resetStepperNum];
            [self dismissLoading];
            [self toast:reason];
            // 限购逻辑
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)data;
                NSNumber *limit = dic[@"limitCanBuyNum"];
                if (limit) {
                    [self updateSetpperNumber:limit.intValue];
                }
            }
        }];
    }
}
// 从购物车回来后刷新数据
- (void)updateCartNumber
{
    if (!self.productModel) {
        return;
    }
    
    @weakify(self);
    [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
        @strongify(self);
        if ([FKYCartModel shareInstance].productArr.count > 0) {
            for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
                if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:self.productModel.spuCode] && cartModel.supplyId.integerValue ==  self.productModel.sellerCode.integerValue) {
                    self.productModel.carOfCount = cartModel.buyNum;
                    self.productModel.carId = cartModel.cartId;
                    break;
                }else{
                    self.productModel.carOfCount = 0;
                    self.productModel.carId = 0;
                }
            }
            //更新推荐商品的数量
            for (FKYSameProductModel *sameModel in self.productModel.MPProducts) {
                for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
                    if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:sameModel.spuCode] && cartModel.supplyId.integerValue == sameModel.supplyId.integerValue) {
                        sameModel.carOfCount = cartModel.buyNum.integerValue;
                        sameModel.carId = cartModel.cartId.integerValue;
                        break;
                    }else{
                        sameModel.carOfCount = 0;
                        sameModel.carId = 0;
                    }
                }
            }
        }else{
            self.productModel.carOfCount = 0;
            self.productModel.carId = 0;
            //更新推荐商品的数量
            for (FKYSameProductModel *sameModel in self.productModel.MPProducts) {
                sameModel.carOfCount = 0;
                sameModel.carId = 0;
            }
        }
        // 更新底部操作栏
        [self.bottomView configView:self.productModel showBtn:self.showContact];
    } failure:^(NSString *reason) {
        @strongify(self);
        [self toast:reason];
        // 更新底部操作栏
        [self.bottomView configView:self.productModel showBtn:self.showContact];
    }];
}
// 立即下单商品校验
- (void)checkProductForImmediatelyOrder:(NSInteger)count model:(FKYProductObject *)productModel
{
    NSMutableArray *desArr = [NSMutableArray array];
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    mutDic[@"supplyId"] = self.vendorId;
    mutDic[@"productNum"] = [NSNumber numberWithInteger:count];
    mutDic[@"spuCode"] = self.productModel.spuCode;
    if ([FKYPush sharedInstance].pushID != nil && ![[FKYPush sharedInstance].pushID isEqual:[NSNull null]] && [FKYPush sharedInstance].pushID.length >1) {
        mutDic[@"pushId"] = [FKYPush sharedInstance].pushID;
    }
    [desArr addObject:mutDic];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"itemList"] = desArr.gl_JSONString;
    
    @weakify(self);
    [FKYRequestService.sharedInstance postCheckSimpleItemInfoWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        @strongify(self);
        if (error == nil) {
            if ([model isKindOfClass:[PDOrderChangeInfoModel class]]) {
                PDOrderChangeInfoModel *infoModel = (PDOrderChangeInfoModel *)model;
                if (infoModel.statusCode.intValue == 0){
                    //可以直接下单 达到起送 包邮门槛"shoppingCartList":[{"productNum":200,"spuCode":"106713","supplyId":"8353","productPrice":56.0, "productName":"ww","frontSellerCode":8353}]
                    [self checkSubmitOrder:count];
                }else if (infoModel.statusCode.intValue == 3){
                    //异常直接toast
                    [self toast:infoModel.message];
                }else{
                    // 埋点
                    NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
                    NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.productModel getPm_price],@"pm_price",[self.productModel getStorageData],@"storage",[self.productModel getPm_pmtn_type],@"pm_pmtn_type",[NSString stringWithFormat:@"%@|%@",self.vendorId,self.productionId],@"pageValue", nil];
                    if (infoModel.statusCode.intValue == 2){
                        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"2" sectionName:@"未满包邮门槛弹窗" itemId:@"I6115" itemPosition:@"0" itemName:@"未达包邮出现弹窗" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
                    }else if (infoModel.statusCode.intValue == 1){
                        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"1" sectionName:@"未满起送金额弹窗" itemId:@"I6115" itemPosition:@"0" itemName:@"未达起送出现弹窗" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
                    }
                    [self.exceptionDetailVC configExceptionDetailViewController:infoModel];
                    self.exceptionDetailVC.addCartAction = ^(){
                        // 加入购物车
                        @strongify(self);
                        if (infoModel.statusCode.intValue == 2){
                            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"2" sectionName:@"未满包邮门槛弹窗" itemId:@"I9999" itemPosition:@"1" itemName:@"加车" itemContent:nil itemTitle:nil extendParams:extentDic viewController:self];
                        }else if (infoModel.statusCode.intValue == 1){
                            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"1" sectionName:@"未满起送金额弹窗" itemId:@"I9999" itemPosition:@"1" itemName:@"加车" itemContent:nil itemTitle:nil extendParams:extentDic viewController:self];
                        }
                        [self addProductIntoCart:count];
                        [self addCartActionAnimation];
                    };
                    self.exceptionDetailVC.submitOrderAction = ^(){
                        // 直接结算
                        @strongify(self);
                        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"2" sectionName:@"未满包邮门槛弹窗" itemId:@"I5000" itemPosition:@"2" itemName:@"立即下单" itemContent:nil itemTitle:nil extendParams:extentDic viewController:self];
                        [self checkSubmitOrder:count];
                    };
                    self.exceptionDetailVC.cancelAction = ^(){
                        // 消失按钮
                        @strongify(self);
                        if (infoModel.statusCode.intValue == 2){
                            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"2" sectionName:@"未满包邮门槛弹窗" itemId:@"I6115" itemPosition:@"1" itemName:@"取消" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
                        }else if (infoModel.statusCode.intValue == 1){
                            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S6101" sectionPosition:@"1" sectionName:@"未满起送金额弹窗" itemId:@"I6115" itemPosition:@"1" itemName:@"取消" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
                        }
                    };
                    
                }
            }
        }
    }];
}
// 结算进入检查订单立即下单
- (void)checkSubmitOrder:(NSInteger)count {
    NSMutableArray *checkArr = [NSMutableArray array];
    NSMutableDictionary *temCheckDic = [NSMutableDictionary new];
    temCheckDic[@"productNum"] = [NSNumber numberWithInteger:count];
    temCheckDic[@"supplyId"] = self.productModel.sellerCode;
    if (self.productModel.recommendModel != nil && self.productModel.recommendModel.enterpriseInfo != nil ){
        temCheckDic[@"frontSellerCode"] = @([self.productModel.recommendModel.enterpriseInfo.enterpriseId intValue]);
    }else{
        temCheckDic[@"frontSellerCode"] = @([self.productModel.sellerCode intValue]);
    }
    temCheckDic[@"productPrice"] = self.productModel.priceInfo.price;
    temCheckDic[@"spuCode"] = self.productModel.spuCode;
    [checkArr addObject:temCheckDic];
    
    
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CheckOrder) setProperty:^(id<FKY_CheckOrder> destinationViewController) {
        destinationViewController.fromWhere = 0;
        destinationViewController.orderProductArray = checkArr;
    }];
}
// 浏览5秒发送浏览记录获得优惠券
-(void)sendStrollInfoForCoupon{
    // 发请求
    if(self.productModel == nil || self.productModel.spuCode == nil || self.productModel.sellerCode == nil){
        return;
    }
    //  @weakify(self);
    [FKYProductionDetailService sendViewInfoForCoupon:self.productModel.spuCode senderId:[NSString stringWithFormat:@"%@",self.productModel.sellerCode] success:^(BOOL mutiplyPage, id data) {
        // 成功
        if (data && [data isKindOfClass:FKYThousandCouponDetailModel.class]) {
            FKYThousandCouponDetailModel *detailModel = data;
            if ([detailModel.successStr isEqualToString:@"1"]) {
                //发券成功
                PDViewSendCouponView *sendCouponView = [[PDViewSendCouponView alloc] init:detailModel];
                [sendCouponView show];
            }
        }
    } falure:^(NSString *reason, id data) {
        // 失败
        //        @strongify(self);
        //        if (reason && reason.length > 0) {
        //           /// [self toast:reason];
        //        }
    }];
}
#pragma mark - Share

- (NSString *)shareImage
{
    return self.productModel.picsInfo.firstObject;
}

- (NSString *)shareTitle
{
    return [NSString stringWithFormat:@"%@ %@", self.productModel.productName, self.productModel.spec];
}

- (NSString *)shareUrl
{
    return [NSString stringWithFormat:@"https://m.yaoex.com/product.html?enterpriseId=%@&productId=%@", self.vendorId, self.productionId];
}

// 微信好友之小程序分享
- (NSString *)sharePathForWechat
{
    return [NSString stringWithFormat:@"subPackages/product/index?enterpriseId=%@&productId=%@", self.vendorId, self.productionId];
}

// 微信好友分享
- (void)WXShare
{
    // 0.普通分享
    //    NSString *url = [self shareUrl];
    //    [FKYShareManage shareToWXWithOpenUrl:url andMessage:[self shareTitle] andImage:[self shareImage]];
    
    // 1.小程序分享
    // 取值
    NSString *title = [self shareTitle];
    NSString *content = @"1药城为你精心推荐";
    NSString *imgUrl = [self shareImage];
    NSString *shareUrl = [self shareUrl];
    NSString *path = [self sharePathForWechat];
    NSString *userName = @"gh_317f53f9f8bb";
    //NSString *imgSmallUrl = [self shareImage];
    
    // 入参
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (title && title.length > 0) {
        [dic setObject:title forKey:@"title"];
    }
    else {
        [dic setObject:@"分享" forKey:@"title"];
    }
    if (content && content.length > 0) {
        [dic setObject:content forKey:@"description"];
    }
    if (imgUrl && imgUrl.length > 0) {
        [dic setObject:imgUrl forKey:@"imgUrl"];
    }
    if (shareUrl && shareUrl.length > 0) {
        [dic setObject:shareUrl forKey:@"webpageUrl"];
    }
    if (path && path.length > 0) {
        [dic setObject:path forKey:@"path"];
    }
    if (userName && userName.length > 0) {
        [dic setObject:userName forKey:@"userName"];
    }
    //    if (imgSmallUrl && imgSmallUrl.length > 0) {
    //        [dic setObject:imgSmallUrl forKey:@"imgSmallUrl"];
    //    }
    [FKYShareManage shareToWechat:dic];
    
    // 埋点
    //[self BI_Record:@"product_yc_share_wechat"];
}

// 微信朋友圈
- (void)WXFriendShare
{
    NSString *url = [self shareUrl];
    [FKYShareManage shareToWXFriendWithOpenUrl:url andMessage:[self shareTitle] andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_share_moments"];
}

// QQ好友分享
- (void)QQShare
{
    NSString *url = [self shareUrl];
    [FKYShareManage shareToQQWithOpenUrl:url andMessage:[self shareTitle] andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_qq"];
}

// QQ空间分享
- (void)QQZoneShare
{
    NSString *url = [self shareUrl];
    [FKYShareManage shareToQQZoneWithOpenUrl:url andMessage:[self shareTitle] andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_qzone"];
}

// SINA分享
- (void)sinaShare
{
    NSString *url = [self shareUrl];
    [FKYShareManage shareToSinaWithOpenUrl:url andMessage:[self shareTitle] andImage:[self shareImage]];
    //[self BI_Record:@"product_yc_weibo"];
}


#pragma mark - 同品推荐

// 创建同品推荐页面
- (PDSameProductRecommendView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[PDSameProductRecommendView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_recommendView];
    }
    return _recommendView;
}

#pragma mark - 加车弹窗/弹出千人千面优惠券

// 创建同品推荐页面
- (FKYAddCarViewController *)addCarView
{
    if (!_addCarView) {
        _addCarView = [[FKYAddCarViewController alloc]init];
        
    }
    //
    [_addCarView setfinishPoint: CGPointMake(self.fky_NavigationBarRightBarButton.frame.origin.x + self.fky_NavigationBarRightBarButton.frame.size.width/2.0, self.fky_NavigationBarRightBarButton.frame.origin.y+self.fky_NavigationBarRightBarButton.frame.size.height/2.0)];
    //更改购物车数量
    @weakify(self);
    _addCarView.immediatelyOrderAddCarSuccess = ^(BOOL isSuccess,NSInteger productNum,id productModel){
        @strongify(self);
        if (isSuccess){
            if ([productModel isKindOfClass:[FKYProductObject class]]) {
                FKYProductObject *desModel = (FKYProductObject *)productModel;
                [self checkProductForImmediatelyOrder:productNum model:desModel];
            }
            
        }
    };
    _addCarView.addCarSuccess = ^(BOOL isSuccess,NSInteger type,NSInteger productNum,id productModel){
        @strongify(self);
        if (isSuccess){
            if (type == 1){
                self.isAddAnimate = NO;
                [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
                    @strongify(self);
                    self.productModel.carId = [NSNumber numberWithInteger:0];
                    self.productModel.carOfCount = [NSNumber numberWithInteger:0];
                    
                    [self syncCartCount];
                    
                    if (self.updateCarNum) {
                        self.updateCarNum(self.productModel.carId, self.productModel.carOfCount);
                    }
                    [self dismissLoading];
                } failure:^(NSString *reason) {
                    @strongify(self);
                    //@strongify(_bottomView);
                    [self dismissLoading];
                    [self toast:reason];
                    [self.bottomView resetStepperNum];
                }];
            }else {
                self.isAddAnimate = YES;
                [[FKYVersionCheckService shareInstance] syncCartNumberSuccess:^(BOOL mutiplyPage) {
                    //
                    @strongify(self);
                    for (FKYCartOfInfoModel *cartModel in [FKYCartModel shareInstance].productArr) {
                        if (cartModel.supplyId != nil && [cartModel.spuCode isEqualToString:self.productModel.spuCode] && cartModel.supplyId.integerValue == self.productModel.sellerCode.integerValue){
                            self.productModel.carId = cartModel.cartId;
                            self.productModel.carOfCount = cartModel.buyNum;
                            break;
                        }
                    }
                    if (self.updateCarNum) {
                        self.updateCarNum(self.productModel.carId, self.productModel.carOfCount);
                    }
                    //修正客户组有最小起批数量的问题
                    [self.bottomView configView:self.productModel showBtn:self.showContact];
                    [self dismissLoading];
                } failure:^(NSString *reason) {
                    @strongify(self);
                    //@strongify(bottomView);
                    [self dismissLoading];
                    [self toast:reason];
                    [self.bottomView resetStepperNum];
                }];
            }
            [self addCartActionAnimation];
        }else{
            
        }
    };
    _addCarView.clickAddCarBtn = ^(id productModelItem){
        @strongify(self);
        NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.productModel getPm_price],@"pm_price",[self.productModel getStorageData],@"storage",[self.productModel getPm_pmtn_type],@"pm_pmtn_type",[NSString stringWithFormat:@"%@|%@",self.vendorId,self.productionId],@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9999" itemPosition:@"0" itemName:@"加车" itemContent:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode) itemTitle:nil extendParams:extentDic  viewController:self];
    };
    return _addCarView;
}
// 弹出千人千面优惠券
- (void)popAlertThousandCouponsVC:(id)aResponseObject
{
    NSArray *needArr = aResponseObject[@"supplyCartList"];
    if (needArr.count > 0) {
        //请求千人千面优惠券
        NSMutableArray *desArr = [NSMutableArray array];
        for (NSDictionary *dic in needArr) {
            NSMutableDictionary *mutDic = [NSMutableDictionary new];
            mutDic[@"supplyId"] = [dic objectForKey:@"supplyId"];
            mutDic[@"totalAmount"] = [dic objectForKey:@"totalAmount"];
            [desArr addObject:mutDic];
        }
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"couponParamList"] = desArr.gl_JSONString;
        @weakify(self);
        [FKYRequestService.sharedInstance requestForThousandCouponsInCartWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
            @strongify(self);
            if (error == nil) {
                if ([model isKindOfClass:[FKYThousandCouponDetailModel class]]) {
                    FKYThousandCouponDetailModel *desModel = (FKYThousandCouponDetailModel *)model;
                    if ([desModel.successStr isEqualToString:@"1"]){
                        ////弹出千人千面框
                        FKYThousandRedPacketView *thousandPacketView = [[FKYThousandRedPacketView alloc] init:desModel];
                        [thousandPacketView show];
                    }
                }
            }
        }];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        if (scrollView.contentOffset.x == 0) {
            self.segmentControl.selectedSegmentIndex = 0;
        }
        if (scrollView.contentOffset.x == SCREEN_WIDTH) {
            self.segmentControl.selectedSegmentIndex = 1;
        }
    }
}


#pragma mark - FKYArrivalNoticeSheetViewDelegate

- (void)submitNoticClick
{
    
}


#pragma mark - FKYNavigationControllerDragBackDelegate

- (BOOL)dragBackShouldStartInNavigationController:(FKYNavigationController *)navigationController
{
    return NO;
}


#pragma mark - __BI__ (FKYAnaliticsParamaterProtocol)

- (NSDictionary<NSString *,id> *)ViewControllerParamaters
{
    return @{@"productId":self.productionId,@"enterpriseId":self.vendorId};
}


#pragma mark - Property
////商品异常弹框
- (PDPopExceptionDetailVC *)exceptionDetailVC
{
    if (!_exceptionDetailVC) {
        _exceptionDetailVC = [[PDPopExceptionDetailVC alloc] init];
    }
    return _exceptionDetailVC;
    
}

//   fileprivate lazy var exceptionDetailVC : FKYPopExceptionDetailVC = {
//       let vc = FKYPopExceptionDetailVC()
//       vc.clickFuntionBtn = { [weak self] (indexSection ,typeIndex) in
//           guard let strongSelf = self else {
//               return
//           }
//           if indexSection == -4 {
//               //直接结算
//               strongSelf.submitPartMerchanetOrder()
//           }else if indexSection >= 0 , indexSection < strongSelf.tableView.numberOfSections {
//               strongSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: indexSection), at: .top, animated: false)
//               let deadline = DispatchTime.now() + 0.5 //刷新数据的时候有延迟，所以推后1S刷新
//               DispatchQueue.global().asyncAfter(deadline: deadline) {
//                   DispatchQueue.main.async { [weak self] in
//                       if let strongSelf = self {
//                           strongSelf.tableView.scrollToRow(at: IndexPath.init(row: 0, section: indexSection), at: .top, animated: false)
//                       }
//                   }
//               }
//               if typeIndex == 3 {
//                   //商品信息变化弹框才刷新
//                   strongSelf.requestForCartData()
//               }
//           }
//       }
//       return vc
//   }()
- (PDComboVC *)comboVC
{
    if (!_comboVC) {
        _comboVC = [[PDComboVC alloc] init];
        _comboVC.viewPd = self.view;
        if (self.productModel && self.productModel.dinnerInfo && self.productModel.dinnerInfo.dinnerList) {
            _comboVC.arrayGroup = self.productModel.dinnerInfo.dinnerList;
        }
        _comboVC.spucode = self.productModel.spuCode;
        _comboVC.supplyID = [NSString stringWithFormat:@"%@",self.productModel.sellerCode];
        @weakify(self);
        // 查看套餐子品的商详
        _comboVC.showProductDetailCallback = ^(FKYProductGroupItemModel * product, NSInteger indexRow, NSInteger groupIndex,NSString *groupName,NSInteger maxBuyNum) {
            @strongify(self);
            if (product
                && product.supplyId && product.supplyId.integerValue > 0
                && product.spuCode && product.spuCode.length > 0) {
                NSString *productId = product.spuCode;
                NSString *enterpriseId = [NSString stringWithFormat:@"%ld", (long)product.supplyId.integerValue];
                
                NSString *priceStr = @"";
                if (product.getProductRealPrice > 0){
                    priceStr = [NSString stringWithFormat:@"%.2f|",product.getProductRealPrice];
                }
                if (product.originalPrice.floatValue > 0){
                    priceStr = [NSString stringWithFormat:@"%@%.2f",priceStr,product.originalPrice.floatValue];
                }
                NSString *storageStr = @"";
                if (maxBuyNum > 0){
                    storageStr = [NSString stringWithFormat:@"%ld|",maxBuyNum*product.doorsill.intValue];
                }
                if (self.productModel.stockCount.intValue >0){
                    storageStr = [NSString stringWithFormat:@"%@%d",storageStr,product.currentBuyNum.intValue];
                }
                //点击套餐商品埋点
                NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:priceStr,@"pm_price",storageStr,@"storage",@"套餐",@"pm_pmtn_type",[NSString stringWithFormat:@"%@|%@",enterpriseId,self.productModel.spuCode],@"pageValue", nil];
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"套餐详情弹窗" sectionId:@"S6108" sectionPosition:[NSString stringWithFormat:@"%ld",groupIndex+1] sectionName:groupName itemId:@"I6108" itemPosition:[NSString stringWithFormat:@"%ld",indexRow+1] itemName:@"点进商详" itemContent:[NSString stringWithFormat:@"%@|%@",enterpriseId,productId] itemTitle:nil extendParams:extentDic viewController:self];
                
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
                    destinationViewController.productionId = productId; // 商品id
                    destinationViewController.vendorId = enterpriseId;  // 供应商id
                }];
            }
            else {
                [self toast:@"无法查看"];
            }
        };
        // 套餐加车
        _comboVC.addGroupCallback = ^(FKYProductGroupModel *group, NSInteger index){
            @strongify(self);
            
            if ([FKYLoginService loginStatus] == FKYLoginStatusUnlogin) {
                [self toast:@"请先登录"];
                return;
            }
            
            if (group) {
                // 判断是否可以提交
                BOOL canSubmit = NO;
                for (FKYProductGroupItemModel *product in group.productList) {
                    if (product.unselected == NO) {
                        canSubmit = YES;
                        break;
                    }
                }
                NSString *itemCotent = @"";
                for (FKYProductGroupItemModel *item in group.productList) {
                    if (item.unselected == false ){
                        if (itemCotent.length == 0) {
                            itemCotent = [NSString stringWithFormat:@"%@|%@",item.supplyId,item.spuCode];
                        }else {
                            itemCotent = [itemCotent stringByAppendingString:[NSString stringWithFormat:@",%@|%@",item.supplyId,item.spuCode]];
                        }
                    }
                }
                // 加车
                if (group.promotionRule && group.promotionRule.integerValue == 2) {
                    // 固定套餐加车
                    if (!canSubmit) {
                        [self toast:@"套餐内的商品数需大于1"];
                        return;
                    }
                    NSDictionary *extendParams = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
                    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"套餐详情弹窗" sectionId:@"S6108" sectionPosition:[NSString stringWithFormat:@"%ld",(index + 1)] sectionName:group.promotionName itemId:@"I9999" itemPosition:@"0" itemName:@"套餐加车" itemContent:itemCotent itemTitle:nil extendParams:extendParams viewController:self];
                    [self addCartForFixedCombo:group withIndex:index];
                }
                else {
                    // 搭配套餐加车
                    if (!canSubmit) {
                        [self toast:@"请先选择商品"];
                        return;
                    }
                    NSDictionary *extendParams = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
                    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"套餐详情弹窗" sectionId:@"S6108" sectionPosition:[NSString stringWithFormat:@"%ld",(index + 1)] sectionName:group.promotionName itemId:@"I9999" itemPosition:@"0" itemName:@"套餐加车" itemContent:itemCotent itemTitle:nil extendParams:extendParams viewController:self];
                    [self addCartForCombinedCombo:group];
                }
            }
            else {
                [self toast:@"加入购物车失败"];
            }
        };
    }
    return _comboVC;
}

- (PDFixedComboFailVC *)fixedComboFailVC
{
    if (!_fixedComboFailVC) {
        _fixedComboFailVC = [[PDFixedComboFailVC alloc] init];
        _fixedComboFailVC.viewPd = self.view;
        @weakify(self);
        // 立即刷新商详
        _fixedComboFailVC.refreshProductDetailCallback = ^(){
            @strongify(self);
            [self.baseInfoController resetProductTableOffset];
            [self requestData];
        };
        // 再次弹出固定套餐加车视图
        _fixedComboFailVC.reshowAddCartViewCallback = ^(NSInteger maxCount, NSInteger comboIndex){
            @strongify(self);
            [self showFixedComboViewForLimitBuy:maxCount comboIndex:comboIndex];
        };
    }
    return _fixedComboFailVC;
}

- (FKYCartService *)cartService
{
    if (!_cartService) {
        _cartService = [[FKYCartService alloc] init];
        _cartService.editing = false;
    }
    return _cartService;
}

- (FKYProductionDetailService *)detailService
{
    if (!_detailService) {
        _detailService = [[FKYProductionDetailService alloc] init];
    }
    return _detailService;
}

- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        @weakify(self);
        //
        _shareView.WeChatShareClourse = ^(){
            @strongify(self);
            NSLog(@"微信好友分享");
            [self WXShare];
        };
        //
        _shareView.WeChatFriendShareClourse = ^(){
            @strongify(self);
            NSLog(@"微信朋友圈分享");
            [self WXFriendShare];
        };
        //
        _shareView.QQZoneShareClourse = ^(){
            @strongify(self);
            NSLog(@"QQ空间分享");
            [self QQZoneShare];
        };
        //
        _shareView.QQShareClourse = ^(){
            @strongify(self);
            NSLog(@"QQ好友分享");
            [self QQShare];
        };
        //
        _shareView.SinaShareClourse = ^(){
            @strongify(self);
            NSLog(@"SINA分享");
            [self sinaShare];
        };
    }
    return _shareView;
}

- (UIView *)viewPop
{
    if (!_viewPop) {
        _viewPop = [[PDTipsView alloc] initWithFrame:CGRectZero];
        _viewPop.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateBusinessScope)];
        [_viewPop addGestureRecognizer:tap];
    }
    return _viewPop;
}


#pragma mark - 动画 
-(void)addCartActionAnimation{
    CGFloat bottomMargin = 0;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomMargin = iPhoneX_SafeArea_BottomInset;
        }
    }
    if (self.productModel.picsInfo != nil && self.productModel.picsInfo.count > 0){
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, [self getTopHeight], SCREEN_WIDTH, FKYWH(220))];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = FKYWH(0);
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.productModel.picsInfo[0]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
        [self.view addSubview:imageView];
        @weakify(self);
        [UIView animateWithDuration:0.5 animations:^{
            @strongify(self);
            imageView.frame = CGRectMake(SCREEN_WIDTH/2.0 - FKYWH(25), [self getTopHeight] + FKYWH(110)- FKYWH(25), FKYWH(50), FKYWH(50));
            imageView.layer.cornerRadius = FKYWH(25);
        } completion:^(BOOL finished){
            @strongify(self);
            [imageView removeFromSuperview];
            if (self.showContact == YES){
                [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageView rect:CGRectMake(SCREEN_WIDTH/2.0 - FKYWH(25), FKYWH(110)- FKYWH(25), FKYWH(50), FKYWH(50)) finisnPoint:CGPointMake(FKYWH(145 - 45/2.0), SCREEN_HEIGHT - bottomMargin - FKYWH(52) ) finishBlock:^(BOOL finished){
                    @strongify(self);
                    [PurchaseCarAnimationTool shakeAnimation:self.bottomView.cartBtn.contactIconImage];
                    [imageView removeFromSuperview];
                }];
            }else{
                [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageView rect:CGRectMake(SCREEN_WIDTH/2.0 - FKYWH(25), FKYWH(110)- FKYWH(25), FKYWH(50), FKYWH(50)) finisnPoint:CGPointMake(FKYWH(100 - 45/2.0), SCREEN_HEIGHT - bottomMargin - FKYWH(52) ) finishBlock:^(BOOL finished){
                    @strongify(self);
                    [PurchaseCarAnimationTool shakeAnimation:self.bottomView.cartBtn.contactIconImage];
                    [imageView removeFromSuperview];
                }];
            }
        }];
        
    }
}
// 获取顶部导航栏总高度
- (CGFloat)getTopHeight
{
    CGFloat navigationBarHeight = 64;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
        }
    }
    return navigationBarHeight;
}
@end
