//
//  FKYProductionBaseInfoController.m
//  FKY
//
//  Created by mahui on 15/11/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

// Controller
#import "FKYProductionBaseInfoController.h"
// View
#import "FKYScrollViewCell.h"
#import "FKYProductAlertView.h"
#import "FKYGiftActionSheetView.h"
#import "FKYFullGiftActionSheetView.h"
#import "FKYUserHandleToast.h"
// Model
#import "CartPromotionModel.h"
#import "FKYProductObject.h"
#import "FKYFullGiftActionSheetModel.h"
// Protocol
#import "FKYAccountSchemeProtocol.h"
#import "FKYShopSchemeProtocol.h"
// Business
#import "FKYProductDetailManage.h"
#import "FKYProductionDetailService.h"
// Others
#import "FKYNavigator.h"
#import "NSString+Size.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
// Swift
#import "FKY-Swift.h"


@interface FKYProductionBaseInfoController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *sectionType;

// 不需要每次都去计算cell高度，一旦显示后，基本不会变；除非数据源有更新，需要刷新
//@property (nonatomic, assign) CGFloat couponCellHeight;         // 优惠券楼层cell高度缓存
//@property (nonatomic, strong) NSIndexPath *indexPath4Coupon;    // 优惠券楼层cell的indexpath

// 当前弹出视图必须以当前vc的属性的形式进行引用，否则弹出后会自动释放~!@
@property (nonatomic, strong) PDDiscountPriceInfoVC *discountPriceVC;
@property (nonatomic, strong) FKYPopComCouponVC *comCouponVC;

@property (nonatomic, strong) PDRecommendCell *recommendView;

/// 套餐优惠入口
@property (nonatomic,strong)FKYDiscountPackageViewModel *discountEntryViewModel;

/// 是否已经上报了套餐优惠的入口曝光
@property (nonatomic,assign)BOOL isUploadedDiscountEntryBI;

@end


@implementation FKYProductionBaseInfoController

#pragma mark - LifeCircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUploadedDiscountEntryBI = false;
    [self p_setupData];
    [self p_setupUI];
    [self requestDiscountPackageEntryInfo];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addDiscountBaoGuangBi) object:nil];
}
#pragma mark - 事件响应
-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"goInDiscountPackage"]) {// 套餐优惠入口
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I0004" itemPosition:@"1" itemName:self.discountEntryViewModel.discountPackage.name  itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
        FKYDiscountPackageModel *entryModel = (FKYDiscountPackageModel *)userInfo[FKYUserParameterKey];
        [(AppDelegate *)[UIApplication sharedApplication].delegate p_openPriveteSchemeString:entryModel.jumpInfo];
    }else if ([eventName isEqualToString:@"wasShowDiscountPackageEntry"]){// 已经展示了套餐优惠入口
        [self performSelector:@selector(addDiscountBaoGuangBi) withObject:nil afterDelay:3];
    }
}

#pragma mark - Private

- (void)p_setupData
{
    // 楼层数据源
    self.sectionType = [NSMutableArray arrayWithArray:[FKYProductDetailManage getListForCellType]];
    
    // 初次打开不展示优惠券panel
    FKYCouponSheetView.PRODUCTDETAIL_REOPEN_FLAG_INDEX = -1;
}

- (void)p_setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mainTableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundView = nil;
        view.backgroundColor = UIColorFromRGB(0xf4f4f4);
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.tableHeaderView = nil;
        view.tableFooterView = nil;
        view.bounces = true;
        view.estimatedRowHeight = 100;
        view.rowHeight = UITableViewAutomaticDimension;
        //        view.rowHeight = UITableViewAutomaticDimension;
        //        view.estimatedRowHeight = 44;
        [view registerClass:[FKYScrollViewCell class] forCellReuseIdentifier:@"FKYScrollViewCell"];
        [view registerClass:[PDPriceCell class] forCellReuseIdentifier:@"PDPriceCell"];
        [view registerClass:[PDNoBuyCell class] forCellReuseIdentifier:@"PDNoBuyCell"];
        [view registerClass:[PDNameCell class] forCellReuseIdentifier:@"PDNameCell"];
        [view registerClass:[PDDescriptionCell class] forCellReuseIdentifier:@"PDDescriptionCell"];
        [view registerClass:[PDLimitCell class] forCellReuseIdentifier:@"PDLimitCell"];
        [view registerClass:[PDDateCell class] forCellReuseIdentifier:@"PDDateCell"];
        [view registerClass:[PDCosmeticsCell class] forCellReuseIdentifier:@"PDCosmeticsCell"];
        [view registerClass:[PDStockCell class] forCellReuseIdentifier:@"PDStockCell"];
        [view registerClass:[PDCouponCell class] forCellReuseIdentifier:@"PDCouponCell"];
        [view registerClass:[PDPromotionTitleCell class] forCellReuseIdentifier:@"PDPromotionTitleCell"];
        [view registerClass:[PDPromotionCell class] forCellReuseIdentifier:@"PDPromotionCell"];
        [view registerClass:[PDGroupListCell class] forCellReuseIdentifier:@"PDGroupListCell"];
        [view registerClass:[PDShopCell class] forCellReuseIdentifier:@"PDShopCell"];
        [view registerClass:[PDRecommendCell class] forCellReuseIdentifier:@"PDRecommendCell"];
        [view registerClass:[PDEmptyCell class] forCellReuseIdentifier:@"PDEmptyCell"];
        [view registerClass:[PDWhiteEmptyCell class] forCellReuseIdentifier:@"PDWhiteEmptyCell"];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        if (@available(iOS 11.0, *)) {
            view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.parentViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
        view;
    });
    
}

