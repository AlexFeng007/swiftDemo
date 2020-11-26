//
//  FKYCartMerchantInfoModel.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//
#import "FKYBaseModel.h"
#import <Foundation/Foundation.h>
#import "FKYProductGroupListInfoModel.h"

@protocol FKYBaseCellProtocol;


@interface FKYCartMerchantInfoModel: FKYBaseModel
@property (nonatomic, copy) NSString *shortWarehouseName; //自营仓名
@property (nonatomic, assign) BOOL couponFlag;    //    优惠券标识    boolean
@property (nonatomic, strong) NSNumber *discountAmount;    //   供应商订单折扣/满减金额    number    @mock=10
@property (nonatomic, strong) NSNumber *freeShippingAmount;    //   供应商包邮金额    number    @mock=2000
@property (nonatomic, strong) NSNumber *freeShippingNeed;    //   还差多少金额包邮    number
@property (nonatomic, strong) NSNumber *freight;    //    订单的运费，该运费是总运费,，还没有拆单的运费    number    @mock=10
@property (nonatomic, assign) BOOL checkedAll;    //    供应商下的商品是否全选    boolean
@property (nonatomic, strong) NSNumber *needAmount;    //    供应商起送金差额    number    @mock=0

@property (nonatomic, strong) NSNumber *supplyFreight;    //    供应商订单运费    number    @mock=10
@property (nonatomic, assign)int supplyId;    //     供应商ID    number    @mock=8353
@property (nonatomic, copy) NSString *supplyName;    //    供应商名称    string    @mock=广东壹号药业有限公司-ziying
@property (nonatomic, strong) NSNumber *supplySaleSill;    //    供应商起售门槛    number    @mock=1000
@property (nonatomic, strong) NSNumber *supplyType;    //     供应商类型（0：自营；1：MP商家）    number    @mock=0
@property (nonatomic, strong) NSNumber *totalAmount;    //     供应商订单总金额    number    @mock=1020
@property (nonatomic, strong) NSArray<NSString *> *freightRuleList;
@property (nonatomic, strong) NSArray<FKYProductGroupListInfoModel *> *productGroupList;            // 商品数据列表
@property (nonatomic, strong) NSArray<FKYProductGroupListInfoModel *> *products;            // 选择商品数据
@property (nonatomic, strong) NSArray<NSObject<FKYBaseCellProtocol> *> *rowDataForShow; // 楼层展示model

@property (nonatomic, assign) NSInteger editStatus; // 0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中

// 数据解析完后，需要封装对应的楼层展示model
- (void)configCartSectionRowData;
- (NSMutableArray *)getSelectedProductShoppingIds;
- (NSArray *)getSelectedShoppingCartList;
- (NSArray *)getSelectedShoppingCartProductList;
//获取被选中的并且有调拨提示的
- (NSArray *)getSelectedNeedAlertShoppingCartProductList;
- (BOOL)isSelectedAllForEditStatus;
- (BOOL)isectionProductUnValidForSection;
 
@end
