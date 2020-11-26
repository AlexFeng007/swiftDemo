//
//  FKYSearchViewController.m
//  FKY
//
//  Created by yangyouyong on 15/9/9.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYSearchViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+ToastOrLoading.h"
#import "FKYSearchBar.h"
#import "FKYNavigator.h"
#import "FKYSearchHistoryCell.h"
#import "FKYSearchRemindCell.h"
#import "FKYSearchService.h"
#import "FKYSearchRemindModel.h"
#import "FKYSearchHistoryModel.h"
#import "FKY-Swift.h"
#import "IQKeyboardManager.h"
#import "FKYInputVideoView.h"
#import "FKYSearchRequest.h"
#import "FKYSearchActivityModel.h"
#import "FKYVoiceSearchView.h"

static NSString *const searchHistoryCellIndentifier = @"FKYSearchHistoryCell";
static NSString *const searchRemindCellIndentifier = @"FKYSearchRemindCell";

static NSString *const searchItemId1 = @"I8000";
static NSString *const searchItemId2 = @"I8001";
static NSString *const searchItemId3 = @"I8002";//搜索发现
static NSString *const searchItemId4 = @"I8003";//最近搜索
static NSString *const searchItemId5 = @"I8004";//搜索联想词

@interface FKYSearchViewController ()<
FKYSearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIAlertViewDelegate,
FKYSearchBarAlertViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) FKYSearchBar *searchBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UICollectionView *searchHistoryView;
@property (nonatomic, strong) UITableView *searchRemindView;
@property (nonatomic, strong) FKYSearchService *service;
@property (nonatomic, strong) FKYSearchBarAlertView *alertView;
@property (nonatomic, strong) FKYInputVideoView *inputVoiceView;
@property (nonatomic, assign) BOOL alertViewIsAppear;

@property (nonatomic, strong) NSArray *recommendShops;
@property (nonatomic, strong) NSArray *recommendProducts;

@property (nonatomic, strong) FKYSearchSwitchTypeView *searchSwitchTypeView;

@property (nonatomic, strong) FKYVoiceSearchView *voiceSearchView;

/// 折叠状态下历史搜索词的数据源
@property (nonatomic, strong) NSMutableArray *foldHistoryList;

/// 非折叠状态下的历史搜索词
@property (nonatomic, strong) NSMutableArray *HistoryList;

/// 是否折叠 进入界面默认折叠
@property (nonatomic, assign)BOOL isFold;

/// 是否超过了两行
@property (nonatomic,assign)BOOL isOverTwoLine;



@end


@implementation FKYSearchViewController