// 在tableview展示后才能取到优惠券cell的最终高度，故此时再更新对应的优惠券cell
// 有限制：tableview已展示，且当前优惠券cell显示在屏幕上，才会取到内容高度；否则取的高度为0。
//- (void)updateCouponContentHeight
//{
//    if ([FKYProductDetailManage showCouponCell:self.productModel] && self.indexPath4Coupon) {
//        // 需显示优惠券入口
//        PDCouponCell *cell4Coupon = [self.mainTableView cellForRowAtIndexPath:self.indexPath4Coupon];
//        self.couponCellHeight = [cell4Coupon getCollectionviewContentHeight];
//        [self.mainTableView reloadRowsAtIndexPaths:@[self.indexPath4Coupon] withRowAnimation:UITableViewRowAnimationNone];
//    }
//}

// 弹出优惠券列表视图
- (void)showCouponSheet
{
    NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
    NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
    [self.comCouponVC configCouponViewController:enterpriseId spuCode:spuCode];
    NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
    // 埋点
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"6" itemName:@"优惠券" itemContent:nil itemTitle:nil extendParams:dic viewController: self];
}

// 弹出折后价详情视图
- (void)showDiscountPriceDetail
{
    if (self.productModel && self.productModel.discountInfo) {
        // 显示弹出视图
        self.discountPriceVC.pModel = self.productModel.discountInfo;
        [self.discountPriceVC showOrHidePopView:YES];
        // 埋点
        NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"基本信息" itemId:@"I6105" itemPosition:@"2" itemName:@"折后价" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
    }
    else {
        // 无折后价信息model
        NSLog(@"无折后价信息model");
    }
}


#pragma mark - Public

// 刷新
- (void)showContent
{
    [self.mainTableView reloadData];
    
}

// 刷新
- (void)refreshContentForList
{
    //    if (@available(iOS 11, *)) {
    //        [self.mainTableView performBatchUpdates:^{
    //            //
    //        } completion:^(BOOL finished) {
    //            //
    //        }];
    //    }
    //    else {
    //        [self.mainTableView beginUpdates];
    //        [self.mainTableView endUpdates];
    //    }
    
    if ([FKYProductDetailManage showRecommendCell:self.productModel]) {
        CGFloat height = [FKYProductDetailManage getRecommendCellHeight:self.productModel];
        self.recommendView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        [self.recommendView configCell:self.productModel.recommendModel.hotSell];
        self.mainTableView.tableFooterView = self.recommendView;
    }
    else {
        self.mainTableView.tableFooterView = nil;
    }
    
    [self.mainTableView reloadData];
}

// 更新数据后，刷新界面...<不再使用>
//- (void)showContent
//{
//    // 每次更新数据源并刷新界面时，均重置
//    self.couponCellHeight = 0;
//
//    [self.mainTableView reloadData];
//
//    // 更新优惠券cell楼层高度
//    [self updateCouponContentHeight];
//}

- (void)updateContentHeight:(BOOL)showFlag
{
    CGFloat bottomViewHeight = 64;
    CGFloat navigationBarHeight = 64;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomViewHeight += iPhoneX_SafeArea_BottomInset;
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
        }
    }
    
    CGFloat height = showFlag ? (SCREEN_HEIGHT - FKYWH(bottomViewHeight) - FKYWH(navigationBarHeight) - FKYWH(32)) : (SCREEN_HEIGHT - FKYWH(bottomViewHeight) - FKYWH(navigationBarHeight));
    self.mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
}

- (void)setContentHeight:(CGFloat)height
{
    self.mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
}

- (void)resetProductTableOffset
{
    [self.mainTableView setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Request

/// 商详上报后台游览数据《李瑞安》
-(void)upLoadViewData{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        return;
    }
    if (self.productModel == nil || self.productModel.spuCode == nil || self.productModel.sellerCode == nil) {
        return;
    }
    NSDictionary *param = @{@"enterpriseId":[FKYLoginAPI currentUser].ycenterpriseId,@"spuCode":self.productModel.spuCode,@"sellerCode":self.productModel.sellerCode};
    [[FKYRequestService sharedInstance] upLoadViewDataWithParam:param completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        
    }];
    
}

/// 请求套餐优惠入口
- (void)requestDiscountPackageEntryInfo{
    MJWeakSelf
    [self.discountEntryViewModel requestDiscountPackageInfoWithBlock:^(BOOL isSuccess, NSString * _Nonnull msg) {
        if (!isSuccess) {
            [weakSelf toast:msg];
            return;
        }
        [weakSelf.mainTableView reloadData];
    }];
}

