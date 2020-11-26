//
//  FKYOrderDetailViewController.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYJSOrderDetailViewController.h"

#import "FKYAccountSchemeProtocol.h"
#import "FKYOrderService.h"
#import <Masonry/Masonry.h>

#import "FKYOrderDetailHeaderView.h"
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "FKYOrderCellFooter.h"
#import "FKYAlertView.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "FKYCartSchemeProtocol.h"
#import "FKYOrderModel.h"
#import "UIViewController+ToastOrLoading.h"
#import "FKYOrderProductModel.h"
#import "FKYOrderDetailFooterView.h"
#import "FKYOrderDetailViewController.h"

#import "FKYLeftRightLabelCell.h"
#import "FKY-Swift.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    DetailInfo,  // 订单信息
    ProductInfo, // 商品信息
    ReasonInfo,  // 原因
    AnswerInfo,  // 回答
    TotalMoney,  // 商品金额
    PayMoney,    // 支付金额
    ReduceMoney,  // 立减金额
};

@interface  FKYJSOrderDetailViewController() <UITableViewDataSource,
UITableViewDelegate,
FKYNavigationControllerDragBackDelegate
>

@property (nonatomic, strong)  UITableView *mainTableView;
@property (nonatomic, strong)  NSArray *orderDetailArr;
@property (nonatomic, strong)  NSString *phoneNum;
@property (nonatomic, assign)  BOOL buttonHidden;
@property (nonatomic, assign)  BOOL isOpen;
@property (nonatomic, strong)  FKYOrderModel *orderDetailModel;
@property (nonatomic, strong)  FKYOrderService *detailService;
@property (nonatomic, strong)  FKYDelayInfoModel *delayInfoModel;
@property (nonatomic, strong)  NSArray *sectionArr;
@property (nonatomic, strong)  UIView *markView;

@end

@implementation FKYJSOrderDetailViewController

- (void)loadView{
    [super loadView];
    [self p_createBar];
    [self createMarkView];
    [self p_createTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    if ([self.statusCode isEqualToString:@"900"]) {
        //补货
        self.sectionArr = @[@(DetailInfo),@(ProductInfo),@(TotalMoney),@(ReduceMoney),@(PayMoney),@(AnswerInfo)];
    }else{
        //拒收
        self.sectionArr = @[@(DetailInfo),@(ProductInfo),@(TotalMoney),@(ReduceMoney),@(PayMoney),@(ReasonInfo),@(AnswerInfo)];
    }
    [self requestData];
}
- (FKYOrderService *)detailService{
    if (!_detailService) {
        _detailService = [[FKYOrderService alloc] init];
    }
    return _detailService;
}

- (void)requestData{
    
    NSString *orderId = _orderModel.orderId;
    
    if ([self.statusCode isEqualToString:@"800"]) {
        //拒收
        orderId = _orderModel.orderId;
    }else if ([self.statusCode isEqualToString:@"900"]) {
        //补货
        if (_orderModel.originalDeliveryId.length) {
            orderId = _orderModel.originalDeliveryId;
        }else {
            orderId = _orderModel.exceptionOrderId;
        }
    }

    [self.detailService getOrderDetailWithOrderId:orderId
                                       statusCode:self.statusCode
                                          success:^(FKYOrderModel *model){
        self.orderDetailModel = model;
        [self.mainTableView reloadData];
    } failure:^(NSString *reason) {
        [self toast:reason];
    }];
    
}


- (void)createMarkView{
    self.markView = ({
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([self fky_NavigationBar].mas_bottom);
            make.left.right.equalTo(self.view);
            if ([self.statusCode isEqualToString:@"900"]) {
                make.height.equalTo(@(FKYWH(30)));
            }else{
                make.height.equalTo(@(FKYWH(0)));
            }
        }];
        if ([self.statusCode isEqualToString:@"900"]) {
            UILabel *label = [[UILabel alloc] init];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"此订单为商家对未发货的商品进行补货的订单";
            label.font = FKYSystemFont(FKYWH(12));
            label.textColor = UIColorFromRGB(0x333333);
            label.backgroundColor = UIColorFromRGB(0xfeefb8);

        }
        
        view;
    });
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
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    [self fky_NavigationBar].backgroundColor = [UIColor whiteColor];
    [self fky_setupNavigationBarWithTitle:@"订单详情"];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    [FKYNavigator sharedNavigator].topNavigationController.dragBackDelegate = self;
}

- (void)p_createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.markView.mas_bottom);
        }];
        tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[FKYJSOrderDetailInfoCell class] forCellReuseIdentifier:@"FKYJSOrderDetailInfoCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [tableView registerClass:[FKYJSOrderDetailRemarkCell class] forCellReuseIdentifier:@"FKYJSOrderDetailRemarkCell"];
        [tableView registerClass:[FKYLeftRightLabelCell class] forCellReuseIdentifier:@"FKYLeftRightLabelCell"];

        [tableView registerClass:[FKYJSOrderDetailProductInfoCell class] forCellReuseIdentifier:@"FKYJSOrderDetailProductInfoCell"];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
}