#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    [self setupView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFold = false;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.alertViewIsAppear = NO;
    
    // 如果是搜索店铺并且通用样式
    if (self.searchType == SearchTypeShop && self.vcSourceType == SourceTypeCommon) {
        [self.alertView selectedIndex:1];
        if (self.fromePage>= 1 && self.fromePage <= 3){// 新的搜索样式
            [self.searchSwitchTypeView switchSearchTypeWithIndex:1];
        }
    }
    //默认选择搜索普通商品
    if (self.searchType == 0){
        self.searchType = SearchTypeProdcut;
        [self.searchSwitchTypeView switchSearchTypeWithIndex:1];
    }
    
    // 获取搜索活动
    if (self.searchType == SearchTypeOrder || self.searchType == SearchTypeTogeterProduct|| self.searchType == SearchTypeJBPShop || self.searchType == SearchTypeYFLShop || self.searchType == SearchTypeCoupon || (self.searchType == SearchTypeProdcut && self.shopID.length > 0) || self.searchType == SearchTypePackageRate){
        return;
    }
    [self getSearchActivityData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 监控键盘
    NDC_ADD_SELF_NOBJ(@selector(keyboardWillShowAction:), UIKeyboardWillShowNotification);
    NDC_ADD_SELF_NOBJ(@selector(keyboardWillHideAction:), UIKeyboardWillHideNotification);
    NDC_ADD_SELF_NOBJ(@selector(keyboardDidHide:), UIKeyboardDidHideNotification);
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    // 开始实地联想搜索
    if (self.searchBar) {
        [self.searchBar.inputTextField becomeFirstResponder];
        [self getSearchAssociativeWord:self.searchBar.text];
    }
    [self.searchSwitchTypeView.scanView setCorner];
    // 获取本地保存的搜索历史
    [self p_fetchedSearchHistory];
    [self installFoldHistoryList];
    
    [self switchHistoryListWithType:@"flodItem_down"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NDC_REMOVE_SELF_ALL;
    
    [self.view endEditing:YES];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Keyboard

- (void)keyboardWillShowAction:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self.view bringSubviewToFront:self.voiceSearchView];
    @weakify(self);
    [UIView animateWithDuration:[duration floatValue] animations:^{
        @strongify(self);
        self.voiceSearchView.frame = CGRectMake((SCREEN_WIDTH - FKYWH(57))/2,  SCREEN_HEIGHT-keyboardRect.size.height-FKYWH(57), FKYWH(57), FKYWH(57));
        [self.view layoutIfNeeded];
    }];
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    @weakify(self);
    [UIView animateWithDuration:[duration floatValue] animations:^{
        @strongify(self);
        self.voiceSearchView.frame = CGRectMake((SCREEN_WIDTH - FKYWH(57))/2,  SCREEN_HEIGHT, FKYWH(57), FKYWH(57));
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHideAction:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    @weakify(self);
    [UIView animateWithDuration:[duration floatValue] animations:^{
        @strongify(self);
        self.voiceSearchView.frame = CGRectMake((SCREEN_WIDTH - FKYWH(57))/2,  SCREEN_HEIGHT, FKYWH(57), FKYWH(57));
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Private

- (void)setupView
{
    [self fky_setupNavigationBar];
    self.navBar = [self fky_NavigationBar];
    self.navBar.backgroundColor = [UIColor whiteColor];
    
    if (self.fromePage>= 1 && self.fromePage <= 3){// 新的搜索样式
        [self.navBar addSubview:self.searchSwitchTypeView];
    }
    [self createBackBtn];
    [self createSearchBar];
    if (self.fromePage< 1 || self.fromePage > 3){// 老的搜索样式
        [self createSearchBtn];
    }
    if (self.fromePage>= 1 && self.fromePage <= 3){// 新的搜索样式
        [self.searchBar newUIStyleLayout];
        CGFloat naviHeight = FKYWH(110);
        if (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXS_MAX){
            naviHeight += FKYWH(24);
        }
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(naviHeight);
        }];
        
        [self creatSwitchView];
    }
    
    [self createAlertView];
    [self createSeparatorLine];
    [self createSearchRemindView];
    [self createSearchHistoryView];
    [self creatInputVoiceView];
}

-(void)creatSwitchView{
    
    [self.searchSwitchTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.navBar);
        make.bottom.equalTo(self.searchBar.mas_top).offset(FKYWH(-10));
        make.height.mas_equalTo(FKYWH(42));
    }];
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar).offset(FKYWH(10));
        make.height.width.equalTo(@(FKYWH(30)));
        //make.centerY.equalTo(self.searchSwitchTypeView);
        make.bottom.equalTo(@(FKYWH(-7)));
    }];
    if (self.fromePage>= 1 && self.fromePage <= 3){// 新的搜索样式
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navBar).offset(FKYWH(10));
            make.height.width.equalTo(@(FKYWH(30)));
            make.centerY.equalTo(self.searchSwitchTypeView);
            //make.bottom.equalTo(@(FKYWH(-7)));
        }];
    }
    [btn setImage:[UIImage imageNamed:@"icon_back_new_red_normal"] forState:UIControlStateNormal];
    @weakify(self);
    [btn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[FKYNavigator sharedNavigator] pop];
        if (self.searchType == SearchTypeOrder) {
            //订单搜索埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I9210" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if (self.searchType == SearchTypeTogeterProduct){
            //一起购搜索页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7820" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if (self.searchType == SearchTypePackageRate){
            //单品包邮
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:nil sectionName:@"头部" itemId:@"I7120" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else {
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"0" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = btn;
}

// 创建搜索栏
- (void)createSearchBar
{
    FKYSearchBar *search = nil;
    switch (self.vcSourceType) {
        case SourceTypePilot:
            // 只针对商品
            search = [[FKYSearchBar alloc] initWithLeftIconType:LeftIconStyle_SearchIcon];
            [self.searchSwitchTypeView layoutOnlySearchProduct];
            break;
        case SourceTypeOrder:
            search = [[FKYSearchBar alloc] initWithLeftIconType:LeftIconStyle_SearchIconNone];
            break;
        case SourceTypeCoupon:
            search = [[FKYSearchBar alloc] initWithLeftIconType:LeftIconStyle_SearchIcon];
            [self.searchSwitchTypeView layoutOnlySearchProduct];
            break;
        case SourceTypeCommon:
        default:
            // 可切换商品/店铺
            search = [[FKYSearchBar alloc] initWithLeftIconType:LeftIconStyle_TypeList];
            [self.searchSwitchTypeView layoutBothSearch];
            break;
    }
    search.delegate = self;
    [self.navBar addSubview:search];
    
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(FKYWH(10));
        make.right.equalTo(self.navBar.mas_right).offset(-FKYWH(60));
        make.bottom.equalTo(@(FKYWH(-7)));
        make.height.equalTo(@(FKYWH(34)));
    }];
    if (self.fromePage>= 1 && self.fromePage <= 3){// 新的搜索样式
        [search mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navBar).offset(FKYWH(15));
            make.right.equalTo(self.navBar.mas_right).offset(-FKYWH(12));
            make.bottom.equalTo(@(FKYWH(-7)));
            make.height.equalTo(@(FKYWH(34)));
        }];
    }
    search.placeholder = @"药品名/助记码/厂家";
    if (self.searchType == SearchTypeProdcut && self.shopID && self.shopID.length > 0) {
        // 一定为SourceTypePilot样式
        search.placeholder = @"搜索此商家的商品";
    }
    if (self.searchType == SearchTypeTogeterProduct){
        search.placeholder = @"请输入1起购商品";
    }
    if (self.searchType == SearchTypeOrder){
        search.placeholder = @"搜索商品名称/订单号/供应商";
    }
    if (self.searchType == SearchTypeJBPShop){
        search.placeholder = @"搜索专区内的商品";
    }
    if (self.searchType == SearchTypeYFLShop){
        search.placeholder = @"搜索专区内的商品";
    }
    if (self.searchType == SearchTypeCoupon){
        search.placeholder = @"搜索可用该券商品";
    }
    if (self.searchType == SearchTypePackageRate){
        search.placeholder = @"请输入商品名称";
    }
    
    // 切换...<商品/店铺>
    @weakify(self);
    search.selectedSearchType = ^(){
        @strongify(self);
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"1" itemName:@"切换商品/店铺" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        
        if (self.alertViewIsAppear) {
            safeBlock(self.alertView.alertViewDismiss);
        }else{
            safeBlock(self.alertView.alertViewAppear);
        }
        self.alertViewIsAppear = !self.alertViewIsAppear;
    };
    
    search.inputVoiceAction = ^{
        @strongify(self);
        [self checkMirAuthorizationStatus];
    };
    self.searchBar = search;
}

//创建右边搜索按钮
- (void)createSearchBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navBar).offset(FKYWH(-10));
        make.left.equalTo(self.searchBar.mas_right).offset(FKYWH(10));
        make.height.equalTo(@(FKYWH(30)));
        make.centerY.equalTo(self.searchBar.mas_centerY);
    }];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = FKYSystemFont(FKYWH(16));
    @weakify(self);
    [btn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self.searchBar.inputTextField resignFirstResponder];
        [self searchBarSearchButtonClicked:self.searchBar];
    } forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn = btn;
}

- (void)creatInputVoiceView
{
    FKYInputVideoView *inputVoiceView = [[FKYInputVideoView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.inputVoiceView = inputVoiceView;
    @weakify(self);
    
    inputVoiceView.resultHandler = ^(NSString *resultStr) {
        @strongify(self);
        //埋点
        if (self.searchType == SearchTypeOrder) {
            //订单搜索埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9212" itemPosition:@"2" itemName:@"点击声纹进行搜索/自动识别搜索" itemContent:nil itemTitle:nil extendParams:@{@"keyword":resultStr} viewController:self];
        }else if (self.searchType == SearchTypeTogeterProduct){
            //一起购搜索页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7122" itemPosition:@"2" itemName:@"点击声纹进行搜索/自动识别搜索" itemContent:nil itemTitle:nil extendParams:@{@"keyword":resultStr} viewController:self];
        }else {
            //埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"语音搜索" itemId:searchItemId2 itemPosition:@"2" itemName:@"点击声纹进行搜索/自动识别搜索" itemContent:[self getSellerCode] itemTitle:nil extendParams:@{@"keyword":resultStr} viewController:self];
        }
        self.searchBar.inputTextField.text = resultStr;
        [self getSearchAssociativeWord:self.searchBar.text];
        [self.searchBar.inputTextField resignFirstResponder];
        [self searchBarSearchButtonClicked:self.searchBar];
    };
    
    inputVoiceView.closeBtnClicked = ^{
        @strongify(self);
        //埋点
        if (self.searchType == SearchTypeOrder) {
            //订单搜索埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9212" itemPosition:@"1" itemName:@"取消" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if (self.searchType == SearchTypeTogeterProduct){
            //一起购搜索页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7122" itemPosition:@"1" itemName:@"取消" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else {
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"语音搜索" itemId:searchItemId2 itemPosition:@"1" itemName:@"取消" itemContent:[self getSellerCode] itemTitle:nil extendParams:nil viewController:self];
        }
    };
    inputVoiceView.resetSpeechAgainBtn = ^{
        @strongify(self);
        //埋点
        if (self.searchType == SearchTypeTogeterProduct){
            //一起购搜索页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7122" itemPosition:@"0" itemName:@"语音搜索按钮/未识别时的语音搜索按钮" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else {
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"语音搜索" itemId:searchItemId2 itemPosition:@"0" itemName:@"语音搜索按钮/未识别时的语音搜索按钮" itemContent:[self getSellerCode] itemTitle:nil extendParams:nil viewController:self];
        }
    };
    
    inputVoiceView.voiceIsOver = ^{
        @strongify(self);
    };
    
    [self.view addSubview:self.voiceSearchView];
}