// 请求满赠数据
- (void)requestForFullGiftInfo:(ProductPromotionInfo *)promotion
{
    if (promotion && promotion.promotionId) {
        // 有促销id
        //self.mainTableView.userInteractionEnabled = false;
        [self showLoading];
        // 发请求
        @weakify(self);
        [FKYProductionDetailService requestProductFullGiftInfo:promotion.promotionId success:^(BOOL mutiplyPage, id data) {
            // 成功
            @strongify(self);
            //self.mainTableView.userInteractionEnabled = true;
            [self dismissLoading];
            // 数组list
            NSArray<FKYFullGiftActionSheetModel *> *list = @[];
            if (data && [data isKindOfClass:NSArray.class]) {
                list = data;
            }
            // 弹窗
            FKYFullGiftActionSheetView *view = [[FKYFullGiftActionSheetView alloc] initWithContentArray:list andText:promotion.description];
            [view showInView:[[[UIApplication sharedApplication] delegate] window]];
        } falure:^(NSString *reason, id data) {
            // 失败
            @strongify(self);
            //self.mainTableView.userInteractionEnabled = true;
            [self dismissLoading];
            if (reason && reason.length > 0) {
                [self toast:reason];
            }
            // 弹窗
            FKYFullGiftActionSheetView *view = [[FKYFullGiftActionSheetView alloc] initWithContentArray:@[] andText:promotion.description];
            [view showInView:[[[UIApplication sharedApplication] delegate] window]];
        }];
    }
    else {
        // 无促销id
        [self toast:@"数据异常"];
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionType.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PDCellType type = ((NSNumber *)self.sectionType[section]).integerValue;
    if (type == PDCellTypeFullReduce) {
        // 满减
        return [self.productModel promotionCount];
    }
    else if (type == PDCellTypeFullGift) {
        // 满赠
        return [self.productModel fullGiftCount];
    }
    else if (type == PDCellTypeFullDiscount) {
        // 满折
        return [self.productModel fullDiscountCount];
    }
    else {
        // 其它...<非促销>
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDCellType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    
    if (type == PDCellTypeBanner) {
        // 轮播图
        return [FKYProductDetailManage getBannerCellHeight:self.productModel];
    }
    if (type == PDCellTypePrice) {
        // 价格
        return [FKYProductDetailManage getPriceCellHeight:self.productModel];
    }
    if (type == PDCellTypeNoBuy) {
        // 不可购买及缺少经营范围
        return [FKYProductDetailManage getNoBuyCellHeight:self.productModel];
    }
    if (type == PDCellTypeWhiteEmptyNoPrice) {
        //
        if ([FKYProductDetailManage showPriceCell:self.productModel]) {
            // 有价格时不显示
            return CGFLOAT_MIN;
        } else {
            // 无价格时显示
            return FKYWH(5);
        }
    }
    if (type == PDCellTypeName) {
        // 名称
        //[FKYProductDetailManage getNameCellHeight:self.productModel];
        //return [PDNameCell getContentHeight:self.productModel];
        if (self.productModel != nil) {
            return self.mainTableView.rowHeight;
        }
    }
    if (type == PDCellTypeTitle) {
        // 标题
        return [FKYProductDetailManage getTitleCellHeight:self.productModel];
    }
    if (type == PDCellTypeLimit) {
        // 限购
        return [FKYProductDetailManage getLimitCellHeight:self.productModel];
    }
    if (type == PDCellTypeDate) {
        // 限购
        return [FKYProductDetailManage getBaseInfoCellHeight:self.productModel];
        // return tableView.rowHeight;
    }
    if (type == PDCellTypeCosmetics) {
        // 化妆品说明
        return [FKYProductDetailManage getCosmeticsCellHeight:self.productModel];
    }
    if (type == PDCellTypeStock) {
        // 库存
        return [FKYProductDetailManage getStockCellHeight:self.productModel];
    }
    if (type == PDCellTypeEmptyCoupon) {
        // 优惠券上方空行
        if ([FKYProductDetailManage showCouponCell:self.productModel]) {
            return FKYWH(10);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeCoupon) {
        // 优惠券
        if ([FKYProductDetailManage showCouponCell:self.productModel]) {
            //return [FKYProductDetailManage calculateCouponCellHeight:self.productModel];
            //            if (self.couponCellHeight < FKYWH(40)) {
            //                self.couponCellHeight = [FKYProductDetailManage calculateCouponCellHeight:self.productModel];
            //            }
            //return self.couponCellHeight;
            return [FKYProductDetailManage getCouponCellHeight:self.productModel];
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeEmptyPromotion) {
        // 促销上方分隔行
        if ([FKYProductDetailManage showPromotionCell:self.productModel]) {
            return FKYWH(10);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypePromotionTitle) {
        // 促销标题（隐藏）
        //        if ([FKYProductDetailManage showPromotionCell:self.productModel]) {
        //            return FKYWH(35);
        //        } else {
        //            return CGFLOAT_MIN;
        //        }
        return CGFLOAT_MIN;
    }
    if (type == PDCellTypeSlowPayOrHoldPrice) {
        // 慢必赔or保价
        if (self.productModel.slowPay == true || self.productModel.holdPrice == true) {
            return FKYWH(42);
        }
        return CGFLOAT_MIN;
    }
    if (type == PDCellTypeVip) {
        // vip...<促销>
        if ([FKYProductDetailManage showPromotionVipCell:self.productModel]) {
            return FKYWH(42);
        }
        return CGFLOAT_MIN;
    }
    if (type == PDCellTypePackageRate) {
        // 单品包邮...<促销>
        if ([FKYProductDetailManage showPromotionEntranceInfoCell:self.productModel entranceType:@(1)]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeFullReduce) {
        // 满减...<促销>
        if ([FKYProductDetailManage showPromotionFullReduceCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeFullGift) {
        // 满赠...<促销>
        if ([FKYProductDetailManage showPromotionFullGiftCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeBounty) {
        // 奖励金...<促销>
        if ([FKYProductDetailManage showPromotionBountyCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    
    if (type == PDCellTypeRebate) {
        // 返利...<促销>
        if ([FKYProductDetailManage showPromotionRebateCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeCombo) {
        // 套餐...<促销>
        if ([FKYProductDetailManage showPromotionComboCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeFullDiscount) {
        // 满折...<促销>
        if ([FKYProductDetailManage showPromotionFullDiscountCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeProtocolRebate) {
        // 协议返利金...<促销>
        if ([FKYProductDetailManage showPromotionProtocolRebateCell:self.productModel]) {
            return FKYWH(42);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeEmptyGroup) {
        // 套餐上方分隔行
        if ([FKYProductDetailManage showGroupCell:self.productModel]) {
            return FKYWH(10);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeGroup) {
        // 套餐
        return [FKYProductDetailManage getGroupCellHeight:self.productModel];
    }
    if (type == PDCellTypeShop) {
        // 店铺(供应商)
        return [FKYProductDetailManage getShopCellHeight:self.productModel withDiscountModel:self.discountEntryViewModel.discountPackage];
    }
    if (type == PDCellTypeEmptyHotSale) {
        // 同品热卖上方分隔行
        if ([FKYProductDetailManage showRecommendCell:self.productModel]) {
            // 显示供应商
            return FKYWH(10);
        } else {
            return CGFLOAT_MIN;
        }
    }
    if (type == PDCellTypeRecommend) {
        // 同品热卖
        return [FKYProductDetailManage getRecommendCellHeight:self.productModel];
    }
    if (type == PDCellTypeEmpty) {
        // 空行
        return FKYWH(10);
    }
    if (type == PDCellTypeWhiteEmpty) {
        // 白底空行
        return FKYWH(5);
    }
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDCellType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    if (type == PDCellTypeBanner) {
        //MARK:轮播图
        FKYScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYScrollViewCell" forIndexPath:indexPath];
        [cell configCell:self.productModel.picsInfo];
        // 查看大图
        @weakify(self);
        cell.clickDetailPicBlock = ^{
            @strongify(self);
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"商品图" itemId:@"I6102" itemPosition:@"1" itemName:@"商品大图" itemContent:nil itemTitle:nil extendParams:pageValue viewController:self];
            
        };
        // 不再显示老版同品推荐
        [cell configRecommendView:false block:nil];
        return cell;
    }
    else if (type == PDCellTypeNoBuy) {
        //MARK:不可购买之缺少经营范围
        PDNoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNoBuyCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypePrice) {
        // MARK:价格
        PDPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPriceCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        // 查看折后价
        @weakify(self);
        cell.showDetailBlock = ^{
            @strongify(self);
            [self showDiscountPriceDetail];
        };
        cell.lowPriceNoticeBlock= ^{
            //降价通知
            @strongify(self);
            if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
                // 未登录
                if (self.loginActionBlock) {
                    self.loginActionBlock();
                }
               // [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:nil isModal:YES animated:YES];
            }
            else {
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_PDLowPriceNoticeVC) setProperty:^(PDLowPriceNoticeVC *destinationViewController) {
                    @strongify(self);
                    destinationViewController.productObject = self.productModel;
                }];
            }
        };
        return cell;
    }else if (type == PDCellTypeName) {
        // MARK:名称
        PDNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNameCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypeTitle) {
        // MARK:标题(描述)
        PDDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDDescriptionCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypeLimit) {
        // MARK:特价限购描述 & 限购
        PDLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDLimitCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypeDate) {
        //MARK: 基本信息...<包括生产厂家、批准文号、有效期至、生产日期>
        PDDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDDateCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        // 查看说明
        @weakify(self);
        cell.showDetailBlock = ^{
            @strongify(self);
            // 埋点
            NSDictionary *pageValue = [NSDictionary dictionaryWithObjectsAndKeys:STRING_FORMAT(@"%@|%@", self.productModel.sellerCode, self.productModel.spuCode),@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:nil itemId:@"I6116" itemPosition:@"1" itemName:@"近效期" itemContent:nil itemTitle:nil extendParams:pageValue viewController: self];
            // 弹层
            [FKYUserHandleToast showInView:[[[UIApplication sharedApplication] delegate] window] withShopName:self.productModel.sellerName animationCompletion:nil];
        };
        return cell;
    }
    else if (type == PDCellTypeCosmetics) {
        // MARK:化妆品说明cell
        PDCosmeticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDCosmeticsCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypeStock) {
        //MARK: 库存量 & 最小拆零包装
        PDStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDStockCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        return cell;
    }
    else if (type == PDCellTypeShop) {
        //MARK:店铺(供应商)
        PDShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDShopCell" forIndexPath:indexPath];
        //        [cell configCell:self.productModel,discountModel:];
        //        [cell configCell:<#(FKYProductObject * _Nullable)#>]
        [cell configCell:self.productModel :self.discountEntryViewModel.discountPackage];
        @weakify(self);
        // 跳转店铺
        cell.shopDetailClosure = ^{
            @strongify(self);
            
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
            // 埋点
            NSString *shopid = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
            if (self.productModel.recommendModel.enterpriseInfo != nil &&self.productModel.recommendModel.enterpriseInfo.enterpriseId != nil){
                shopid = [NSString stringWithFormat:@"%@", self.productModel.recommendModel.enterpriseInfo.enterpriseId];
            }
            NSString *userid = @"";
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",self.productModel.sellerCode,self.productModel.spuCode],@"pageValue", nil];
            if (self.productModel.recommendModel.enterpriseInfo != nil &&self.productModel.recommendModel.enterpriseInfo.zhuanquTag == true){
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"商家模块" itemId:@"I6110" itemPosition:@"0" itemName:@"进入JBP专区" itemContent:shopid itemTitle:nil extendParams:extentDic viewController: self];
            }else{
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"商家模块" itemId:@"I6110" itemPosition:@"0" itemName:@"进入店铺" itemContent:shopid itemTitle:nil extendParams:extentDic viewController: self];
            }
            
            // 百度移动统计之事件统计
            
            if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
                userid = (FKYLoginAPI.currentUserId ? FKYLoginAPI.currentUserId : @"");
            }
            //[[BaiduMobStat defaultStat] logEvent:@"pd_shop" eventLabel:@"商详之进入店铺" attributes:@{@"shopid": shopid, @"userid": userid}];
        };
        // 跳转商详
        cell.productDetailClosure = ^(NSInteger index, NSString *pid, NSString *vid){
            @strongify(self);
            // 跳转
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
                // pid: 商品spuCode vid:供应商ID
                destinationViewController.productionId = pid;
                destinationViewController.vendorId = vid;
            }];
            // 埋点
            NSString *itemID = @"I6110";
            NSString *itemPosition = [NSString stringWithFormat:@"%ld", index+1];
            NSString *itemName = @"点进商详";
            NSString *itemContent = [NSString stringWithFormat:@"%@|%@", vid, pid];
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",self.productModel.sellerCode,self.productModel.spuCode],@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"商家模块" itemId:itemID itemPosition:itemPosition itemName:itemName itemContent:itemContent itemTitle:nil extendParams:extentDic viewController:self];
            
            // 百度移动统计之事件统计
           // NSString *shopid = (vid ? vid : @"");
            //NSString *productid = (pid ? pid : @"");
           // [[BaiduMobStat defaultStat] logEvent:@"pd_shop_product" eventLabel:@"商详店铺之跳转商详" attributes:@{@"shopid": shopid, @"productid": productid}];
        };
        return cell;
    }
    else if (type == PDCellTypeRecommend) {
        // 同品热卖
        PDRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDRecommendCell" forIndexPath:indexPath];
        [cell configCell:self.productModel.recommendModel.hotSell];
        // 跳转商详
        @weakify(self);
        cell.productDetailClosure = ^(NSInteger index, NSString *pid, NSString *vid){
            @strongify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
                // pid: 商品spuCode vid:供应商ID
                destinationViewController.productionId = pid;
                destinationViewController.vendorId = vid;
            }];
            // 埋点
            NSString *itemID = @"I6111";
            NSString *itemPosition = [NSString stringWithFormat:@"%ld", index+1];
            NSString *itemName =  @"点进商详";
            NSString *itemContent = [NSString stringWithFormat:@"%@|%@", vid, pid];
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",self.productModel.sellerCode,self.productModel.spuCode],@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"同品热卖" itemId:itemID itemPosition:itemPosition itemName:itemName itemContent:itemContent itemTitle:nil extendParams:extentDic viewController: self];
        };
        return cell;
    }
    else if (type == PDCellTypeEmpty || type == PDCellTypeEmptyGroup || type == PDCellTypeEmptyPromotion || type == PDCellTypeEmptyCoupon) {
        // 空行
        PDEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDEmptyCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (type == PDCellTypeWhiteEmpty || type == PDCellTypeWhiteEmptyNoPrice) {
        // 白底空行
        PDWhiteEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDWhiteEmptyCell" forIndexPath:indexPath];
        [cell configCell:self.productModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (type == PDCellTypePromotionTitle) {
        // 促销标题（隐藏）
        PDPromotionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionTitleCell" forIndexPath:indexPath];
        //        if ([FKYProductDetailManage showPromotionCell:self.productModel]) {
        //            [cell configCell:@"促销"];
        //        } else {
        //            [cell configCell:nil];
        //        }
        [cell configCell:nil];
        return cell;
    }else if (type == PDCellTypeSlowPayOrHoldPrice){
        //慢必赔or保价
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if (self.productModel.slowPay == true || self.productModel.holdPrice == true) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeSlowPayOrHoldPrice];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeSlowPayOrHoldPrice];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeVip) {
        // MARK:vip...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionVipCell:self.productModel]) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeVip];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeVip];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypePackageRate) {
        // MARK:单品包邮
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionEntranceInfoCell:self.productModel entranceType:@(1)])  {
            [cell configEntranceCell:self.productModel entranceType:@(1)];
        } else {
            [cell configEntranceCell:nil entranceType:@(1)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeFullReduce) {
        // MARK:满减...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionFullReduceCell:self.productModel]) {
            ProductPromotionInfo *promotionModel = [self.productModel promotionModelForIndex:indexPath];
            [cell configCell:self.productModel promotion:promotionModel type:PDPromotionTypeFullReduce];
            if (promotionModel.promotionType.intValue == CartPromotionType_DuoPinMJ) {
                // 多品满减
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            else {
                // 单品满减
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeFullReduce];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        return cell;
    }
    else if (type == PDCellTypeFullGift) {
        // MARK:满赠...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionFullGiftCell:self.productModel]) {
            ProductPromotionInfo *promotionModel = [self.productModel fullGiftModelForIndex:indexPath];
            [cell configCell:self.productModel promotion:promotionModel type:PDPromotionTypeFullGift];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeFullGift];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    if (type == PDCellTypeBounty) {
        // MARK:奖励金...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionBountyCell:self.productModel]) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeBounty];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeBounty];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeRebate) {
        // MARK:返利...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionRebateCell:self.productModel]) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeRebate];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeRebate];
        }
        if (self.productModel && self.productModel.rebateInfo.isRebate && self.productModel.rebateInfo.isRebate.integerValue == 1 && self.productModel.rebateInfo.ruleType.intValue == 2) {
            // 多品返利
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else {
            // 单品返利
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (type == PDCellTypeCombo) {
        // MARK: 套餐...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionComboCell:self.productModel]) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeCombo];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeCombo];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeFullDiscount) {
        //MARK: 满折...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionFullDiscountCell:self.productModel]) {
            ProductPromotionInfo *promotionModel = [self.productModel fullDiscountModelForIndex:indexPath];
            [cell configCell:self.productModel promotion:promotionModel type:PDPromotionTypeFullDiscount];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeFullDiscount];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeProtocolRebate) {
        // MARK:协议返利金...<促销>
        PDPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDPromotionCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showPromotionProtocolRebateCell:self.productModel]) {
            [cell configCell:self.productModel promotion:nil type:PDPromotionTypeProtocolRebate];
        } else {
            [cell configCell:nil promotion:nil type:PDPromotionTypeProtocolRebate];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeCoupon) {
        //MARK: 优惠券...<入口>
        //self.indexPath4Coupon = indexPath;
        PDCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDCouponCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showCouponCell:self.productModel]) {
            [cell configCell:YES couponList:self.productModel.couponList];
        } else {
            [cell configCell:NO couponList:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else if (type == PDCellTypeGroup) {
        // MARK:套餐...<入口>
        PDGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDGroupListCell" forIndexPath:indexPath];
        if ([FKYProductDetailManage showGroupCell:self.productModel]) {
            [cell configCell:self.productModel.dinnerInfo.dinnerList[0]];
        } else {
            [cell configCell:nil];
        }
        @weakify(self);
        // 弹出套餐详情视图
        cell.detailCallback = ^{
            @strongify(self);
            if (self.showGroupViewBlock) {
                NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
                NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
                NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"套餐" itemId:@"I6103" itemPosition:@"1" itemName:@"查看详情" itemContent:nil itemTitle:nil extendParams:dic viewController: self];
                if ([FKYProductDetailManage showGroupCell:self.productModel]) {
                    self.showGroupViewBlock([self.productModel.dinnerInfo.dinnerList[0] promotionName]);
                } else {
                    self.showGroupViewBlock(@"");
                }
            }
        };
        // 查看商品详情
        cell.showProductCallBack = ^(FKYProductGroupItemModel *product){
            @strongify(self);
            // 弹出套餐详情视图
            if (self.showGroupViewBlock) {
                NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
                NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
                NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
                [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"套餐"  itemId:@"I6103" itemPosition:@"2" itemName:@"点击商品" itemContent:nil itemTitle:nil extendParams:dic viewController: self];
                if ([FKYProductDetailManage showGroupCell:self.productModel]) {
                    self.showGroupViewBlock([self.productModel.dinnerInfo.dinnerList[0] promotionName]);
                } else {
                    self.showGroupViewBlock(@"");
                }
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        PDEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDEmptyCell" forIndexPath:indexPath];
        [cell configCell:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PDCellType type = ((NSNumber *)self.sectionType[indexPath.section]).integerValue;
    @weakify(self);
    if (type == PDCellTypeCoupon) {
        // 优惠券
        [self showCouponSheet];
    }else if (type == PDCellTypeSlowPayOrHoldPrice){
        //慢必赔or保价
        if ((self.productModel.slowPay == true && self.productModel.slowPayUrl.length > 0) || (self.productModel.holdPrice == true && self.productModel.holdPriceUrl.length > 0 )) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                @strongify(self);
                if (self.productModel.slowPay == true) {
                    // 慢必赔
                    destinationViewController.urlPath = self.productModel.slowPayUrl;
                }else if (self.productModel.holdPrice == true){
                    // 保价
                    destinationViewController.urlPath = self.productModel.holdPriceUrl;
                }
            }];
        }
    }else if (type == PDCellTypeVip) {
        // <促销>vip
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
            @strongify(self);
            if (self.productModel.vipModel.vipSymbol == 0) {
                // 了解会员
                destinationViewController.urlPath = API_VIP_INTRODUCTION_H5;
            }
            else if (self.productModel.vipModel.vipSymbol == 1) {
                // 会员专区
                if (self.productModel.vipModel.url && self.productModel.vipModel.url.length > 0) {
                    destinationViewController.urlPath = self.productModel.vipModel.url;
                }
                else {
                    destinationViewController.urlPath = API_VIP_PRODUCT_LIST_H5;
                }
            }
        }];
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        // 埋点
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"4" itemName:@"会员" itemContent:nil itemTitle:nil extendParams:dic viewController: self];
    }else if (type == PDCellTypePackageRate) {
        // MARK:单品包邮
        if ([self.productModel getEntranceInfoObject:@(1)] != nil){
            NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
            NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
            NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"11" itemName:@"单品包邮" itemContent:nil itemTitle:nil extendParams:dic viewController: self];
            FKYProductEntranceInfoObject *entranceInfoObject = [self.productModel getEntranceInfoObject:@(1)];
            [(AppDelegate *)[UIApplication sharedApplication].delegate p_openPriveteSchemeString:entranceInfoObject.jumpUrl];
        }
    }
    else if (type == PDCellTypeFullReduce) {
        // <促销>满减
        ProductPromotionInfo *promotionModel = [self.productModel promotionModelForIndex:indexPath];
        if ([promotionModel.promotionType intValue] == CartPromotionType_DuoPinMJ){
            // 3:多品满减
            @weakify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItemOld) setProperty:^(ShopItemOldViewController *destinationViewController) {
                //
                @strongify(self);
                destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
                destinationViewController.promotionId = [NSString stringWithFormat:@"%@", promotionModel.promotionId];
                destinationViewController.type = 2;
                //destinationViewController.promotionModel = promotionInfo;
            }];
            // 埋点
            NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
            NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
            NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"1" itemName:@"满减" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
        }
        
    }
    else if (type == PDCellTypeFullGift) {
        // <促销>满赠
        ProductPromotionInfo *promotionModel = [self.productModel fullGiftModelForIndex:indexPath];
        if ([promotionModel.promotionType intValue] ==  CartPromotionType_DanPinMZ){
            // 5:单品满赠
            [self requestForFullGiftInfo:promotionModel];
        }else if ([promotionModel.promotionType intValue] == CartPromotionType_DuoPinMZ){
            // 6:多品满赠)
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItemOld) setProperty:^(ShopItemOldViewController *destinationViewController) {
                //满赠
                destinationViewController.promotionId = [NSString stringWithFormat:@"%@", promotionModel.promotionId];
                destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
                destinationViewController.type = 3;
            }];
        }
        // 埋点
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"2" itemName:@"满赠" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
    }
    else if (type == PDCellTypeBounty) {
        // <促销>奖励金 跳到药福利;
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_FKYYflIntroDetailViewController) setProperty:^(id destinationViewController) {
        }];
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"10" itemName:@"药福利奖励金" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
    }
    else if (type == PDCellTypeCombo) {
        // <促销>套餐...<点击可进入该商品所在店铺的套餐专区>
        @weakify(self);
        if([FKYProductDetailManage isFixedComboView:self.productModel]){
            //固定套餐
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ComboList) setProperty:^(FKYComboListViewController *destinationViewController) {
                @strongify(self);
                destinationViewController.sellerCode = self.productModel.sellerCode.integerValue;
                destinationViewController.enterpriseName = self.productModel.sellerName;
                destinationViewController.spuCode = self.productModel.spuCode;
            } isModal:nil animated:YES];
        }else {
            //搭配套餐
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MatchingPackageVC) setProperty:^(FKYMatchingPackageVC *destinationViewController) {
                @strongify(self);
                destinationViewController.spuCode = self.productModel.spuCode;
                destinationViewController.enterpriseId = [NSString stringWithFormat:@"%@",self.productModel.sellerCode];
            }];
        }
        // 埋点
        NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
        NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
        NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
        [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"3" itemName:@"套餐" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
    }
    else if (type == PDCellTypeRebate) {
        // <促销>返利...<多品返利点击进入返利专区>
        if (self.productModel && self.productModel.rebateInfo.isRebate && self.productModel.rebateInfo.isRebate.integerValue == 1) {
            // 有返利
            if (self.productModel.rebateInfo.ruleType.integerValue == 2) {
                // 多品
                if (self.productModel.rebateInfo.rebateId && self.productModel.rebateInfo.rebateId > 0) {
                    // 有返回活动id
                    // 多品返利
                    @weakify(self);
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItemOld) setProperty:^(ShopItemOldViewController *destinationViewController) {
                        @strongify(self);
                        destinationViewController.type = 4;
                        destinationViewController.promotionId =[NSString stringWithFormat:@"%@",self.productModel.rebateInfo.rebateId];
                        destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
                    }];
                    // 埋点
                    NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
                    NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
                    NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
                    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"5" itemName:@"返利" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
                }
                else {
                    // 无返回活动id
                    [self toast:@"无活动id"];
                }
            }
            else {
                // 单品
            }
        }
        else {
            // 无返利
        }
    }
    else if (type == PDCellTypeProtocolRebate) {
        // 促销之协议奖励金
        if (self.productModel && self.productModel.rebateProtocol && self.productModel.rebateProtocol.protocolUrl && self.productModel.rebateProtocol.protocolUrl.length > 0) {
            // 埋点
            NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
            NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
            NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"8" itemName:@"协议返利金" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
            // 跳转H5
            @weakify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                @strongify(self);
                destinationViewController.urlPath = self.productModel.rebateProtocol.protocolUrl;
            }];
        }
        else {
            [self toast:@"跳转链接为空"];
        }
    }
    else if (type == PDCellTypeFullDiscount) {
        // 满折
        ProductPromotionInfo *promotion = [self.productModel fullDiscountModelForIndex:indexPath];
        if (!promotion) {
            return;
        }
        if (promotion.promotionType && promotion.promotionType.intValue == 16) {
            // 多品满折才跳转，单品满折不跳转
            @weakify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItemOld) setProperty:^(ShopItemOldViewController *destinationViewController) {
                @strongify(self);
                destinationViewController.shopId = [NSString stringWithFormat:@"%@", self.productModel.sellerCode];
                destinationViewController.promotionId = [NSString stringWithFormat:@"%@", promotion.promotionId];
                destinationViewController.type = 5;
            }];
            // 埋点
            NSString *spuCode = self.productModel.spuCode ? self.productModel.spuCode : @"";
            NSString *enterpriseId = self.productModel.sellerCode ? [NSString stringWithFormat:@"%ld", (long)self.productModel.sellerCode.integerValue] : @"";
            NSString *pageValue =  [NSString stringWithFormat:@"%@|%@",enterpriseId,spuCode];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageValue,@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"促销" itemId:@"I6104" itemPosition:@"7" itemName:@"满折" itemContent:nil itemTitle:nil extendParams:dic  viewController: self];
        }
    }
}
#pragma mark - BI埋点
- (void)addDiscountBaoGuangBi{
    if (self.isUploadedDiscountEntryBI == true){
        return;
    }
    NSLog(@"************埋点已上报****************");
    self.isUploadedDiscountEntryBI = true;
    [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:@"" sectionPosition:@"" sectionName:@"" itemId:@"I1999" itemPosition:@"" itemName:@"有效曝光" itemContent:@"" itemTitle:@"" extendParams:nil viewController:self];
}