#pragma mark----tableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType type = ((NSNumber *)self.sectionArr[indexPath.section]).integerValue;
    switch (type) {
        case DetailInfo:
        {
            FKYJSOrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYJSOrderDetailInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            FKYJSOrderDetailInfoCellType type = FKYJSOrderDetailInfoCellTypeRejected;
            if (self.statusCode.integerValue > 800) {
                type = FKYJSOrderDetailInfoCellTypeReplenishment;
            }
            [cell configCellWithModel:self.orderDetailModel cellType:type];
            @weakify(self);
            cell.orderDetailClosure = ^{
                @strongify(self);
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderDetailController) setProperty:^(FKYOrderDetailViewController *destinationViewController) {
                    destinationViewController.orderModel = self->_orderModel;
                } isModal:NO animated:YES];
            };
            return cell;
        }
            break;
        case ProductInfo:
        {
            FKYOrderProductModel *model = self.orderDetailModel.productList[indexPath.row];
            FKYJSOrderDetailProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYJSOrderDetailProductInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCell:model batchModel:model.batchList.firstObject];
            return cell;
        }
            break;
        case TotalMoney:
        {
            FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:self.orderDetailModel andType:ProductsMoneyType];
            return cell;
        }
            break;
        case ReduceMoney:
        {
            FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:self.orderDetailModel andType:ReduceMoneyType];
            return cell;
        }
            break;
        case PayMoney:
        {
            FKYLeftRightLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYLeftRightLabelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:self.orderDetailModel andType:PayMoneyType];
            return cell;
        }
            break;
        default:
        {
            FKYJSOrderDetailRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYJSOrderDetailRemarkCell" forIndexPath:indexPath];
            if (type == ReasonInfo) {
                [cell configCellWithText:self.orderDetailModel type:FKYJSOrderDetailRemarkCellTypeReason];
            }
            if (type == AnswerInfo) {
                [cell configCellWithText:self.orderDetailModel type:FKYJSOrderDetailRemarkCellTypeAnswer];
            }
            return cell;
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionArr[section]).integerValue;

    if (type == ProductInfo) {
        return self.orderDetailModel.productList.count;
    }
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}

#pragma mark ----- tableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionArr[section]).integerValue;

    if (type == ProductInfo) {
        FKYJSOrderDetailHeaderView *view = (FKYJSOrderDetailHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYJSOrderDetailHeaderView"];
        if (view == nil) {
            view = [[FKYJSOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(140))];
        }
        [view configViewWithModel:self.orderDetailModel];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SectionType type = ((NSNumber *)self.sectionArr[section]).integerValue;

    if (type == ProductInfo) {
        
        FKYOrderDetailFooterView *view = (FKYOrderDetailFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FKYOrderDetailFooterView"];
        if (!view) {
            view = [[FKYOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(140))];
        }
        [view setValueForUnusualWithDetailModel:self.orderDetailModel];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType type = ((NSNumber *)self.sectionArr[indexPath.section]).integerValue;

    if (type == DetailInfo) {
        return FKYWH(110);
    }else if (type == ProductInfo){
        return FKYWH(115);
    }else if (type == ReasonInfo || type == AnswerInfo){
        return FKYWH(80);
    }else if(type == ReduceMoney){
        if (self.orderDetailModel.orderFullReductionMoney.floatValue > 0) {
            return FKYWH(45);
        }else{
            return FKYWH(0.001);
        }
    }else{
        return FKYWH(45);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SectionType type = ((NSNumber *)self.sectionArr[section]).integerValue;

    switch (type) {
        case ProductInfo:
            return FKYWH(44);
            break;
        case ReasonInfo:
            return FKYWH(10);
        case AnswerInfo:
            return FKYWH(10);
        default:
            return 0.0001;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SectionType type = ((NSNumber *)self.sectionArr[section]).integerValue;

    if (type == ProductInfo) {
        return FKYWH(40);
    }
    if (type == DetailInfo || type == ReasonInfo) {
        return FKYWH(10);
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionType type = ((NSNumber *)self.sectionArr[indexPath.section]).integerValue;

    if (type == ProductInfo) {
        FKYOrderProductModel *model = self.orderDetailModel.productList[indexPath.row];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
            destinationViewController.productionId = [NSString stringWithFormat:@"%@",model.productId];
            if (model.vendorId != nil) {
                destinationViewController.vendorId = [NSString stringWithFormat:@"%@", model.vendorId];
            }else{
                 destinationViewController.vendorId = [NSString stringWithFormat:@"%d",self.orderDetailModel.supplyId];
            }
        } isModal:NO animated:YES];
    }
}

- (BOOL)dragBackShouldStartInNavigationController:(FKYNavigationController *)navigationController {
    [[FKYNavigator sharedNavigator] pop];
    return NO;
}


@end