- (void)showInputVoiceView
{
    self.searchBar.inputTextField.text = @"";
    [self.searchBar.inputTextField resignFirstResponder];
    [self.inputVoiceView showToVC:self];
}


- (void)createAlertView
{
    FKYSearchBarAlertView *view = [[FKYSearchBarAlertView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.searchBar.mas_left);
        make.width.equalTo(@(FKYWH(80)));
        make.height.equalTo(@(FKYWH(85)));
    }];
    view.delegate = self;
    view.alpha = 0;
    self.alertView = view;
    @weakify(self);
    view.alertViewAppear = ^(){
        @strongify(self);
        [self.view bringSubviewToFront:self.alertView];
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self);
            self.alertView.alpha = 1;
        }];
    };
    view.alertViewDismiss = ^(){
        @strongify(self);
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self);
            self.alertView .alpha = 0;
        }];
    };
}

- (void)createSeparatorLine
{
    UIView *view = [UIView new];
    [self.navBar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.navBar);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    view.backgroundColor = UIColorFromRGB(0xe6e6e6);
    self.separatorLine = view;
}

// 搜索结果tableview
- (void)createSearchRemindView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    [tableView registerClass:[FKYSearchRemindCell class] forCellReuseIdentifier:searchRemindCellIndentifier];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    self.searchRemindView = tableView;
}

