//
//  FKYCartInfoModel.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"

#import "FKYCartMerchantInfoModel.h"

@interface FKYCartInfoModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *checkedProducts;    //购物车选中的商品品种总计    number    @mock=6
@property (nonatomic, strong) NSNumber *discountAmount;    //    购物车折扣/满减金额    number    @mock=10
@property (nonatomic, strong) NSNumber *freight;    //    购物车运费    number    @mock=10
@property (nonatomic, assign) BOOL checkedAll;    //   是否全选    boolean    @mock=false
@property (nonatomic, strong) NSNumber *payAmount;    //    购物车应付金额    number    @mock=1010
@property (nonatomic, strong) NSNumber *productsCount;    //    购物车品种总数    number    @mock=8
@property (nonatomic, strong) NSNumber *rebateAmount ;    //   购物车返利总金额    number    @mock=9
@property (nonatomic, strong) NSNumber *totalAmount;    //  购物车总金额   number    @mock=9
@property (nonatomic, strong) NSNumber *appShowMoney;    //  app购物车总额（未减满减金额，不包含邮费）
@property (nonatomic, strong) NSNumber * checkedRebateProducts;//选中的返利商品种类数
@property (nonatomic, strong) NSArray<FKYCartMerchantInfoModel *> *supplyCartList;            // 商品数据列表

@property (nonatomic, strong) NSArray *needAlertCartList;            // 商品数据列表
@property (nonatomic, strong) NSString *shareStockDesc;     //调货提示

- (void)initWithDict:(NSDictionary *)dict;

@end