#pragma mark - Property

-(FKYDiscountPackageViewModel *)discountEntryViewModel{
    if (!_discountEntryViewModel) {
        _discountEntryViewModel = [[FKYDiscountPackageViewModel alloc]init];
        _discountEntryViewModel.type = @"34";
    }
    return _discountEntryViewModel;
}

- (PDDiscountPriceInfoVC *)discountPriceVC
{
    if (!_discountPriceVC) {
        _discountPriceVC =  [[PDDiscountPriceInfoVC alloc] init];
        _discountPriceVC.popTitle = @"折后价说明";
    }
    return _discountPriceVC;
}

- (FKYPopComCouponVC *)comCouponVC
{
    if (!_comCouponVC) {
        _comCouponVC = [[FKYPopComCouponVC alloc] init];
    }
    return _comCouponVC;
}

- (PDRecommendCell *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[PDRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDRecommendCell"];
        // 跳转商详
        @weakify(self);
        _recommendView.productDetailClosure = ^(NSInteger index, NSString *pid, NSString *vid){
            @strongify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
                // pid: 商品spuCode vid:供应商ID
                destinationViewController.productionId = pid;
                destinationViewController.vendorId = vid;
            }];
            // 埋点
            NSString *itemID = @"I6111";
            NSString *itemPosition = [NSString stringWithFormat:@"%ld", index+1];
            NSString *itemName = @"点进商详";
            NSString *itemContent = [NSString stringWithFormat:@"%@|%@", vid, pid];
            NSDictionary *extentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",self.productModel.sellerCode,self.productModel.spuCode],@"pageValue", nil];
            [[FKYAnalyticsManager sharedInstance] BI_New_Record:nil floorPosition:nil floorName:nil sectionId:nil sectionPosition:nil sectionName:@"同品热卖" itemId:itemID itemPosition:itemPosition itemName:itemName itemContent:itemContent itemTitle:nil extendParams:extentDic viewController: self];
        };
    }
    return _recommendView;
}


@end