#pragma mark - 搜索历史collectionview
- (void)createSearchHistoryView
{
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.alwaysBounceVertical = YES;
    collection.backgroundColor = UIColorFromRGB(0xffffff);
    [collection registerClass:[FKYSearchHistoryCell class] forCellWithReuseIdentifier:@"FKYSearchHistoryCell"];
    [collection registerClass:[FKYSearchCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FKYSearchCollectionViewHeader"];
    [collection registerClass:[FKYSearchCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FKYSearchCollectionViewFooter"];
    [collection registerClass:[FKYSearchContentHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FKYSearchContentHeader"];
    [collection registerClass:[FKYSearchActivityCell class] forCellWithReuseIdentifier:@"FKYSearchActivityCell"];
    [self.view addSubview:collection];
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    self.searchHistoryView = collection;
}

#pragma mark - 事件响应
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:FKYSearchBar.searchAction]){// 点击搜索按钮
        [self.searchBar.inputTextField resignFirstResponder];
        [self searchBarSearchButtonClicked:self.searchBar];
    }else if ([eventName isEqualToString:FKYSearchSwitchTypeView.switchSearchType]){// 切换搜索类型
        int switchIndex = [userInfo[FKYUserParameterKey] intValue];
        if (switchIndex == 1){// 切换到搜商品选项
            
        }else if (switchIndex == 2){// 切换到搜店铺选项
            
        }
        [self switchSearchType:switchIndex];
        [self.searchSwitchTypeView switchSearchTypeWithIndex:switchIndex];
    }else if ([eventName isEqualToString:FKYSearchScanView.gotoSacnView]){// 扫码事件
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ScanVC)];
    }
}

#pragma mark - 获取搜索活动
- (void)getSearchActivityData
{
    @weakify(self);
    [self.service getSearchActivityDataSuccess:^(BOOL mutiplyPage) {
        @strongify(self);
        // 搜索成功
        [self.searchHistoryView reloadData];
    } failure:^(NSString *reason) {
        
    }];
}

#pragma mark - 获取搜索联想词
- (void)getSearchAssociativeWord:(NSString *)searchText
{
    // 搜店铺和一起购活动时无实时联想搜索功能
    if (self.searchType == SearchTypeShop || self.searchType == SearchTypeTogeterProduct|| self.searchType == SearchTypeOrder || self.searchType == SearchTypePackageRate) {
        return;
    }
    // 实时联想搜索(测试环境编码不一致)
    if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
        //
    }else {
        searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    // 先全部隐藏
    self.searchRemindView.hidden = YES;
    self.searchHistoryView.hidden = YES;
    @weakify(self);
    switch (self.vcSourceType) {
        case SourceTypePilot:
        {
            // 店铺内的商品搜索
            if (self.shopID && self.shopID.length > 0) {
                // 店铺内商品搜索
                if (searchText && searchText.length > 0) {
                    // 不为空...<实时联想搜索>
                    [self.service searchRemindForStoreByKeyword:searchText storeID:self.shopID success:^(BOOL mutiplyPage) {
                        @strongify(self);
                        // 搜索成功
                        [self.searchRemindView reloadData];
                        // 搜索结果处理逻辑
                        if (self.searchBar.text && self.searchBar.text.length > 0) {
                            self.searchHistoryView.hidden = YES;
                            self.searchRemindView.hidden = NO;
                            [self.view bringSubviewToFront: self.searchRemindView];
                            [self.view bringSubviewToFront:self.voiceSearchView];
                        }
                        else {
                            // 当前搜索框中关键词已被清空
                            [self.service emptySearchRemindArray];
                            [self.searchRemindView reloadData];
                            self.searchRemindView.hidden = YES;
                            self.searchHistoryView.hidden = NO;
                            [self.view bringSubviewToFront: self.searchHistoryView];
                            [self.view bringSubviewToFront:self.voiceSearchView];
                        }
                    } failure:^(NSString *reason) {
                        @strongify(self);
                        // 搜索失败...<隐藏实时搜索结果view，显示搜索历史view>
                        self.searchRemindView.hidden = YES;
                        self.searchHistoryView.hidden = NO;
                        [self.view bringSubviewToFront: self.searchHistoryView];
                        [self.view bringSubviewToFront:self.voiceSearchView];
                    }];
                }
                else {
                    // 为空...<隐藏实时搜索结果view，显示搜索历史view>
                    [self.service emptySearchRemindArray];
                    [self.searchRemindView reloadData];
                    self.searchRemindView.hidden = YES;
                    self.searchHistoryView.hidden = NO;
                    [self.view bringSubviewToFront: self.searchHistoryView];
                    [self.view bringSubviewToFront:self.voiceSearchView];
                }
            }
            
            // 显示历史搜索视图
            self.searchHistoryView.hidden = NO;
            [self.view bringSubviewToFront: self.searchHistoryView];
            [self.view bringSubviewToFront:self.voiceSearchView];
            break;
        }
        case SourceTypeCommon:
        default:
        {
            /*
             说明:
             下面的实时联想搜索方法必然会有一定的延迟，从而可能导致搜索到结果列表后，用户已经将关键词清空，导致搜索结果view与搜索历史view同时显示
             */
            
            // 通用搜索...<可切换商品/店铺>
            if (searchText && searchText.length > 0) {
                // 不为空...<实时联想搜索>
                [self.service searchRemindForKeyword:searchText success:^(BOOL mutiplyPage) {
                    @strongify(self);
                    // 搜索成功
                    [self.searchRemindView reloadData];
                    // 搜索结果处理逻辑
                    if (self.searchBar.text && self.searchBar.text.length > 0) {
                        self.searchHistoryView.hidden = YES;
                        self.searchRemindView.hidden = NO;
                        [self.view bringSubviewToFront: self.searchRemindView];
                        [self.view bringSubviewToFront:self.voiceSearchView];
                    }
                    else {
                        // 当前搜索框中关键词已被清空
                        [self.service emptySearchRemindArray];
                        [self.searchRemindView reloadData];
                        self.searchRemindView.hidden = YES;
                        self.searchHistoryView.hidden = NO;
                        [self.view bringSubviewToFront: self.searchHistoryView];
                        [self.view bringSubviewToFront:self.voiceSearchView];
                    }
                } failure:^(NSString *reason) {
                    @strongify(self);
                    // 搜索失败...<隐藏实时搜索结果view，显示搜索历史view>
                    self.searchRemindView.hidden = YES;
                    self.searchHistoryView.hidden = NO;
                    [self.view bringSubviewToFront: self.searchHistoryView];
                    [self.view bringSubviewToFront:self.voiceSearchView];
                }];
            }
            else {
                // 为空...<隐藏实时搜索结果view，显示搜索历史view>
                [self.service emptySearchRemindArray];
                [self.searchRemindView reloadData];
                self.searchRemindView.hidden = YES;
                self.searchHistoryView.hidden = NO;
                [self.view bringSubviewToFront: self.searchHistoryView];
                [self.view bringSubviewToFront:self.voiceSearchView];
            }
            
            break;
        }
    }
}


#pragma mark - FKYSearchBarDelegate搜索框触发代理

// 输入内容改变
- (void)searchBar:(FKYSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 刷新搜索历史
    if ([searchText isEqualToString:@""]) {
        [self p_fetchedSearchHistory];
        if (self.searchType == SearchTypeOrder) {
            //搜索订单埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9210" itemPosition:@"3" itemName:@"清空搜索词" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if (self.searchType == SearchTypeTogeterProduct){
            //一起购搜索页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7120" itemPosition:@"3" itemName:@"清空搜索词" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if(self.searchType == SearchTypePackageRate){
            //单品包邮页埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7820" itemPosition:@"3" itemName:@"清空搜索词" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else {
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"4" itemName:@"清空搜索词" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }
    }
    // 限制输入最大长度20个字符
    if (self.searchType != SearchTypeOrder){
        if (searchText.length > 20) {
            [self toast:@"超过搜索长度限制"];
            self.searchBar.text = [searchText substringToIndex:20];
        }
    }
    
    [self getSearchAssociativeWord:self.searchBar.text];
}

- (void)searchBar:(FKYSearchBar *)searchBar textDidEndEditing:(NSString *)searchText
{
    if (searchText.length > 20) {
        
    }
}
- (void)searchBar:(FKYSearchBar *)searchBar textFieldDidBeginEditing:(NSString *)searchText{
    if (self.searchType == SearchTypeTogeterProduct){
        //一起购搜索页埋点
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7120" itemPosition:@"2" itemName:@"输入框" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }else if (self.searchType == SearchTypeOrder) {
        //搜索订单埋点
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9210" itemPosition:@"2" itemName:@"输入框" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }else if (self.searchType == SearchTypePackageRate){
        //单品包邮埋点
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7820" itemPosition:@"2" itemName:@"输入框" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }
}
// 开始搜索
- (void)searchBarSearchButtonClicked:(FKYSearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    if (searchText && searchText.length > 0) {
        // 店铺ID是否为空（店铺内搜索历史与全部商品历史记录不在区分）
        NSNumber *sid = nil;
        if (self.searchType == SearchTypeJBPShop){
            if (self.jbpShopID && self.jbpShopID.length > 0 && self.jbpShopID.integerValue > 0) {
                sid = @(self.jbpShopID.integerValue);
            }
        }else if (self.searchType == SearchTypeYFLShop) {
            if (self.yflShopID && self.yflShopID.length > 0 && self.yflShopID.integerValue > 0) {
                sid = @(self.yflShopID.integerValue);
            }
        }else{
            if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
                sid = @(self.shopID.integerValue);
            }
        }
        
        // 保存搜索关键词
        @weakify(self);
        [self.service save:searchText type:@(self.searchType) shopId:nil success:^(BOOL mutiplyPage) {
            @strongify(self);
            // 刷新搜索历史
            [self p_fetchedSearchHistory];
        } failure:^(NSString *reason) {
            @strongify(self);
            [self toast:reason];
        }];
        if (self.searchType == SearchTypeOrder){
            //订单搜索
            [self p_go2orderSearchResultView:searchText];
            //搜索订单埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9210" itemPosition:@"4" itemName:@"搜索" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        }else if (self.searchType == SearchTypeCoupon){
            //优惠券可用商品搜索
            [self p_goCouponSearchResultView:searchText];
        }else{
            // 进入搜索结果列表界面  点击搜索按钮
            [self p_go2searchResultView:searchText andProductName:searchText andFactoryName:nil andCode:sid andFrom:@"searchButton"];
            if (self.searchType == SearchTypeTogeterProduct){
                //一起购搜索页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"头部" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7120" itemPosition:@"4" itemName:@"搜索" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else if (self.searchType == SearchTypePackageRate){
                //单品包邮页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7820" itemPosition:@"4" itemName:@"搜索" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }
            else {
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"5" itemName:@"搜索按钮" itemContent:[self getSellerCode] itemTitle:nil extendParams:@{@"keyword": searchText} viewController:self];
            }
        }
        
    }else{
        [self toast:@"搜索的关键词不能为空"];
    }
}

- (void)searchBarTextClear
{
    
}


#pragma mark - FKYSearchBarAlertViewDelegate

/// 切换搜索类型
/// @param index 即将切换到的搜索类型
- (void)switchSearchType:(int)index {
    if (index == 1){// 切换到搜索商品
        // 搜商品
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"2" itemName:@"切换至商品" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        self.searchType = SearchTypeProdcut;
        [self.searchBar placeholderChange:@"药品名/助记码/厂家"];
    }else if(index == 2){// 切换到搜索商家
        // 搜店铺
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"3" itemName:@"切换至店铺" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        self.searchType = SearchTypeShop;
        [self.searchBar placeholderChange:@"请输入商家名"];
    }
    self.searchRemindView.hidden = YES;
    self.searchHistoryView.hidden = NO;
    [self.view bringSubviewToFront: self.searchHistoryView];
    [self.view bringSubviewToFront:self.voiceSearchView];
    [self p_fetchedSearchHistory];
    [self installFoldHistoryList];
    [self switchHistoryListWithType:@"flodItem_up"];
}

// 切换类型...<商品or店铺>
- (void)searchBarAlertViewSelectIndex:(FKYSearchBarAlertView *)alertView state:(enum FKYSearchBarAlertViewselectedState)state
{
    self.alertViewIsAppear = NO;
    safeBlock(self.alertView.alertViewDismiss);
    if (state == FKYSearchBarAlertViewselectedStateProduct) {
        // 搜商品
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"2" itemName:@"切换至商品" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        
        [self.searchBar setLeftIconName:@"商品"];
        [self.searchBar placeholderChange:@"药品名/助记码/厂家"];
        self.searchType = SearchTypeProdcut; // 1
    }
    if (state == FKYSearchBarAlertViewselectedStateShop) {
        // 搜店铺
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索栏" itemId:searchItemId1 itemPosition:@"3" itemName:@"切换至店铺" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        
        [self.searchBar setLeftIconName:@"店铺"];
        [self.searchBar placeholderChange:@"请输入商家名"];
        self.searchType = SearchTypeShop; // 2
    }
    // 隐藏(搜索商品时的)实时联想搜索视图，显示历史搜索视图
    self.searchRemindView.hidden = YES;
    self.searchHistoryView.hidden = NO;
    [self.view bringSubviewToFront: self.searchHistoryView];
    [self.view bringSubviewToFront:self.voiceSearchView];
    // 获取历史搜索数据
    [self p_fetchedSearchHistory];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    safeBlock(self.alertView.alertViewDismiss);
}


#pragma mark - UICollectionViewDelegate...<搜索历史list>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.service.searchActivityArray.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1 && self.service.searchActivityArray.count > 0) {
        return self.service.searchActivityArray.count;;
    }
    return self.HistoryList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1  && self.service.searchActivityArray.count >0){
            FKYSearchContentHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FKYSearchContentHeader" forIndexPath:indexPath];
            [header congigView:@"搜索发现" cancleApper:YES];
            return header;
        }
        FKYSearchContentHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FKYSearchContentHeader" forIndexPath:indexPath];
        [header congigView:@"最近搜索" cancleApper:NO];
        
        @weakify(self);
        header.clearHistoryClick = ^(){
            @strongify(self);
            
            if (self.searchType == SearchTypeOrder) {
                //订单搜索埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"最近搜索词" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9211" itemPosition:@"0" itemName:@"清空" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else if (self.searchType == SearchTypeTogeterProduct){
                //一起购搜索页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"最近搜索词" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7121" itemPosition:@"0" itemName:@"清空" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else if (self.searchType == SearchTypePackageRate){
                //单品包邮页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7821" itemPosition:@"0" itemName:@"清空" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else {
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"最近搜索" itemId:searchItemId4 itemPosition:@"0" itemName:@"清空" itemContent:[self getSellerCode] itemTitle:nil extendParams:nil viewController:self];
            }
            
            [self.service clearHistorytype:@(self.searchType) shopId:nil Success:^(BOOL mutiplyPage) {
                @strongify(self);
                [self.HistoryList removeAllObjects];
                [self.foldHistoryList removeAllObjects];
                [self.searchHistoryView reloadData];
            } failure:^(NSString *reason) {
                
            }];
        };
        return header;
        
        //        FKYSearchCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FKYSearchCollectionViewHeader" forIndexPath:indexPath];
        //        [header congigView:@"历史记录" cancleApper:NO];
        
    }
    else {
        FKYSearchCollectionViewFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FKYSearchCollectionViewFooter" forIndexPath:indexPath];
        return footer;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, FKYWH(49));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1  && self.service.searchActivityArray.count >0){
        FKYSearchActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FKYSearchActivityCell" forIndexPath:indexPath];
        FKYSearchActivityModel *model = self.service.searchActivityArray[indexPath.row];
        [cell configCell:model];
        //        [cell layerApper:NO];
        //        [cell hiddenBottomline:YES];
        return cell;
    }
    FKYSearchHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FKYSearchHistoryCell" forIndexPath:indexPath];
    FKYSearchHistoryModel *model = self.HistoryList[indexPath.row];
    
    //[cell configCell:model.name];
    [cell configCellWithModel:model];
    [cell layerApper:NO];
    [cell hiddenBottomline:YES];
    @weakify(self);
    cell.deleteSigleHistoryBlock = ^(){
        @strongify(self);
        [self.service clearSigleHistorytype:@(self.searchType) shopId:nil keyWord:model.name Success:^(BOOL mutiplyPage) {
            @strongify(self);
            [self p_fetchedSearchHistory];
        } failure:^(NSString *reason) {
            
        }];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    if (indexPath.section == 1  && self.service.searchActivityArray.count >0){
        FKYSearchActivityModel *model = self.service.searchActivityArray[indexPath.row];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索发现" itemId:searchItemId3 itemPosition:[NSString stringWithFormat:@"%ld",indexPath.row + 1] itemName:model.name itemContent:[self getSellerCode] itemTitle:nil extendParams:nil viewController:self];
        if ([model.jumpInfo length] >0){
            [FKYNativeRouterOCObject visitSchema:model.jumpInfo];
        }
        return;
    }
    // 点击搜索历史...<本地保存的搜索历史>
    if (self.HistoryList && self.HistoryList.count > 0 && indexPath.row < self.HistoryList.count) {
        // 当前搜索关键词model...<历史>
        FKYSearchHistoryModel *model = self.HistoryList[indexPath.row];
        if ([model.itemType isEqualToString:@"flodItem_up"] || [model.itemType isEqualToString:@"flodItem_down"]){// 点击的折叠按钮
            self.isFold = false;
            [self switchHistoryListWithType:model.itemType];
            return;
        }
        NSString *keyword = model.name;
        // 店铺ID是否为空（店铺内搜索历史与全部商品历史记录不在区分）
        NSNumber *sid = nil;
        if (self.searchType == SearchTypeJBPShop){
            //专区
            if (self.jbpShopID && self.jbpShopID.length > 0 && self.jbpShopID.integerValue > 0) {
                sid = @(self.jbpShopID.integerValue);
            }
        }else if (self.searchType == SearchTypeYFLShop) {
            //药福利
            if (self.yflShopID && self.yflShopID.length > 0 && self.yflShopID.integerValue > 0) {
                sid = @(self.yflShopID.integerValue);
            }
        }else{
            if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
                sid = @(self.shopID.integerValue);
            }
        }
        // 保存
        @weakify(self);
        [self.service save:keyword type:@(self.searchType) shopId:nil success:^(BOOL mutiplyPage) {
            // 刷新搜索历史
            @strongify(self);
            [self p_fetchedSearchHistory];
        } failure:^(NSString *reason) {
            @strongify(self);
            [self toast:reason];
        }];
        // 更新搜索框内容
        self.searchBar.text = keyword;
        // 界面跳转 历史记录
        if (self.searchType == SearchTypeOrder){
            //订单搜索
            NSDictionary *extendParams = @{@"keyword": keyword};
            NSString *itemPosition = [NSString stringWithFormat:@"%ld",(indexPath.row+1)];
            
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"最近搜索词" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9211" itemPosition:itemPosition itemName:@"搜索词" itemContent:nil itemTitle:nil extendParams:extendParams viewController:self];
            
            [self p_go2orderSearchResultView:keyword];
            
        }else if (self.searchType == SearchTypeCoupon){
            //优惠券可用商品搜索
            [self p_goCouponSearchResultView:keyword];
        }else{
            NSDictionary *extendParams = @{@"keyword": keyword};
            
            if (self.searchType == SearchTypeTogeterProduct){
                //一起购搜索页埋点
                NSString *itemPosition = [NSString stringWithFormat:@"%ld",(indexPath.row+1)];
                
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"最近搜索词" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7121" itemPosition:itemPosition itemName:@"搜索词" itemContent:nil itemTitle:nil extendParams:extendParams viewController:self];
            }else if(self.searchType == SearchTypePackageRate){
                //单品包邮搜索页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"S7803" sectionPosition:@"0" sectionName:@"单品包邮搜索页" itemId:@"I7821" itemPosition:[NSString stringWithFormat:@"%ld",indexPath.row + 1] itemName:@"搜索词" itemContent:nil itemTitle:nil extendParams:extendParams viewController:self];
            } else {
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"最近搜索" itemId:searchItemId4 itemPosition:[NSString stringWithFormat:@"%ld",indexPath.row + 1] itemName:@"最近搜索词" itemContent:[self getSellerCode] itemTitle:nil extendParams:extendParams viewController:self];
            }
            [self p_go2searchResultView:keyword andProductName:keyword andFactoryName:nil andCode:sid andFrom:@"history"];
        }
        
    }
}


