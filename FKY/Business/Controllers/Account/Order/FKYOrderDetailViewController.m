//
//  FKYOrderDetailViewController.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailViewController.h"

#import "FKYAccountSchemeProtocol.h"
#import "FKYOrderService.h"
#import <Masonry/Masonry.h>

#import "FKYBillTypeTableViewCell.h"
#import "FKYOrderDetailCell.h"
#import "FKYLeftRightLabelCell.h"
#import "FKYShipeInfoCell.h"
#import "FKYOrderDetailDeliveryCell.h"
#import "FKYOrderDetailHeaderView.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "FKYAlertView.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "FKYCartSchemeProtocol.h"
#import "FKYOrderModel.h"
#import "FKYOrderDetailMoreInfoViewController.h"
#import "UIViewController+ToastOrLoading.h"
#import "FKYHomeSchemeProtocol.h"
#import "FKYOrderProductModel.h"
#import "FKYOrderDetailFooterView.h"

#import "FKYOrderDetailManage.h"

//#import "FKYBatchViewController.h"
#import "FKYLogisticsViewController.h"
#import "FKYLogisticsDetailViewController.h"
#import "FKYJSOrderDetailViewController.h"

#import "FKYGiftActionSheetView.h"
#import "UIWindow+Hierarchy.h"
#import "FKYShipListTableViewCell.h"


@interface FKYOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, FKYNavigationControllerDragBackDelegate, FKY_OrderDetailController,XHImageViewerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)  UITableView *mainTableView;
@property (nonatomic, strong)  UILabel *dispatchAlertLabel;
@property (nonatomic, strong)  UIView *bgAlertView;
@property (nonatomic, strong)  COInputController *mailInputVC;
@property (nonatomic, strong)  FKYBillListView *billListView;
@property (nonatomic, strong)  FKYOrderModel *orderDetailModel;
@property (nonatomic, strong)  FKYMoreInfoModel *cancelInfoModel;
@property (nonatomic, strong)  FKYOrderService *detailService;
@property (nonatomic, strong)  FKYOrderDetailManage *shareManage;
@property (nonatomic, strong)  NSMutableArray *sectionType;
@property (nonatomic, strong)  NSArray *cellType;
@property (nonatomic, strong)  NSArray *rowType;
@property (nonatomic, assign) NSInteger currentIndex;//当前电子随货同行单
@property (nonatomic, strong) NSMutableArray *arrImageview; //存放电子随货同行单图片
@property (nonatomic, strong) CartRebateInfoVC *cartRebateInfoVC;


@property (nonatomic, strong) FKYOrderActionView *actionView;//底部操作视图
// 找人代付需求新增
@property (nonatomic, strong) ShareView4Pay *shareView;  // 代付相关分享视图
@property (nonatomic, strong) FKYCartSubmitService *submitService;
@property (nonatomic, strong) FKYCmdPopView *cmdPopView;
@property (nonatomic,strong) NSArray *preActionArr; //记录第一次请求的按钮数组类型

/// 订单支付状态/抽奖 的viewModel
@property (nonatomic,strong)FKYOrderPayStatusViewModel *OrderPayStatusModel;

/// 是否已经成功请求过抽奖信息了
@property (nonatomic,assign)BOOL isRequestedDrawInfo;
/// 是否展示抽奖信息
@property (nonatomic,assign)BOOL isShowDrawInfo;
@end


@implementation FKYOrderDetailViewController

#pragma mark - LifeCircle

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isRequestedDrawInfo = false;
    self.isShowDrawInfo = false;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.shareManage = [FKYOrderDetailManage shareManage];
    if (self.orderModel.hasSellerRemark == 1) {
        self.sectionType = [NSMutableArray arrayWithArray:[self.shareManage orderDetailSectionType]];
    }
    else {
        self.sectionType = [NSMutableArray arrayWithArray:[self.shareManage orderDetailSectionNoneMsgType]];
    }
    
    //
    [self p_createBar];
    [self p_createAlertView];
    [self p_createTableView];
    [self addOrderActionView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    // 请求数据
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//FKY_entranceButtonClicked

#pragma mark - 响应事件
-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"entranceButtonClicked"]) {/// 点击去抽奖活动界面
        @weakify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
            @strongify(self);
            FKYOrderPayStatusVC *statusVC = (FKYOrderPayStatusVC *)destinationViewController;
            if (self.orderModel.orderId == nil || self.orderModel.orderId.length<1 || [self.orderModel.orderId isEqual:[NSNull null]]){
                statusVC.orderNO = self.orderID;
            }else{
                statusVC.orderNO = self.orderModel.orderId;
            }
        }];
    }
}
#pragma mark - UI

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
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"订单详情"];
    [self fky_setTitleColor:[UIColor blackColor]];
    @weakify(self);
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        @strongify(self);
        [[FKYNavigator sharedNavigator] pop];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"头部" itemId:@"I9300" itemPosition:@"1" itemName:@"返回" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = self;
}

- (void)p_createAlertView
{
    [self.view addSubview:self.bgAlertView];
    [self.bgAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo([self fky_NavigationBar].mas_bottom);
        make.height.offset(FKYWH(0));
    }];
    self.bgAlertView.hidden = true;
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromRGB(0xebedec);
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.bgAlertView);
        make.height.offset(FKYWH(1));
    }];
    [self.bgAlertView addSubview:self.dispatchAlertLabel];
    [self.dispatchAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgAlertView);
        make.bottom.equalTo(bottomLine);
    }];
}

- (void)p_createTableView
{
    self.mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.bgAlertView.mas_bottom);
        }];
        tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[FKYDrawEntranceCell class] forCellReuseIdentifier:NSStringFromClass([FKYDrawEntranceCell class])];
        [tableView registerClass:[FKYOrderDetailCell class] forCellReuseIdentifier:@"FKYOrderDetailCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [tableView registerClass:[FKYShipeInfoCell class] forCellReuseIdentifier:@"FKYShipeInfoCell"];
        [tableView registerClass:[FKYLeftRightLabelCell class] forCellReuseIdentifier:@"FKYLeftRightLabelCell"];
        [tableView registerClass:[OrderLeaveMsgInfoCell class] forCellReuseIdentifier:@"OrderLeaveMsgInfoCell"];
        [tableView registerClass:[FKYOrderDetailDeliveryCell class] forCellReuseIdentifier:@"FKYOrderDetailDeliveryCell"];
        [tableView registerClass:[FKYBillTypeTableViewCell class] forCellReuseIdentifier:@"FKYBillTypeTableViewCell"];
        [tableView registerClass:[FKYShipListTableViewCell class] forCellReuseIdentifier:@"FKYShipListTableViewCell"];
        [tableView registerClass:FKYOrderDetailProductCell.class forCellReuseIdentifier:@"FKYOrderDetailProductCell"];
        [tableView registerClass:[FKYOrderDetailFooterView class] forCellReuseIdentifier:@"FKYOrderDetailFooterView"];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView emptyFooterView];
        tableView;
    });
}



#pragma mark - Request

/// 请求抽奖信息
- (void)requestDrawInfoData{
    MJWeakSelf
    [self.OrderPayStatusModel requestDrawInfoFromPage:@"" orderNo:self.orderID.length > 0 ? self.orderID: self.orderModel.orderId block:^(BOOL isSuccess, NSString * _Nullable Msg) {
        if (isSuccess == false){
            [weakSelf toast:Msg];
            return;
        }
        weakSelf.isRequestedDrawInfo = true;
        if (weakSelf.OrderPayStatusModel.drawRawData.drawPic.length > 0 || weakSelf.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.length > 0){
            [weakSelf HandleDrawData:1];
        }else{
            [weakSelf HandleDrawData:2];
        }
        
    }];
}