#pragma mark - UICollectionViewFlowLayoutDelegate

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && self.service.searchActivityArray.count > 0) {
        FKYSearchActivityModel *model = self.service.searchActivityArray[indexPath.row];
        if (!model.name || [model.name isEqualToString:@""]) {
            return CGSizeZero;
        }
        
        NSString *text = model.name;
        CGSize size = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
        CGRect textRect = [text
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName : FKYSystemFont(FKYWH(12)) }
                           context:nil];
        //CGFloat width = textRect.size.width + FKYWH(34)+FKYWH(18)+FKYWH(5);
        //return CGSizeMake(width, FKYWH(30));
        return CGSizeMake(FKYWH(169), FKYWH(30));
    }
    
    FKYSearchHistoryModel *model = self.HistoryList[indexPath.row];
    if (!model.name) {
        return CGSizeZero;
    }
    
    if ([model.itemType isEqualToString:@"flodItem_up"] || [model.itemType isEqualToString:@"flodItem_down"]){
        return CGSizeMake(FKYWH(30), FKYWH(30));
    }
    
    NSString *text = model.name;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    CGRect textRect = [text
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{ NSFontAttributeName : FKYSystemFont(FKYWH(12)) }
                       context:nil];
    CGFloat width = textRect.size.width + 10;
    if (width < FKYWH(30)) {
        width = FKYWH(30);
    }
    return CGSizeMake(width, FKYWH(30));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1){// 搜索发现
        return UIEdgeInsetsMake(0, FKYWH(15), 0, FKYWH(12));
    }
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark - UITableViewDelegate...<实时联想搜索list>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.service.searchRemindArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = searchRemindCellIndentifier;
    FKYSearchRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FKYSearchRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FKYSearchRemindModel *model = (FKYSearchRemindModel *)self.service.searchRemindArray[indexPath.row];
    [cell configCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    // 点击搜索结果...<实时联想搜索>
    if (self.service.searchRemindArray && self.service.searchRemindArray.count > 0 && indexPath.row < self.service.searchRemindArray.count) {
        // 当前搜索关键词model...<联想>
        FKYSearchRemindModel *model = self.service.searchRemindArray[indexPath.row];
        model.type = @1; // 商品搜索
        self.alertViewIsAppear = NO;
        safeBlock(self.alertView.alertViewDismiss);
        
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"搜索联想词" itemId:searchItemId5 itemPosition:[NSString stringWithFormat:@"%ld",indexPath.row + 1] itemName:@"联想词" itemContent:[self getSellerCode] itemTitle:model.drugName extendParams:@{@"keyword": self.searchBar.text} viewController:self];
        // 更新搜索框内容
        self.searchBar.text = model.drugName;
        // 店铺ID是否为空（店铺内搜索历史与全部商品历史记录不在区分）
        NSNumber *sid = nil;
        if (model.sellerCode && model.sellerCode.integerValue > 0) {
            sid = model.sellerCode;
        }
        if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
            sid = @(self.shopID.integerValue);
            //店铺内搜索保存历史记录时，由于返回的联想数据中没有id 需要传入店铺id,避免保存的时候没有id与全局搜索商品的历史记录冲突
            // model.sellerCode = sid;
        }
        // 点击之前已搜索的关键词时需重新进行保存/更新操作...<最新搜索的排在最前面>
        @weakify(self);
        [self.service saveSearchRemindModel:model success:^(BOOL mutiplyPage) {
            @strongify(self);
            [self p_fetchedSearchHistory];
        } failure:^(NSString *reason) {
            @strongify(self);
            [self toast:reason];
        }];
        // 界面跳转  联想关键词
        if (self.searchType == SearchTypeCoupon){
            //优惠券可用商品搜索
            [self p_goCouponSearchResultView:model.drugName];
        }else{
            [self p_go2searchResultView:model.drugName andProductName:model.drugName andFactoryName:model.factoryName andCode:sid andFrom:@"think"];
        }
    }
}