- (void)requestData
{
    [self showLoading];
    @weakify(self);
    [self.detailService getOrderDetailWithOrderId:_orderModel.orderId success:^(FKYOrderModel *model){
        @strongify(self);
        [self dismissLoading];
        //根据包邮规则返回文描述
        NSMutableArray *ruleStrList = [NSMutableArray new];
        for (int i = 0; i<model.ruleList.count; i++) {
            NSDictionary *dic = model.ruleList[i];
            FKYFreightRule *rules =  [FKYFreightRule new];
            [ruleStrList addObject:[rules freightRules:i price:dic]];
        }
        model.ruleStrList = [ruleStrList mutableCopy];
        self.orderDetailModel = model;
        self.sectionType = [NSMutableArray arrayWithArray:[self.shareManage sectionTypeWithOrderModel:self.orderDetailModel]];
        self.cellType = [self.shareManage orderDetailCellTypeWithOrderModel:self.orderDetailModel];
        if (self.orderDetailModel.parentOrderFlag == 1){
            //子订单
            for (int index= 0;index<self.orderDetailModel.childOrderBeans.count;index++){
                NSMutableArray *childRuleStrList = [NSMutableArray new];
                FKYOrderModel *childModel = model.childOrderBeans[index];
                for (int i = 0; i<childModel.ruleList.count; i++) {
                    NSDictionary *dic = childModel.ruleList[i];
                    FKYFreightRule *rules =  [FKYFreightRule new];
                    [childRuleStrList addObject:[rules freightRules:i price:dic]];
                }
                childModel.ruleStrList = [childRuleStrList mutableCopy];
            }
            self.rowType = [self.shareManage childOrderFooterRowTye];
        }
        if (self.preActionArr == nil) {
            self.preActionArr = [FKYOrderActionView getActionsTypeArr:self.orderDetailModel];
            if (self.changeBtnBlock) {
                self.changeBtnBlock(false);
            }
        }else {
            //判断功能按钮数量及状态是否发生改变
            NSArray *nowActions = [FKYOrderActionView getActionsTypeArr:self.orderDetailModel];
            BOOL needResh = false;
            if (self.preActionArr.count != nowActions.count) {
                needResh = true;
            }else {
                for (NSNumber *typeNum in nowActions) {
                    if ([self.preActionArr containsObject:typeNum] == false) {
                        needResh = true;
                        break;
                    }
                }
            }
            if (self.changeBtnBlock) {
                self.changeBtnBlock(needResh);
            }
        }
        //获取电子随货同行单
        if (model.picurlList.count > 0) {
            UIImage *defalutImage = [[UIImageView new] imageWithColor:UIColorFromRGB(0xf4f4f4) :@"icon_home_placeholder_image_logo" :CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0)];
            for (int i = 0; i < model.picurlList.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView setFrame:CGRectMake(SCREEN_WIDTH/4.0, SCREEN_HEIGHT/2.0-SCREEN_WIDTH/4.0, SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.clipsToBounds = YES;
                imageView.userInteractionEnabled = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.picurlList[i]] placeholderImage:defalutImage];
                [self.arrImageview addObject:imageView];
            }
        }
        // 不再有CouponType类型...<老版CouponType优惠券已被当前店铺券和平台券替代>
        //        if ([model.supplyId integerValue] != SELF_SHOP || self.orderDetailModel.couponMoney.floatValue <= 0.) {
        //            // 非自营 or 优惠券金额为0
        //            [self.sectionType removeObject:@(CouponType)];
        //        }
        [self refreshAlertView];
        [self configActionView];
        [self requestCancelInfoData];
        [self.mainTableView reloadData];
        if (self.isRequestedDrawInfo == false){// 没有请求过
            [self requestDrawInfoData];
        }else{// 已经请求过了
            if (self.OrderPayStatusModel.drawRawData.drawPic.length > 0 || self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.length > 0){
                [self HandleDrawData:1];
            }else{
                [self HandleDrawData:2];
            }
        }
        
    } failure:^(NSString *reason) {
        @strongify(self);
        [self dismissLoading];
        [self toast:reason];
        if (self.isRequestedDrawInfo == false){// 没有请求过
            [self requestDrawInfoData];
        }else{// 已经请求过了
            if (self.OrderPayStatusModel.drawRawData.drawPic.length > 0 || self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.length > 0){
                [self HandleDrawData:1];
            }else{
                [self HandleDrawData:2];
            }
        }
        //        [self requestDrawInfoData];
    }];
}
- (void)requestCancelInfoData{
    
    if (![[self.orderDetailModel getOrderStatus] isEqualToString:orderStatus_cancle]){
        return;
    }
    [self showLoading];
    [self.detailService orderDetailMoreInfo:self.orderDetailModel.orderId success:^(FKYMoreInfoModel *model){
        [self dismissLoading];
        self.cancelInfoModel = model;
        [self.mainTableView reloadData];
    } failure:^(NSString *reason) {
        [self dismissLoading];
        [self toast:reason];
    }];
}


#pragma mark - Private

/// 处理抽奖入口cell 1是加入 2是移除
- (void)HandleDrawData:(NSInteger )headelType{
    BOOL isHaveEntrance = false;
    self.isShowDrawInfo = false;
    for (int i = 0 ;i < self.sectionType.count;i++){
        if ([self.sectionType[i] isEqual:@(drawCell)]) { // 已经含有drawCell
            isHaveEntrance = true;
        }
    }
    
    if (headelType == 1){// 插入入口
        if (isHaveEntrance == false) {
            [self.sectionType insertObject:@(drawCell) atIndex:0];
            self.isShowDrawInfo = true;
        }
    }else if (headelType == 2) {// 移除入口
        if (isHaveEntrance == true){
            [self.sectionType removeObjectAtIndex:0];
            self.isShowDrawInfo = false;
        }
    }
    [self.mainTableView reloadData];
}

- (void)sendVocieToEmail:(NSString *)emailStr
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = emailStr;
    param[@"orderNo"] = self.orderModel.orderId;
    [self showLoading];
    [[FKYRequestService sharedInstance] requestForOrderDetaiAboutSendVoiceToMail:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        [self dismissLoading];
        if (isSucceed==true) {
            [self toast:@"邮件发送成功"];
        }else{
            NSString *errStr = error.localizedDescription.length>0 ? error.localizedDescription :@"请求失败";
            [self toast:errStr];
        }
    }];
}