#pragma mark - UIScrollViewDelegate

// 滑动隐藏键盘
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.searchBar endEditing:YES];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


#pragma mark - Private Method

- (void)switchHistoryListWithType:(NSString *)type{
    [self.HistoryList removeAllObjects];
    if ([type isEqualToString:@"flodItem_down"]) {
        // 从展开到折叠
        self.isFold = true;
        [self.HistoryList addObjectsFromArray:self.foldHistoryList];
    }else if ([type isEqualToString:@"flodItem_up"]){
        // 从折叠到展开
        self.isFold = false;
        [self.HistoryList addObjectsFromArray:self.service.searchHistoryArray];
        if (self.isOverTwoLine){
            FKYSearchHistoryModel *history_t = [[FKYSearchHistoryModel alloc]init];
            history_t.itemType = @"flodItem_down";
            history_t.name = @"";
            [self.HistoryList addObject:history_t];
        }
    }
    [self.searchHistoryView reloadData];
}

/// 初始化折叠状态下的历史记录list
- (void)installFoldHistoryList{
    [self.foldHistoryList removeAllObjects];
    // 当前item所在的行
    int lines = 1;
    // 当前最右边的x值
    CGFloat maxX = 15;
    // 第二行能容纳的最大X 右边距+展开item+item间距
    CGFloat containerMaxX = SCREEN_WIDTH-15;
    // item 是否超过了2行
    BOOL isGreaterTwoLine = false;
    // 折叠按钮的宽度
    CGFloat flodItemWidth = FKYWH(30);
    // 第二行也就是最后一行折叠行的最大宽度 屏幕宽度-左右边距-item间隔-折叠按钮宽度
    //CGFloat lastItemMaxWidth = SCREEN_WIDTH-15-15-10-flodItemWidth;
    // 这一行的第几个item
    NSInteger ItemIndexInLine = 0;
    for (FKYSearchHistoryModel *history in self.service.searchHistoryArray) {
        //NSInteger index = [self.service.searchHistoryArray indexOfObject:history];
        CGFloat itemWidth = [self getItemWidthText:history.name];
        if (itemWidth < FKYWH(30)) {
            itemWidth = FKYWH(30);
        }
        if (lines == 1) {// 当前在第一行
            maxX += itemWidth;
            ItemIndexInLine += 1;
            if (maxX>containerMaxX){// 超过最右边的界限
                maxX = 15.0;
                
                lines += 1;
                ItemIndexInLine = 1;
            }else{
                maxX += 10;
                [self.foldHistoryList addObject:history];
                
            }
        }
        
        if (lines == 2) {// 当前在第二行
            maxX += itemWidth;
            if (ItemIndexInLine == 1 && maxX+10+flodItemWidth>containerMaxX){
                [self.foldHistoryList addObject:history];
                FKYSearchHistoryModel *history_t = [[FKYSearchHistoryModel alloc]init];
                history_t.itemType = @"flodItem_up";
                history_t.name = @"";
                [self.foldHistoryList addObject:history_t];
                isGreaterTwoLine = true;
                self.isOverTwoLine = true;
                break;
            }else{
                if (maxX+10 + flodItemWidth > containerMaxX){
                    FKYSearchHistoryModel *history_t = [[FKYSearchHistoryModel alloc]init];
                    history_t.itemType = @"flodItem_up";
                    history_t.name = @"";
                    [self.foldHistoryList addObject:history_t];
                    isGreaterTwoLine = true;
                    self.isOverTwoLine = true;
                    break;
                }else{
                    maxX += 10;
                    [self.foldHistoryList addObject:history];
                    ItemIndexInLine += 1;
                }
            }
        }
    }
    self.isFold = isGreaterTwoLine;
    self.isOverTwoLine = isGreaterTwoLine;
    [self.searchHistoryView reloadData];
}