- (BOOL)deliveryCellAppear
{
    NSString *orderStatus = [self.orderDetailModel getOrderStatus];
    if ([orderStatus isEqualToString:orderStatus_compelited] ||
        [orderStatus isEqualToString:orderStatus_receive]  ||
        [orderStatus isEqualToString:orderStatus_rejected] ||
        [orderStatus isEqualToString:orderStatus_replenishment] ) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)refreshAlertView
{
    if (self.orderDetailModel.inventoryStatus == 0 && self.orderDetailModel.arrivalTips.length > 0) {
        [self.bgAlertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(FKYWH(32));
        }];
        self.bgAlertView.hidden = false;
        self.dispatchAlertLabel.text = self.orderDetailModel.arrivalTips;
    }
    else {
        [self.bgAlertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(FKYWH(0));
        }];
        self.bgAlertView.hidden = true;
    }
}
//查看电子随货同行单
-(void)lookShipListDetail
{
    if (self.arrImageview.count>0&&self.currentIndex<self.arrImageview.count) {
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
        imageViewer.delegate = self;
        imageViewer.showPageControl = true;
        //imageViewer.userPageNumber = true;
        imageViewer.hideWhenOnlyOne = true;
        imageViewer.showSaveBtn = true;
        [imageViewer showWithImageViews:self.arrImageview selectedView:self.arrImageview[self.currentIndex]];
    }
}
#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView pageIndex:(NSInteger)index
{
    self.currentIndex = index;
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionType.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionType[section]).integerValue;
    if (type == OrderInfo) {
        // 订单信息
        return self.cellType.count;
    }
    if (type == ProductInfo) {
        // 商品信息...<包含的商品个数>
        if (self.orderDetailModel.parentOrderFlag == 1){
            //有子订单
            if (self.orderDetailModel.hasSellerRemark == 1){
                //有留言
                if (self.isShowDrawInfo == true){
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 4];
                    return childOrderModel.productList.count + self.rowType.count + 1;
                }else{
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                    return childOrderModel.productList.count + self.rowType.count + 1;
                }
                
            }else{
                if (self.isShowDrawInfo == true){
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                    return childOrderModel.productList.count + self.rowType.count + 1;
                }else{
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 2];
                    return childOrderModel.productList.count + self.rowType.count + 1;
                }
                
            }
        }else if (type == drawCell){
            return 1;
        }
        else{
            return self.orderDetailModel.productList.count + 1;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    @weakify(self);
    switch (type) {
        case drawCell: // 抽奖活动入口
        {
            FKYDrawEntranceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKYDrawEntranceCell class])];
            NSString *imgUrl = @"";
            if (self.OrderPayStatusModel.drawRawData.drawPic.length > 0 ){
                imgUrl = self.OrderPayStatusModel.drawRawData.drawPic;
            }else if (self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.length > 0) {
                imgUrl = self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic;
            }
            [cell configCellDataWithCellData:imgUrl];
            return cell;
        }
        case OrderInfo: // 订单信息
        {
            FKYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CellType cellType = ((NSNumber *)self.cellType[indexPath.row]).integerValue;
            if (cellType == OrderNumber) { // 订单编号
                [cell configCellWithModel:self.orderDetailModel andCellType:OrderNumber];
                cell.copyHandler = ^{
                    @strongify(self);
                    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9301" itemPosition:@"1" itemName:@"复制订单号" itemContent:nil itemTitle:nil extendParams:nil viewController:self];
                };
            }
            if (cellType == OrderStatus) { // 订单状态
                [cell configCellWithModel:self.orderDetailModel andCellType:OrderStatus];
            }
            if (cellType == OrderTime) { // 下单时间
                [cell configCellWithModel:self.orderDetailModel andCellType:OrderTime];
            }
            if (cellType == SellerName) { // 销售顾问
                [cell configCellWithModel:self.orderDetailModel andCellType:SellerName];
            }
            if (cellType == OtherBHStatus) { // 剩余商品补货状态
                [cell configCellWithModel:self.orderDetailModel andCellType:OtherBHStatus];
            }
            if (cellType == OtherTKStatus) { // 剩余商品退款状态
                [cell configCellWithModel:self.orderDetailModel andCellType:OtherTKStatus];
            }
            if (cellType == BankInfo) { // 银行账户
                [cell configCellWithModel:self.orderDetailModel andCellType:BankInfo];
            }
            if (cellType == CancelOrderReason) { // 取消订单原因
                [cell configCancelCellWithModel:self.cancelInfoModel andCellType:CancelOrderReason];
            }
            if (cellType == CancelOrderTime) { // 取消订单时间
                [cell configCancelCellWithModel:self.cancelInfoModel andCellType:CancelOrderTime];
            }
            //
            cell.moreInfoButtonClickBlock = ^{
                @strongify(self);
                [[FKYNavigator sharedNavigator]
                 openScheme:@protocol(FKY_OrderDetailMoreInfoController)
                 setProperty:^(FKYOrderDetailMoreInfoViewController *destinationViewController) {
                    destinationViewController.orderModel = self.orderDetailModel;
                } isModal:NO animated:YES];
            };
            //
            cell.tapBlock = ^(CellType type){
                @strongify(self);
                if (type == BankInfo) { // 银行账户
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfflinePayInfo) setProperty:^(COOfflinePayDetailController *destinationViewController) {
                        destinationViewController.supplyId = [NSString stringWithFormat:@"%d", self.orderDetailModel.supplyId];
                        destinationViewController.flagFromCO = NO;
                    }];
                }
                if (type == OtherBHStatus) { // 剩余商品补货状态
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController)
                                                   setProperty:^(FKYJSOrderDetailViewController *destinationViewController) {
                        destinationViewController.orderModel = self.orderDetailModel;
                        destinationViewController.statusCode = @"900";
                    }];
                }
                if (type == OrderStatus) { // 订单状态
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController) setProperty:^(FKYJSOrderDetailViewController *destinationViewController) {
                        @strongify(self);
                        destinationViewController.orderModel = self.orderDetailModel;
                        if (self.orderDetailModel.portionDelivery.integerValue == 1 && [[self.orderDetailModel getOrderStatus] isEqualToString:orderStatus_replenishment]) {
                            destinationViewController.statusCode = @"900";
                        }
                        if ([[self.orderDetailModel getOrderStatus] isEqualToString:orderStatus_JSBU]) {
                            destinationViewController.statusCode = @"800";
                        }
                    }];
                }
            };
            return cell;
        }
            break;
        case ShipInfo: // 收货地址信息
        {
            FKYShipeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYShipeInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:self.orderDetailModel];
            return cell;
        }
            break;
        case mpLeaveMsgType: // 卖家给买家留言
        {
            OrderLeaveMsgInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderLeaveMsgInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.copyMsgAction = ^{
                @strongify(self);
                //复制留言
                [[UIPasteboard generalPasteboard] setString:self.orderDetailModel.sellerToBuyerRemark];
                [FKYToast showToast:@"复制成功"];
            };
            [cell configCell:self.orderDetailModel.sellerToBuyerRemark];
            return cell;
        }
            break;
        case ProductInfo: // 商品信息
        {
            if (self.orderDetailModel.parentOrderFlag == 1){
                //有子订单
                FKYOrderProductModel *productModel = nil;
                FKYOrderModel *childOrderModel = nil;
                if (self.orderDetailModel.hasSellerRemark == 1){
                    //有留言
                    if (self.isShowDrawInfo == true){
                        //有展示抽奖
                        childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 4];
                    }else{
                        //没有展示抽奖
                        childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                    }
                    
                    if (indexPath.row < childOrderModel.productList.count){
                        productModel = childOrderModel.productList[indexPath.row];
                    }
                }else{
                    if (self.isShowDrawInfo == true){
                        //有展示抽奖
                        childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                    }else{
                        //没有展示抽奖
                        childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 2];
                    }
                    if (indexPath.row < childOrderModel.productList.count){
                        productModel = childOrderModel.productList[indexPath.row];
                    }
                }
                //子订单价格信息
                if (indexPath.row == childOrderModel.productList.count ){
                    FKYOrderDetailFooterView *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailFooterView" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setValueWithDetailModel:childOrderModel];
                    return cell;
                }
                
                if (indexPath.row > childOrderModel.productList.count ){
                    RowType rowType = ((NSNumber *)self.rowType[indexPath.row - childOrderModel.productList.count - 1]).integerValue;
                    FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (rowType == ChildRebateGiftType) {// 赠品
                        FKYOrderDetailDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailDeliveryCell"];
                        
                        //防止重用
                        [cell hideAllLabel];
                        [cell configGiftCellWithModel:childOrderModel];
                        [cell showArraw:NO];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                    if (rowType == ChildTotalMoney) {
                        // 商品金额
                        [cell configCellWithModel:childOrderModel andType:ProductsMoneyType];
                    }
                    if (rowType == ChildFreightMoneyType) {
                        // 运费金额
                        [cell configCellWithModel:childOrderModel andType:FreightMoneyTypes];
                    }
                    if (rowType == ChildPayMoney) {
                        // 支付金额
                        [cell configCellWithModel:childOrderModel andType:PayMoneyType];
                    }
                    
                    if (rowType == ChildReduceMoney) {
                        // 满减金额
                        [cell configCellWithModel:childOrderModel andType:PromotionMoneyType];
                    }
                    if (rowType == ChildShopCouponType) {
                        // 店铺优惠券
                        [cell configCellWithModel:childOrderModel andType:CouponShopType];
                    }
                    if(rowType == ChildShopBuyMoneyType){
                        //购物金
                        [cell configCellWithModel:childOrderModel andType:BuyMoneyType];
                    }
                    if (rowType == ChildPlatformCouponType) {
                        // 平台优惠券
                        [cell configCellWithModel:childOrderModel andType:CouponPlatformType];
                    }
                    if (rowType == ChildRebateDeductibleMoneyType) {
                        //店铺返利金抵扣金额
                        [cell configCellWithModel:childOrderModel andType:RebateShopDeductibleType];
                    }
                    if (rowType == childRebatePlatformDeductibleMoneyType) {
                        //平台返利金抵扣金额
                        [cell configCellWithModel:childOrderModel andType:RebatePlatformDeductibleType];
                    }
                    if (rowType == ChildRebateObtainMoneyType) {
                        //获得返利金金额
                        [cell configCellWithModel:childOrderModel andType:RebateObtainType];
                    }
                    //显示返利金说明
                    cell.showRebateDescBlock = ^{
                        @strongify(self);
                        [self.cartRebateInfoVC showOrHidePopView:YES];
                    };
                    return cell;
                    
                }
                //子订单商品信息
                FKYOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailProductCell" forIndexPath:indexPath];
                [cell configCellWithModel:productModel];
                //协议奖励金
                cell.protocolRebateClosure = ^{
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                        destinationViewController.urlPath = productModel.agreementRebateDetailUrl;
                    } isModal:NO animated:YES];
                };
                return cell;
            }else{
                //底部价格
                if (indexPath.row == _orderDetailModel.productList.count ){
                    FKYOrderDetailFooterView *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailFooterView" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setValueWithDetailModel:_orderDetailModel];
                    return cell;
                }
                
                FKYOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailProductCell" forIndexPath:indexPath];
                FKYOrderProductModel *productModel = _orderDetailModel.productList[indexPath.row];
                [cell configCellWithModel:productModel];
                //协议奖励金
                cell.protocolRebateClosure = ^{
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                        destinationViewController.urlPath = productModel.agreementRebateDetailUrl;
                    } isModal:NO animated:YES];
                };
                return cell;
            }
            
            
            
        }
            break;
        case DeliverySectionType: // 配送类型
        {
            FKYOrderDetailDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailDeliveryCell" forIndexPath:indexPath];
            //防止重用
            [cell hideAllLabel];
            if ([self deliveryCellAppear]) {
                [cell configCellWithModel:self.orderDetailModel];
            }
            [cell showArraw:[self deliveryCellAppear] ? YES : NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case Gifts: // 赠品
        {
            FKYOrderDetailDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYOrderDetailDeliveryCell" forIndexPath:indexPath];
            //防止重用
            [cell hideAllLabel];
            if (self.orderDetailModel.orderPromotionGift.length > 0) {
                [cell configGiftCellWithModel:self.orderDetailModel];
            }
            [cell showArraw:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case FreightMoneyType: // 运费金额
        {
            FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:self.orderDetailModel andType:FreightMoneyTypes];
            return cell;
        }
            break;
        case BillSectionType: // 发票类型
        {
            FKYBillTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYBillTypeTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.eleArr = self.orderDetailModel.invoiceDtoList;
            [cell configCellWithModel:self.orderDetailModel];
            cell.clickSendMail = ^{
                @strongify(self);
                [self.mailInputVC showOrHidePopView:true];
            };
            cell.clickLookBillMail = ^{
                @strongify(self);
                [self.billListView updateView:self.orderDetailModel.invoiceDtoList :self.orderDetailModel];
                self.billListView.appearClourse();
            };
            return cell;
        }
            break;
        case ShipListType:{
            FKYShipListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYShipListTableViewCell" forIndexPath:indexPath];
            cell.clickShopListBtn = ^{
                @strongify(self);
                [self lookShipListDetail];
            };
            if (self.orderDetailModel.picurlList.count > 0) {
                cell.hidden = false;
            }else{
                cell.hidden = true;
            }
            return cell;
        }
            
            break;
        default: // 其它
        {
            FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (type == PaySectionType) {
                // 支付类型
                [cell configCellWithModel:self.orderDetailModel andType:PayType];
            }
            if (type == saleAgreement) {
                //销售合同随货
                [cell configCellWithModel:self.orderDetailModel andType:saleContract];
            }
            if (type == TotalMoney) {
                // 商品金额
                [cell configCellWithModel:self.orderDetailModel andType:ProductsMoneyType];
            }
            if (type == CouponType) {
                // 优惠券...<不再显示>
                [cell configCellWithModel:self.orderDetailModel andType:CouponMoneyType];
            }
            if (type == PayMoney) {
                // 支付金额
                [cell configCellWithModel:self.orderDetailModel andType:PayMoneyType];
            }
            if (type == Score) {
                // 积分
                [cell configCellWithModel:self.orderDetailModel andType:ScoreType];
            }
            if (type == ReduceMoney) {
                // 满减金额
                [cell configCellWithModel:self.orderDetailModel andType:PromotionMoneyType];
            }
            if (type == shopCouponType) {
                // 店铺优惠券
                [cell configCellWithModel:self.orderDetailModel andType:CouponShopType];
            }
            if (type == shopBuyMoneyType) {
                //购物金
                [cell configCellWithModel:self.orderDetailModel andType:BuyMoneyType];
            }
            if (type == platformCouponType) {
                // 平台优惠券
                [cell configCellWithModel:self.orderDetailModel andType:CouponPlatformType];
            }
            if (type == rebateDeductibleMoneyType) {
                //店铺返利金抵扣金额
                [cell configCellWithModel:self.orderDetailModel andType:RebateShopDeductibleType];
            }
            if (type == rebatePlatformDeductibleMoneyType) {
                //平台返利抵扣金额
                [cell configCellWithModel:self.orderDetailModel andType:RebatePlatformDeductibleType];
            }
            if (type == rebateObtainMoneyType) {
                //获得返利金金额
                [cell configCellWithModel:self.orderDetailModel andType:RebateObtainType];
            }
            //显示返利金说明
            cell.showRebateDescBlock = ^{
                @strongify(self);
                [self.cartRebateInfoVC showOrHidePopView:YES];
            };
            return cell;
        }
            break;
    }
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    
    if (type == OrderInfo) { // 订单信息
        CellType cellType = ((NSNumber *)self.cellType[indexPath.row]).integerValue;
        if (cellType == SellerName) {
            // 销售顾问
            if (self.orderDetailModel.adviserName.length >= 1) {
                return FKYWH(30);
            }
            else {
                return 0;
            }
        }else if (cellType == CancelOrderReason) { // 取消订单原因
            NSMutableString *cancelReasonStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"取消原因: %@", self.cancelInfoModel.cancelResult]];
            if (self.cancelInfoModel.cancelReasonValue != nil && self.cancelInfoModel.cancelReasonValue.length > 0){
                [cancelReasonStr appendString:[NSString stringWithFormat:@"-%@", self.cancelInfoModel.cancelReasonValue]];
            }
            if (self.cancelInfoModel.otherCancelReason != nil && self.cancelInfoModel.otherCancelReason.length > 0){
                [cancelReasonStr appendString:[NSString stringWithFormat:@"-%@", self.cancelInfoModel.otherCancelReason]];
            }
            CGSize contentSize = [cancelReasonStr sizeWithFont:[UIFont systemFontOfSize:FKYWH(13)] constrainedToWidth:SCREEN_WIDTH - FKYWH(20)];
            return contentSize.height + FKYWH(12);
        }
        else {
            // 其它...<订单编号、订单状态、下单时间、银行账户、剩余商品补货状态、剩余商品退款状态>
            return FKYWH(25);
        }
    }
    else if (type == ShipInfo) { // 地址信息
        return FKYWH(30+86 + 30+56);
    }
    else if (type == ProductInfo) { // 商品信息
        FKYOrderProductModel *productModel = nil;
        if (self.orderDetailModel.parentOrderFlag == 1){
            //有子订单
            FKYOrderModel *childOrderModel = nil;
            if (self.orderDetailModel.hasSellerRemark == 1){
                //有留言
                if (self.isShowDrawInfo == true){
                    //有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 4];
                }else{
                    //没有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                }
                if (indexPath.row < childOrderModel.productList.count){
                    productModel = childOrderModel.productList[indexPath.row];
                }
            }else{
                if (self.isShowDrawInfo == true){
                    //有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                }else{
                    //没有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 2];
                }
                if (indexPath.row < childOrderModel.productList.count){
                    productModel = childOrderModel.productList[indexPath.row];
                }
                
            }
            if (indexPath.row == childOrderModel.productList.count ){
                return FKYWH(40);
            }
            if (indexPath.row > childOrderModel.productList.count ){
                RowType rowType = ((NSNumber *)self.rowType[indexPath.row - childOrderModel.productList.count - 1]).integerValue;
                if (rowType == ChildFreightMoneyType) { // 运费金额
                    return FKYWH(44);
                }
                else if (rowType == ChildReduceMoney) { // 满减金额
                    if (childOrderModel.orderFullReductionMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }
                else if (rowType == ChildRebateDeductibleMoneyType){ // 店铺返利金抵扣
                    if (childOrderModel.useEnterpriseRebateMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }
                else if (rowType == childRebatePlatformDeductibleMoneyType){ // 平台返利金抵扣
                    if (childOrderModel.usePlatformRebateMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }
                else if (rowType == ChildShopCouponType){ // 店铺优惠券
                    if (childOrderModel.orderCouponMoney != nil && childOrderModel.orderCouponMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }else if (rowType == ChildShopBuyMoneyType){
                    if (childOrderModel.shopRechargeMoney != nil && childOrderModel.shopRechargeMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                    
                }else if (rowType == ChildPlatformCouponType){ // 平台优惠券
                    if (childOrderModel.orderPlatformCouponMoney != nil && childOrderModel.orderPlatformCouponMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }
                else if (rowType == ChildRebateObtainMoneyType) { // 获得返利金
                    if (childOrderModel.orderRebateObtainMoney.floatValue > 0) {
                        return FKYWH(44);
                    }
                    else {
                        return FKYWH(0.001);
                    }
                }else if (rowType == ChildRebateGiftType){// 赠品
                    if (![childOrderModel.orderPromotionGift isEqual:[NSNull null]] && childOrderModel.orderPromotionGift.length > 0){
                        return FKYWH(44);
                    }else{
                        return FKYWH(0.001);
                    }
                }else{
                    return FKYWH(44);
                }
            }
            return [FKYOrderDetailProductCell getContentHeight:productModel];
        }else{
            if (indexPath.row == _orderDetailModel.productList.count ){
                return FKYWH(40);
            }
            productModel = _orderDetailModel.productList[indexPath.row];
        }
        return [FKYOrderDetailProductCell getContentHeight:productModel];
    }
    else if (type == DeliverySectionType) { // 配送类型
        if ([self deliveryCellAppear]) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == mpLeaveMsgType) { // 卖家给买家留言
        CGSize contentSize = [self.orderDetailModel.sellerToBuyerRemark sizeWithFont:[UIFont systemFontOfSize:FKYWH(13)] constrainedToWidth:SCREEN_WIDTH - FKYWH(61)];
        return contentSize.height + FKYWH(54) ;
    }
    else if (type == Gifts) { // 赠品
        if (self.orderDetailModel.orderPromotionGift.length > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == Score) { // 积分
        if (self.orderDetailModel.orderFullReductionIntegration.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == FreightMoneyType) { // 运费金额
        return FKYWH(44);
    }
    else if (type == ReduceMoney) { // 满减金额
        if (self.orderDetailModel.orderFullReductionMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == shopCouponType) { // 店铺优惠券
        if (self.orderDetailModel.orderCouponMoney && self.orderDetailModel.orderCouponMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return CGFLOAT_MIN;
        }
        //        // 一直显示
        //        return FKYWH(44);
    }
    else if (type == shopBuyMoneyType){
        //购物金
        if ( self.orderDetailModel.shopRechargeMoney && self.orderDetailModel.shopRechargeMoney.floatValue > 0) {
            return FKYWH(44);
        }else {
            return CGFLOAT_MIN;
        }
    }
    else if (type == platformCouponType) { // 平台优惠券
        if (self.orderDetailModel.orderPlatformCouponMoney && self.orderDetailModel.orderPlatformCouponMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return CGFLOAT_MIN;
        }
        //        // 一直显示
        //        return FKYWH(44);
    }
    else if (type == rebateDeductibleMoneyType){ // 店铺返利金抵扣
        if (self.orderDetailModel.useEnterpriseRebateMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == rebatePlatformDeductibleMoneyType){ // 平台返利金抵扣
        if (self.orderDetailModel.usePlatformRebateMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == rebateObtainMoneyType) { // 获得返利金
        if (self.orderDetailModel.orderRebateObtainMoney.floatValue > 0) {
            return FKYWH(44);
        }
        else {
            return FKYWH(0.001);
        }
    }
    else if (type == BillSectionType) { // 发票类型
        if (self.orderDetailModel.invoiceDtoList != nil && self.orderDetailModel.invoiceDtoList.count > 0 ) {
            //            NSInteger count = self.orderDetailModel.invoiceDtoList.count;
            //            NSInteger lineRow = count/2+count%2;//计算有多少行
            //            return FKYWH(32+lineRow*(17+6)+15);
            //有电子发票或者发送邮箱按钮
            return FKYWH(84);
        }
        return FKYWH(44);
    }else if(type == ShipListType){
        //电子随货同行单
        if (self.orderDetailModel.picurlList.count > 0){
            return FKYWH(44);
        }
        return FKYWH(0.001);
    }else if(type == saleAgreement){
        //电子随货同行单
        if (self.orderDetailModel.viewPrintContract != nil && self.orderDetailModel.viewPrintContract.intValue == 1 ){
            return FKYWH(44);
        }
        return FKYWH(0.001);
    }else if(type == drawCell){
        // 抽奖入口
        return [FKYDrawEntranceCell getCellHeight];
    }
    else {
        return FKYWH(44);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionType[section]).integerValue;
    if (type == ProductInfo) {
        FKYOrderDetailHeaderView *view = (FKYOrderDetailHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYOrderDetailHeaderView"];
        if (view == nil) {
            view = [[FKYOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(200))];
        }
        @weakify(self);
        view.contactBlock = ^(NSString *itemName, NSString *itemPosition) {
            @strongify(self);
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"联系药城" itemId:@"I9302" itemPosition:itemPosition itemName:itemName itemContent:nil itemTitle:nil extendParams:nil viewController:self];
        };
        if (self.orderDetailModel.parentOrderFlag == 1){
            //有子订单
            if (self.orderDetailModel.hasSellerRemark == 1){
                //有留言
                if (self.isShowDrawInfo == true){
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 4];
                    [view setValueWithDetailModel:childOrderModel];
                }else{
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                    [view setValueWithDetailModel:childOrderModel];
                }
            }else{
                if (self.isShowDrawInfo == true){
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                    [view setValueWithDetailModel:childOrderModel];
                }else{
                    FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 2];
                    [view setValueWithDetailModel:childOrderModel];
                }
                
            }
        }else{
            [view setValueWithDetailModel:self.orderDetailModel];
        }
        
        view.backgroundColor = [UIColor whiteColor];
        return view;
    } else {
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(10))];
        blankView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        return blankView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(10))];
    blankView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    return blankView;
    //    SectionType type = ((NSNumber *)self.sectionType[section]).integerValue;
    //    if (type == ProductInfo) {
    //        FKYOrderDetailFooterView *view = (FKYOrderDetailFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYOrderDetailFooterView"];
    //        if (!view) {
    //            view = [[FKYOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(140))];
    //        }
    //        if (self.orderDetailModel.parentOrderFlag == 1){
    //            //有子订单
    //            if (self.orderDetailModel.hasSellerRemark == 1){
    //                //有留言
    //                FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
    //                [view setValueWithDetailModel:childOrderModel];
    //            }else{
    //                FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 2];
    //                [view setValueWithDetailModel:childOrderModel];
    //            }
    //        }else{
    //            [view setValueWithDetailModel:self.orderDetailModel];
    //        }
    //
    //        // view.backgroundColor = [UIColor whiteColor];
    //        return view;
    //    } else {
    //        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(10))];
    //        blankView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    //        return blankView;
    //    }
}

/*
 订单详情界面总的样式说明：
 0. 订单信息...<订单编号、订单状态、下单时间、销售顾问、银行账户、剩余商品退款状态、剩余商品补货状态>...[1个section]
 1. 收货信息...<收货地址>...[1个section]
 2. 商品列表...<供应商信息、商品列表信息、合计>...[1个section]
 3. 支付信息...<支付方式、配送类型、发票类型、赠品、积分>...[5个section]
 4. 金额信息...<商品金额、优惠券、满减金额、运费金额、店铺优惠券、平台优惠券、返利金抵扣金额、获得返利金金额、支付金额>...[9个section]
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionType[section]).integerValue;
    switch (type) {
        case ProductInfo:
            //            if (self.orderDetailModel.leaveMsg && self.orderDetailModel.leaveMsg.length > 0) {
            //                if (self.orderDetailModel.bdPhone && self.orderDetailModel.bdName) {
            //                    return FKYWH(193.5);
            //                } else {
            //                    return FKYWH(150);
            //                }
            //            } else {
            //                if (self.orderDetailModel.bdPhone && self.orderDetailModel.bdName) {
            //                    return FKYWH(133.5);
            //                } else {
            //                    return FKYWH(89);
            //                }
            //            }
            if (self.orderDetailModel.parentOrderFlag == 1){
                //有子订单
                if (self.orderDetailModel.hasSellerRemark == 1){
                    //有留言
                    if (self.isShowDrawInfo == true){
                        //有展示抽奖
                        FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 4];
                        return [FKYOrderDetailHeaderView configHeightWithDetailModel:childOrderModel];
                    }else{
                        FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                        return [FKYOrderDetailHeaderView configHeightWithDetailModel:childOrderModel];
                    }
                    
                }else{
                    if (self.isShowDrawInfo == true){
                        //有展示抽奖
                        FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 3];
                        return [FKYOrderDetailHeaderView configHeightWithDetailModel:childOrderModel];
                    }else{
                        FKYOrderModel *childOrderModel = self.orderDetailModel.childOrderBeans[section - 2];
                        return [FKYOrderDetailHeaderView configHeightWithDetailModel:childOrderModel];
                    }
                    
                }
            }else{
                return [FKYOrderDetailHeaderView configHeightWithDetailModel:self.orderDetailModel];
            }
            
            break;
        case DeliverySectionType:
        case BillSectionType:
        case ShipListType:
        case saleAgreement:
        case PayMoney:
        case CouponType:
        case Gifts:
        case Score:
        case ReduceMoney:
        case shopCouponType:
        case shopBuyMoneyType:
        case platformCouponType:
        case FreightMoneyType:
        case rebateDeductibleMoneyType:
        case rebatePlatformDeductibleMoneyType:
        case rebateObtainMoneyType:
        case PaySectionType:
            return 0.0001;
        case OrderInfo:{
            if (self.orderDetailModel.inventoryStatus == 0) {
                return 0.0001;
            }else{
                return FKYWH(10);
            }
        }
        default:
            // 各section之顶部间隔...<包括：订单信息、收货地址、支付类型、商品金额>
            // OrderInfo \ ShipInfo \ PaySectionType \ TotalMoney
            return FKYWH(10);
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionType[section]).integerValue;
    if (type == ProductInfo) {
        return FKYWH(10);
    }
    if (type == ShipInfo) {
        // 收货地址section之底部间隔
        return FKYWH(10);
    }
    if (type == mpLeaveMsgType) {
        // 收货地址section之底部间隔
        return FKYWH(10);
    }
    if (type == PayMoney) {
        // 支付金额section之底部间隔
        return FKYWH(10);
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    SectionType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    if (type == drawCell){
        @weakify(self);
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
            @strongify(self);
            FKYOrderPayStatusVC *statusVC = (FKYOrderPayStatusVC *)destinationViewController;
            statusVC.fromePage = 3;
            if (self.orderModel.orderId == nil || self.orderModel.orderId.length<1 || [self.orderModel.orderId isEqual:[NSNull null]]){
                statusVC.orderNO = self.orderID;
            }else{
                statusVC.orderNO = self.orderModel.orderId;
            }
        }];
        NSString *orderid = @"";
        if (self.orderModel.orderId == nil || self.orderModel.orderId.length<1 || [self.orderModel.orderId isEqual:[NSNull null]]){
            orderid = self.orderID;
        }else{
            orderid = self.orderModel.orderId;
        }
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:@"" floorPosition:@"" floorName:@"" sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I9303" itemPosition:@"1" itemName:@"点击抽奖" itemContent:@"" itemTitle:@"" extendParams:@{@"pageValue":orderid} viewController:self];
        return;
    }
    if (type == ProductInfo) {
        // 跳转商详
        FKYOrderProductModel *model = nil;
        if (self.orderDetailModel.parentOrderFlag == 1){
            //有子订单
            FKYOrderModel *childOrderModel = nil;
            if (self.orderDetailModel.hasSellerRemark == 1){
                //有留言
                if (self.isShowDrawInfo == true){
                    //有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 4];
                }else{
                    //没有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                }
                if (indexPath.row < childOrderModel.productList.count){
                    model = childOrderModel.productList[indexPath.row];
                }
            }else{
                if (self.isShowDrawInfo == true){
                    //有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 3];
                }else{
                    //没有展示抽奖
                    childOrderModel = self.orderDetailModel.childOrderBeans[indexPath.section - 2];
                }
                if (indexPath.row < childOrderModel.productList.count){
                    model = childOrderModel.productList[indexPath.row];
                }
            }
            if (indexPath.row == childOrderModel.productList.count){
                return;
            }
            if (indexPath.row > childOrderModel.productList.count ){
                RowType rowType = ((NSNumber *)self.rowType[indexPath.row - childOrderModel.productList.count - 1]).integerValue;
                // mp商家在订单详情中不显示运费规则
                if (rowType == ChildFreightMoneyType && childOrderModel.ruleStrList.count > 0) {
                    // （自营）运费
                    FKYFreightRuleView *view = [FKYFreightRuleView GloubView];
                    [view config:[NSString stringWithFormat:@"供应商为%@的需要增加运费，规则如下：", childOrderModel.supplyName] rules:childOrderModel.ruleStrList];
                    //UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                    UIWindow *window = [UIWindow getTopWindowForAddSubview];
                    [window addSubview:view];
                }
                return;
            }
        }else{
            if (indexPath.row == _orderDetailModel.productList.count){
                return;
            }
            model = _orderDetailModel.productList[indexPath.row];
        }
        
        // 商品ID
        NSString *pid = (model.productId ? [NSString stringWithFormat:@"%@", model.productId] : @"");
        // 供应商ID
        NSString *vid = @"";
        if (model.fictitiousId) {
            vid = [NSString stringWithFormat:@"%@", model.fictitiousId];
        }
        else {
            vid = [NSString stringWithFormat:@"%d", self.orderDetailModel.supplyId];
        }
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
            //@strongify(self);
            destinationViewController.productionId = pid;
            destinationViewController.vendorId = vid;
        } isModal:NO animated:YES];
        
        NSMutableDictionary *extendParams = @{}.mutableCopy;
        [extendParams setValue:[model getStorageData] forKey:@"storage"];
        [extendParams setValue:[model getPm_price] forKey:@"pm_price"];
        [extendParams setValue:[model getPm_pmtn_type] forKey:@"pm_pmtn_type"];
        
        NSMutableArray *ids = @[].mutableCopy;
        if (model.vendorId.length) {
            [ids addObject:model.vendorId];
        }
        if (model.productId.length) {
            [ids addObject:model.productId];
        }
        
        NSString *itemContent = [ids componentsJoinedByString:@"|"];
        
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9303" itemPosition:STRING_FORMAT(@"%ld",indexPath.row + 1) itemName:@"点进商详页" itemContent:itemContent itemTitle:nil extendParams:extendParams viewController:self];
        
    }
    
    if ([self deliveryCellAppear] && type == DeliverySectionType) {
        if ([[self.orderDetailModel getDeliveryMethod] isEqualToString:deliveryMethod_third]) {
            // 第三方物流
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsDetailController) setProperty:^(FKYLogisticsDetailViewController *destinationViewController) {
                @strongify(self);
                destinationViewController.orderId = self.orderDetailModel.orderId;
            } isModal:NO animated:YES];
        }
        else {
            // 自有物流
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsController) setProperty:^(FKYLogisticsViewController *destinationViewController) {
                @strongify(self);
                destinationViewController.deliveryType = deliveryMethod_own; //[self.orderDetailModel getDeliveryMethod];
                destinationViewController.orderId = self.orderDetailModel.orderId;
            } isModal:NO animated:YES];
        }
    }
    
    //    if (type == Gifts) {
    //        // 赠品
    //        NSArray *gift = [self.orderDetailModel.orderPromotionGift componentsSeparatedByString:@"|"];
    //        FKYGiftActionSheetView *sheet = [[FKYGiftActionSheetView alloc] initWithTitle:@"查看赠品信息" andCancleTitle:@"关闭" andDesArray:gift];
    //        [sheet showInView:[[[UIApplication sharedApplication] delegate] window]];
    //    }
    
    // mp商家在订单详情中不显示运费规则
    if (type == FreightMoneyType && self.orderDetailModel.ruleStrList.count > 0) {
        // （自营）运费
        FKYFreightRuleView *view = [FKYFreightRuleView GloubView];
        [view config:[NSString stringWithFormat:@"供应商为%@的需要增加运费，规则如下：", self.orderDetailModel.supplyName] rules:self.orderDetailModel.ruleStrList];
        //UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIWindow *window = [UIWindow getTopWindowForAddSubview];
        [window addSubview:view];
    }
}


#pragma mark - FKYNavigationControllerDragBackDelegate

- (BOOL)dragBackShouldStartInNavigationController:(FKYNavigationController *)navigationController
{
    [[FKYNavigator sharedNavigator] pop];
    return NO;
}


#pragma mark - Property

- (FKYOrderPayStatusViewModel *)OrderPayStatusModel{
    if (!_OrderPayStatusModel) {
        _OrderPayStatusModel = [[FKYOrderPayStatusViewModel alloc]init];
    }
    return _OrderPayStatusModel;
}

- (COInputController *)mailInputVC
{
    if (!_mailInputVC) {
        _mailInputVC = [[COInputController alloc] init];
        _mailInputVC.viewParent = self.view;
        _mailInputVC.heightContentView = FKYWH(135);
        _mailInputVC.popTitle = @"发送邮箱";
        _mailInputVC.inputType = COInputTypeEmailCode;
        @weakify(self);
        _mailInputVC.inputOverBlock = ^(NSString * content, enum COInputType inputType, id date) {
            @strongify(self);
            [self sendVocieToEmail:content];
        };
    }
    return _mailInputVC;
}

- (UILabel *)dispatchAlertLabel
{
    if (!_dispatchAlertLabel) {
        _dispatchAlertLabel = [UILabel new];
        _dispatchAlertLabel.textColor = UIColorFromRGB(0xE8772A);
        _dispatchAlertLabel.textAlignment = NSTextAlignmentCenter;
        _dispatchAlertLabel.font = FKYSystemFont(12);
    }
    return _dispatchAlertLabel;
}

- (UIView *)bgAlertView
{
    if (!_bgAlertView) {
        _bgAlertView = [UIView new];
        _bgAlertView.backgroundColor = UIColorFromRGB(0xFFFCF1);
    }
    return _bgAlertView;
}

- (FKYOrderService *)detailService
{
    if (!_detailService) {
        _detailService = [[FKYOrderService alloc] init];
    }
    return _detailService;
}

- (NSMutableArray *)arrImageview
{
    if (!_arrImageview) {
        _arrImageview = [NSMutableArray array];
    }
    return _arrImageview;
}

- (FKYBillListView *)billListView
{
    if (!_billListView) {
        _billListView = [[FKYBillListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_billListView];
    }
    return _billListView;
}

- (CartRebateInfoVC *)cartRebateInfoVC
{
    if (!_cartRebateInfoVC) {
        _cartRebateInfoVC = [[CartRebateInfoVC alloc] init];
    }
    return _cartRebateInfoVC;
}


#pragma mark -- 底部操作按钮
- (void)addOrderActionView {
    [self.view addSubview:self.actionView];
    [self.view bringSubviewToFront:self.actionView];
    self.actionView.hidden = YES;
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(FKYWH(62) + [self getBottomMargin]);
    }];
}

- (void)configActionView {
    NSArray *actions = [FKYOrderActionView getActionsData:self.orderDetailModel];
    if (actions.count > 0) {
        self.actionView.hidden = false;
        [self.actionView configActionView:self.orderDetailModel];
        [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-(FKYWH(62) + [self getBottomMargin]));
        }];
    }else {
        self.actionView.hidden = true;
        [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }
}

- (FKYOrderActionView *)actionView {
    if (!_actionView) {
        _actionView = [[FKYOrderActionView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _actionView.actionClousure = ^(FKYOrderActionModel *actionModel) {
            @strongify(self);
            [self handleActionModel:actionModel];
        };
        
        _actionView.updateSelfLayoutClousure = ^(BOOL hideActionView) {
            @strongify(self);
            [self updateSelfActionViewLayout:hideActionView];
        };
    }
    return _actionView;
}


- (void)updateSelfActionViewLayout:(BOOL) hideActionView {
    if (hideActionView) {
        [self.actionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(FKYWH(62) + [self getBottomMargin]);
        }];
    }else {
        [self.actionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
    }
}

- (FKYCartSubmitService *)submitService
{
    if (!_submitService) {
        _submitService = [[FKYCartSubmitService alloc] init];
    }
    return _submitService;
}

- (FKYCmdPopView *)cmdPopView {
    if (!_cmdPopView) {
        _cmdPopView = [[FKYCmdPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _cmdPopView;
}


- (CGFloat)getBottomMargin {
    CGFloat margin = 0;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            margin = iPhoneX_SafeArea_BottomInset;
        }
    }
    return margin;
}

//底部按钮逻辑
- (void)handleActionModel:(FKYOrderActionModel *)model {
    switch (model.actionType) {
        case FKYOrderActionTypeGoPay: {
            //"立即支付"
            //进去界面判断是否需要刷新
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SelectOnlinePay) setProperty:^(id<FKY_SelectOnlinePay> destinationViewController) {
                destinationViewController.orderId = self.orderDetailModel.orderId;
                if(self.orderDetailModel.parentOrderFlag == 1){
                    //有子订单
                    destinationViewController.supplyIdList = self.orderDetailModel.supplyIds;
                }else{
                    destinationViewController.supplyId = [NSString stringWithFormat:@"%d", self.orderDetailModel.supplyId];
                }
                destinationViewController.orderMoney = [NSString stringWithFormat:@"%.2f", self.orderDetailModel.finalPay.floatValue];
                destinationViewController.flagFromCO = NO;
            } isModal:NO animated:YES];
            
            [self addBIRecordWithItemName:@"立即支付" itemPosition:3];
            
        }
            break;
        case FKYOrderActionTypePayOffline: {
            // 线下支付
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfflinePayInfo) setProperty:^(COOfflinePayDetailController *destinationViewController) {
                destinationViewController.supplyId = [NSString stringWithFormat:@"%d", self.orderDetailModel.supplyId];
                destinationViewController.flagFromCO = NO;
                
            }];
            [self addBIRecordWithItemName:@"线下转账" itemPosition:14];
        }
            break;
            
        case FKYOrderActionTypeBuyAgain: {
            //"再次购买"
            [self __bugAgain];
            // 加车埋点
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9999" itemPosition:@"0" itemName:@"再次购买" itemContent:self.orderModel.orderId itemTitle:nil extendParams:nil viewController:self];
            
        }
            break;
            
        case FKYOrderActionTypePayByOther:{
            //"找人代付"
            // 线上支付传1
            [self startShareAction:self.orderDetailModel.orderId payType:@"1"];
            [self addBIRecordWithItemName:@"找人代付"  itemPosition:12];
        }
            break;
            
        case FKYOrderActionTypeSharePayInfo:{
            //"分享支付信息"
            // 线下支付传3
            [self startShareAction:self.orderDetailModel.orderId payType:@"3"];
            [self addBIRecordWithItemName:@"分享支付信息" itemPosition:2];
        }
            break;
            
        case FKYOrderActionTypeCustomerService: {
            //"联系客服"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC  *destinationViewController) {
                NSMutableDictionary *extDic = [NSMutableDictionary new];
                extDic[@"type"] = @"1";
                extDic[@"data"] = @{@"flowId":self.orderDetailModel.orderId,@"amount":self.orderDetailModel.finalPay,@"productTypeCount":self.orderDetailModel.varietyNumber,@"orderTime":self.orderDetailModel.createTime,@"orderStatus":[self.orderDetailModel getOrderStatus]};
                destinationViewController.urlPath = [NSString stringWithFormat:@"%@?platform=3&supplyId=%@&ext=%@&openFrom=%d",API_IM_H5_URL,[NSString stringWithFormat:@"%d",self.orderDetailModel.supplyId],extDic.jsonString,2];
                destinationViewController.navigationController.navigationBarHidden = YES;
            } isModal:false];
            [self addBIRecordWithItemName:@"联系客服" itemPosition:0];
            
        }
            break;
            
        case FKYOrderActionTypeLogistics: {
            //"查看物流"
            [self pushToLogisticsDetailJSControllerWithModel:self.orderDetailModel];
            [self addBIRecordWithItemName:@"查看物流"  itemPosition:7];
        }
            break;
            
        case FKYOrderActionTypeConfirmReceive: {
            //"确认收货"
            [self __confirmReceive];
            [self addBIRecordWithItemName:@"确认收货" itemPosition:9];
        }
            break;
        case FKYOrderActionTypeAfterSale: {
            //"申请售后"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AfterSaleListController) setProperty:^(AfterSaleListController *destinationViewController) {
                destinationViewController.paytype = self.orderDetailModel.payType.intValue;
                destinationViewController.orderModel = self.orderDetailModel;
            } isModal:NO animated:YES];
            [self addBIRecordWithItemName:@"申请售后" itemPosition:13];
        }
            break;
            
        case FKYOrderActionTypeReceiveDelay: {
            //"延期收货"
            @weakify(self);
            [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"取消" rightTitle:@"确定" message:@"确定延期收货？" handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                @strongify(self);
                if (isRight) {
                    // 延期收货请求
                    [self.detailService delayProductionWithOrderId:self.orderDetailModel.orderId success:^(NSString *reason) {
                        //
                        @strongify(self);
                        [self toast:reason];
                        [self requestData];
                    } failure:^(NSString *reason) {
                        //
                        @strongify(self);
                        [self toast:reason];
                    }];
                }
            }];
            [self addBIRecordWithItemName:@"延期收货" itemPosition:4];
        }
            break;
            
        case FKYOrderActionTypeGoComment: {
            //"去评价"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",@"http://m.yaoex.com",self.orderDetailModel.orderId];
                destinationViewController.pushType = 2;
            } isModal:NO animated:YES];
            [self addBIRecordWithItemName:@"去评价"  itemPosition:5];
        }
            break;
            
        case FKYOrderActionTypeComplainVendor: {
            //"投诉商家"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_BuyerComplainController) setProperty:^(BuyerComplainInputController *destinationViewController) {
                destinationViewController.orderModel = self.orderDetailModel;
            } isModal:NO animated:YES];
            
            [self addBIRecordWithItemName:@"投诉商家" itemPosition:8];
        }
            break;
            
        case FKYOrderActionTypeComplationDetail: {
            //"查看投诉"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_BuyerComplainDetailController) setProperty:^(BuyerComplainDetailController *destinationViewController) {
                destinationViewController.orderModel = self.orderDetailModel;
            } isModal:NO animated:YES];
            [self addBIRecordWithItemName:@"查看投诉" itemPosition:15];
        }
            break;
            
        case FKYOrderActionTypeRefuseDetail: {
            //"查看拒收"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController)
                                           setProperty:^(FKYJSOrderDetailViewController *destinationViewController) {
                destinationViewController.orderModel = self.orderDetailModel;
                destinationViewController.statusCode = @"800";
            }];
            [self addBIRecordWithItemName:@"查看拒收详情"  itemPosition:10];
        }
            break;
        case FKYOrderActionTypeAddProductsDetail: {
            //"查看补货"
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_JSOrderDetailController)
                                           setProperty:^(FKYJSOrderDetailViewController *destinationViewController) {
                destinationViewController.orderModel = self.orderDetailModel;
                destinationViewController.statusCode = @"900";
            }];
            
            [self addBIRecordWithItemName:@"查看补货详情"  itemPosition:11];
        }
            break;
        case FKYOrderActionTypeCancelOrder: {
            //"取消订单"
            if (self.detailService.reasonsArray.count > 0) {
                FKYCancelReasonView *reasonView = [[FKYCancelReasonView alloc] initWithFrame:CGRectZero];
                @weakify(self);
                reasonView.closeClouser = ^{
                    @strongify(self);
                    [self.cmdPopView  hidePopView];
                };
                
                reasonView.confirmClouser = ^(NSString * type, NSString * reasonStr,NSString *biReason, NSInteger itemPosition) {
                    @strongify(self);
                    [self.cmdPopView  hidePopView];
                    [self cancelOrderWithOrder:self.orderDetailModel type:type str:reasonStr biReason:biReason itemPosition:itemPosition];
                };
                
                CGFloat height = 528.0 * SCREEN_HEIGHT / 667.0;
                [self.cmdPopView showSubViewWithSubView:reasonView toVC:self.parentViewController subHeight:height];
                [reasonView reloadReasonsTableWithData:self.detailService.reasonsArray];
                return ;
            }
            @weakify(self);
            [FKYProductAlertView showAlertViewWithTitle:nil leftTitle:@"取消" rightTitle:@"确定" message:@"你确定要取消订单吗" handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                //
                @strongify(self);
                if (isRight) {
                    
                    [self addBIRecordWithItemName:@"取消订单" itemPosition:1];
                    BOOL isSelf = NO;
                    if (self.orderDetailModel.isZiYingFlag == 1 && [self.orderDetailModel.orderStatus integerValue] == 2) {
                        isSelf = YES;
                    }
                    // 取消订单请求
                    [self.detailService cancelOrderWithOrderId:self.orderDetailModel  isSelf:isSelf success:^(NSString *reason) {
                        //
                        @strongify(self);
                        if (self.orderDetailModel.payTypeId) {
                            if (self.orderDetailModel.payTypeId.integerValue == 17) {
                                [self toast:@"订单取消成功，1药贷额度预计2个工作日恢复"];
                            } else {
                                [self toast:reason];
                            }
                        } else {
                            [self toast:reason];
                        }
                        
                        [self requestData];
                    } failure:^(NSString *reason) {
                        @strongify(self);
                        if (isSelf) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                        }
                        else {
                            [self toast:reason];
                        }
                    }];
                }
            }];
            
        }
            break;
        default:
            break;
    }
}



//再次购买
- (void)__bugAgain {
    [self showLoading];
    @weakify(self);
    [self.detailService buyAgainOrderType:self.orderDetailModel.orderType
                               andOrderId:self.orderDetailModel.orderId success:^(NSNumber *data) {
        @strongify(self);
        [self dismissLoading];
        //[self toast:@"加入购物车成功"];
        if (data && data.integerValue > 0) {
            // failCount>0 部分成功
            NSString *tip = [NSString stringWithFormat:@"订单中有%ld个商品未加入购物车，其余商品已加入！\n未加入的商品包含已下架，无库存或者无采购权。", (long)data.integerValue];
            [self toast:tip];
            //return;
        }
        // 跳转到购物车...<全部成功>
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
            destinationViewController.index = 3;
        } isModal:YES];
    } failure:^(NSString *reason) {
        @strongify(self);
        [self dismissLoading];
        [self toast: (reason && reason.length > 0) ? reason : @"加入购物车失败"];
    }];
}


// 找人代付
- (void)startShareAction:(NSString *)orderid payType:(NSString *)payType
{
    if (self.orderDetailModel.sharePayUrl && self.orderDetailModel.sharePayUrl.length > 0) {
        // 已获取分享链接
        [self showShareView];
    }
    else {
        // 未获取分享链接
        [self showLoading];
        
        @weakify(self);
        [self.submitService getOrderShareSign:orderid payType:payType success:^(BOOL mutiplyPage, id data) {
            @strongify(self);
            [self dismissLoading];
            // 保存分享链接
            if (data && [data isKindOfClass:[NSString class]]) {
                NSString *shareUrl = (NSString *)data;
                if (shareUrl && shareUrl.length > 0) {
                    self.orderDetailModel.sharePayUrl = shareUrl;
                    [self showShareView];
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

// 微信好友分享
- (void)WXShare
{
    // 只设置标题，不设置描述
    [FKYShareManage shareToWXWithOpenUrl:[self shareUrl] title:[self shareTitle] andMessage:nil andImage:[self shareImage]];
    // [self BI_Record:@"product_yc_share_wechat"];
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

// 显示分享视图
- (void)showShareView
{
    if (self.shareView.superview == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.shareView];
    }
    self.shareView.appearClourse();
}

// 分享图片
- (NSString *)shareImage
{
    return nil;
}

// 分享标题
- (NSString *)shareTitle
{
    return [NSString stringWithFormat:@"我在1药城采购了一批商品，总金额为￥%.2f，点击链接帮我支付吧！", self.orderDetailModel.finalPay.floatValue];
}

// 分享链接
- (NSString *)shareUrl
{
    return self.orderDetailModel.sharePayUrl;
}

// 查看物流
- (void)pushToLogisticsDetailJSControllerWithModel:(FKYOrderModel *)model
{
    if ([[model getDeliveryMethod] isEqualToString:deliveryMethod_third]) {
        // 查看第三方物流
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsDetailController) setProperty:^(FKYLogisticsDetailViewController *destinationViewController) {
            destinationViewController.orderId = model.orderId;
        } isModal:NO animated:YES];
    }
    else {
        // 查看自有物流
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsController) setProperty:^(FKYLogisticsViewController *destinationViewController) {
            destinationViewController.deliveryType = deliveryMethod_own;
            destinationViewController.orderId = model.orderId;
        } isModal:NO animated:YES];
    }
}

- (void)__confirmReceive {
    if (self.orderDetailModel.isZiYingFlag == 1) {
        // 自营确认收货...<一次收完>
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认收货?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        // mp确认收货...<跳转界面，用户可设置不同商品的收货数量后再提交>
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ReceiveController) setProperty:^(FKYReceiveProductViewController *destinationViewController) {
            destinationViewController.orderId = self.orderDetailModel.orderId;
            destinationViewController.isZiYingFlag = self.orderDetailModel.isZiYingFlag;
            destinationViewController.selectDeliveryAddressId = self.orderDetailModel.selectDeliveryAddressId;
            destinationViewController.supplyId = [NSString stringWithFormat:@"%d",self.orderDetailModel.supplyId];
            //全部收回返回则选择到已完成订单
            destinationViewController.clickAllProudct = ^{
            };
        } isModal:NO];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // (自营)确认收货
        [self showLoading];
        @weakify(self);
        // 收货清单
        [self.detailService geiReceiveProductListWithOrderId:self.orderDetailModel.orderId success:^(FKYReceiveModel *receiveModel) {
            [self dismissLoading];
            // 获取当前订单下的商品列表成功
            @strongify(self);
            NSMutableArray *temp = [NSMutableArray array];
            for (FKYReceiveProductModel *obj in receiveModel.productList) {
                NSMutableDictionary *dic = @{}.mutableCopy;
                dic[@"orderDetailId"] = obj.orderDetailId;
                dic[@"batchId"] = obj.batchId;
                dic[@"buyNumber"] = obj.deliveryProductCount;
                [temp addObject:dic];
            } // for
            @weakify(self);
            // 拒收 补货
            [self.detailService refusedOrReplenishOrderWithOrderId:self.orderDetailModel.orderId andProductList:[self jsonStringFromArray:temp] andApplyType:@"" andApplyCause:@"" andAddressId:nil success:^(NSString *message){
                @strongify(self);
                [self dismissLoading];
                //[self toast:message];
                // 操作成功后重新刷新订单列表数据
                [self requestData];
                //自营店点击收货后跳转到评价界面
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC *destinationViewController) {
                    destinationViewController.urlPath = [NSString stringWithFormat: @"%@/h5/feedback/index.html#/?orderId=%@",ORDER_PJ_HOST,self.orderDetailModel.orderId];
                    destinationViewController.pushType = 1;
                } isModal:NO animated:YES];
            } failure:^(NSString *reason) {
                @strongify(self);
                [self dismissLoading];
                [self toast:reason];
            }];
        } failure:^(NSString *reason) {
            // 获取当前订单下的商品列表失败
            @strongify(self);
            [self dismissLoading];
            [self toast:reason];
        }];
    }
}

- (NSString *)jsonStringFromArray:(NSArray *)array
{
    if (!array.count) {
        return  @"[]";
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}


//取消订单增加原因
- (void)cancelOrderWithOrder:(FKYOrderModel *)model  type:(NSString *)type str:(NSString *)str biReason:(NSString *)biReason  itemPosition:(NSInteger)itemPosition {
    
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"选择取消订单原因" itemId:@"I9204" itemPosition:STRING_FORMAT(@"%zd", itemPosition) itemName:biReason itemContent:model.orderId itemTitle:nil extendParams:nil viewController:self];
    
    
    @weakify(self);
    BOOL isSelf = NO;
    if (model.isZiYingFlag == 1 && [model.orderStatus integerValue] == 2) {
        isSelf = YES;
    }
    
    // 取消订单请求
    [self.detailService cancelOrderWithOrderId:model  isSelf:isSelf type:type reason:str success:^(NSString *reason) {
        //
        @strongify(self);
        if (model.payTypeId) {
            if (model.payTypeId.integerValue == 17) {
                [self toast:@"订单取消成功，1药贷额度预计2个工作日恢复"];
            } else {
                [self toast:reason];
            }
        } else {
            [self toast:reason];
        }
        
        [self requestData];
    } failure:^(NSString *reason) {
        @strongify(self);
        if (isSelf) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else {
            [self toast:reason];
        }
    }];
}

- (void)addBIRecordWithItemName:(NSString *)itemName  itemPosition:(NSInteger)itemPosition {
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I9200" itemPosition:STRING_FORMAT(@"%zd", itemPosition) itemName:itemName itemContent:self.orderModel.orderId itemTitle:nil extendParams:nil viewController:self];
}

@end