/// 获取item的宽度
/// @param text item文字
- (CGFloat)getItemWidthText:(NSString *)text{
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    CGRect textRect = [text
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{ NSFontAttributeName : FKYSystemFont(FKYWH(12)) }
                       context:nil];
    CGFloat width = textRect.size.width + 10;
    return width;
}

- (void)checkMirAuthorizationStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self showInputVoiceView];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
            if (granted) {
                // Microphone enabled code
            }
            else {
                // Microphone disabled code
            }
        }];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"麦克风授权" message:@"1药城想要使用麦克风进行语音搜索" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [av show];
    }
}

// 获取搜索历史
- (void)p_fetchedSearchHistory
{
    @weakify(self);
    //    if (self.shopID && self.shopID.length > 0) {
    //        // 获取当前店铺内的商品搜索历史
    //        [self.service fetchSearchHistoryWithType:@(self.searchType) shopid:self.shopID Success:^(BOOL mutiplyPage) {
    //            @strongify(self);
    //            [self.searchHistoryView reloadData];
    //        } failure:^(NSString *reason) {
    //            @strongify(self);
    //            [self toast:reason];
    //        }];
    //        return;
    //    }
    // 通用的商品/店铺/一起购活动搜索历史
    [self.service fetchSearchHistoryWithType:@(self.searchType) Success:^(BOOL mutiplyPage) {
        @strongify(self);
        //[self.searchHistoryView reloadData];
    } failure:^(NSString *reason) {
        @strongify(self);
        [self toast:reason];
    }];
}


#pragma mark - 跳转搜索列表结果界面
//订单搜索
- (void)p_go2orderSearchResultView:(NSString *)keyword{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderStatusController) setProperty:^(FKYOrderStatusViewController *destinationViewController) {
        destinationViewController.isOrderSearch = YES;
        destinationViewController.searchText = keyword;
        destinationViewController.orderStatus = AllType;
    }];
    
}
//优惠券可用商品
- (void)p_goCouponSearchResultView:(NSString *)keyword{
    @weakify(self);
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopCouponProductController) setProperty:^(CouponProductListViewController *destinationViewController) {
        @strongify(self);
        destinationViewController.couponTemplateId = self.couponID;
        destinationViewController.shopId = self.shopID;
        destinationViewController.couponName = self.couponName;
        destinationViewController.keyword = keyword;
        destinationViewController.sourceType = self.sourceType;
        destinationViewController.couponCode = self.couponCode;
    }];
}

- (void)p_go2searchResultView:(NSString *)keyword andProductName:(NSString *)name andFactoryName:(NSString  *)factoryName andCode:(NSNumber *)code andFrom:(NSString *)fromWhere
{
    if (self.searchType == SearchTypeTogeterProduct) {
        //MARK: 1起购活动结果页
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Togeter_Search_Buy) setProperty:^(FKYTogeterSearchResultVC *destinationViewController) {
            destinationViewController.keyWordStr = keyword;
        }];
    }else if (self.searchType == SearchTypePackageRate){
        //MARK:包邮价活动结果页
        @weakify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Package_Rate) setProperty:^(FKYPackageRateViewController *destinationViewController) {
            @strongify(self);
            destinationViewController.keyWordStr = keyword;
            destinationViewController.typeIndex = 1;
            destinationViewController.selfTag = self.isSelfTag;
        }];
    }
    else {
        // MARK:搜索结果列表
        @weakify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SearchResult) setProperty:^(FKYSearchResultVC *destinationViewController) {
            @strongify(self);
            destinationViewController.keyword = keyword; // 搜索关键词
            destinationViewController.factoryNameKeyword = factoryName;
            destinationViewController.fromWhere = fromWhere;
            destinationViewController.keyWordSoruceType = 0;
            //
            if (self.searchFromType == SearchResultContentTypeFromCommon) {
                destinationViewController.searchFromType = @"fromCommon";
            }
            else if (self.searchFromType == SearchResultContentTypeFromShop) {
                destinationViewController.searchFromType = @"fromShop";
            }
            //商品
            if (self.searchType == SearchTypeProdcut ||self.searchType == SearchTypeJBPShop||self.searchType == SearchTypeYFLShop) {
                // 搜商品
                destinationViewController.searchResultType = @"Product"; // 搜索类型
                //destinationViewController.product_name = name; // 商品名称
                destinationViewController.sellerCode = (code && code.integerValue > 0 ? code : nil); // 商家id...<self.shopID.>
                if (self.searchType == SearchTypeJBPShop){
                    destinationViewController.jbpShopID = self.jbpShopID;
                    if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
                        NSNumber *shopCode = @(self.shopID.integerValue);
                        destinationViewController.sellerCode = (shopCode && shopCode.integerValue > 0 ? shopCode : nil);
                    }
                }else if (self.searchType == SearchTypeYFLShop) {
                    destinationViewController.yflShopID = self.yflShopID;
                    if (self.shopID && self.shopID.length > 0 && self.shopID.integerValue > 0) {
                        NSNumber *shopCode = @(self.shopID.integerValue);
                        destinationViewController.sellerCode = (shopCode && shopCode.integerValue > 0 ? shopCode : nil);
                    }
                }
                if ((self.shopID && self.shopID.length > 0)||self.searchType == SearchTypeJBPShop||self.searchType == SearchTypeYFLShop) {
                    // 有店铺id为店铺内搜索
                    destinationViewController.shopProductSearch = YES;
                }
                else {
                    // 若搜索结果界面的搜索词有更新，则需要回传到当前界面更新并保存
                    destinationViewController.updateSearchKeyword = ^(NSString *keyword, NSNumber *sid) {
                        @strongify(self);
                        // 保存...<keyword:最新搜索关键词 sid:商家id>（店铺内搜索历史与全部商品历史记录不在区分）
                        self.searchBar.text = keyword;
                        [self.service save:keyword type:@(self.searchType) shopId:nil success:^(BOOL mutiplyPage) {
                            // 刷新搜索历史
                            @strongify(self);
                            [self p_fetchedSearchHistory];
                        } failure:^(NSString *reason) {
                            //@strongify(self);
                            //[self toast:reason];
                        }];
                    };
                }
                // 通过商品搜索
                // 有筛选条件的全部商品搜索
                if (self.priceSeqType.length > 0) {
                    destinationViewController.priceSeq = self.priceSeqType;
                    destinationViewController.sortColumn =self.sortColumnType;
                    destinationViewController.selectedPriceDefault = true;
                    self.priceSeqType = @"";
                    self.sortColumnType = @"";
                }
                if (self.shopSortType.length > 0) {
                    destinationViewController.shopSort = self.shopSortType;
                    self.shopSortType = @"";
                }
                if (self.stockSeqType.length > 1) {
                    destinationViewController.stockSeq = self.stockSeqType;
                    self.stockSeqType = @"";
                }
                // 回传筛选条件
                destinationViewController.getVerbCondition = ^(NSString * priceSeq, NSString * sortColumn, NSString * shopSort, NSString * stockSeq) {
                    @strongify(self);
                    self.sortColumnType = sortColumn;
                    self.priceSeqType = priceSeq;
                    self.shopSortType = shopSort;
                    self.stockSeqType = stockSeq;
                };
            }
            else {
                // 搜店铺
                destinationViewController.searchResultType = @"Shop"; // 搜索类型
            };
        } isModal:NO];
    }
}


#pragma mark - Property

- (NSMutableArray *)foldHistoryList{
    if (!_foldHistoryList) {
        _foldHistoryList = [[NSMutableArray alloc]init];
    }
    return _foldHistoryList;
}

-(NSMutableArray *)HistoryList{
    if (!_HistoryList) {
        _HistoryList = [[NSMutableArray alloc]init];
    }
    return _HistoryList;
}

- (FKYSearchService *)service
{
    if (!_service) {
        _service = [[FKYSearchService alloc] init];
    }
    return _service;
}

- (NSString *)getSellerCode{
    //聚宝盆 专区ID
    if (self.searchType == SearchTypeJBPShop && self.jbpShopID&& self.jbpShopID.length > 0){
        return self.jbpShopID;
    }
    //药福利
    if (self.searchType == SearchTypeYFLShop && self.yflShopID&& self.yflShopID.length > 0){
        return self.yflShopID;
    }
    if (self.searchType == SearchTypeProdcut && self.shopID && self.shopID.length > 0){
        return self.shopID;
    }
    return nil;
}



- (FKYVoiceSearchView *)voiceSearchView {
    if (!_voiceSearchView) {
        _voiceSearchView = [[FKYVoiceSearchView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - FKYWH(57))/2, SCREEN_HEIGHT, FKYWH(57), FKYWH(57))];
        _voiceSearchView.layer.cornerRadius = FKYWH(57)/2;
        _voiceSearchView.clipsToBounds = YES;
        @weakify(self);
        _voiceSearchView.inputVoiceAction = ^{
            @strongify(self);
            //埋点
            if (self.searchType == SearchTypeOrder) {
                //订单搜索埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9212" itemPosition:@"0" itemName:@"语音搜索按钮/未识别时的语音搜索按钮" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else if (self.searchType == SearchTypeTogeterProduct){
                //一起购搜索页埋点
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:@"语音搜索" sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I7122" itemPosition:@"0" itemName:@"语音搜索按钮/未识别时的语音搜索按钮" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
            }else {
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"语音搜索" itemId:searchItemId2 itemPosition:@"0" itemName:@"语音搜索按钮/未识别时的语音搜索按钮" itemContent:[self getSellerCode] itemTitle:nil extendParams:nil viewController:self];
            }
            
            [self checkMirAuthorizationStatus];
        };
    }
    return _voiceSearchView;
}

- (FKYSearchSwitchTypeView *)searchSwitchTypeView{
    if (!_searchSwitchTypeView) {
        _searchSwitchTypeView = [[FKYSearchSwitchTypeView alloc]initWithFrame:CGRectZero];
    }
    return _searchSwitchTypeView;
}

@end

