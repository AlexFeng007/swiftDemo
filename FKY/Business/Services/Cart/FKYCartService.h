//
//  FKYCartService.h
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  购物车相关服务类...<接口请求、数据处理>

#import "FKYBaseService.h"
#import "FKYCartNetRequstSever.h"
#import "FKYCartGroupInfoModel.h"
#import "FKYProductGroupListInfoModel.h"
#import "FKYCartMerchantInfoModel.h"

@class FKYCartProductModel;
@class FKYCartProductPromoteModel;
//@class CartProductModel;
//@class CartFixedComboItemModel;


@interface FKYCartService : FKYBaseService

@property (nonatomic, strong) NSArray *sectionArray; // 商家数组...<每个商家均可包含多个商品与套餐>
@property (nonatomic, strong) NSArray *changedArray;//库存发生变化的商品列表
@property (nonatomic, strong) NSArray *sectionShowArray;
@property (nonatomic, assign) BOOL selectedAll; // 是否为全选
@property (nonatomic, strong) NSNumber *selectedTotalPrice; // 全选后的总价格
@property (nonatomic, strong) NSNumber * cartPaySum; // 所有选中商品的 应付金额 减去满减 金额
@property (nonatomic, strong) NSNumber *  discountAmount; // 购物车折扣/满减金额

@property (nonatomic, strong) NSNumber *selectedTotalRebate; // 全选后的预计返利信息 价格 app购物车总额（未减满减金额，不包含邮费）
@property (nonatomic, assign) int selectedTypeCount; // 购物车中商品类型数量
@property (nonatomic, assign) BOOL editing; // 0: 正常 1: 编辑
// 为限购单独新增的msg...<商品是限购，且超过限购数量的时候，返回结果集里就会有limitMessage字段>
//2018.05.03 新增 运费
@property (nonatomic, assign) BOOL isCartSever; // 判断是否购物车调用
//@property (nonatomic, assign) double cartAmountSum; // 所有选中商品的 商品总额
//@property (nonatomic, assign) double cartDiscountSum; // 所有选中商品的 满减金额
//@property (nonatomic, assign) double cartFreightSum; // 所有选中商品的 运费

//@property (nonatomic, assign) double cartRebateSum; // 所有选中商品的 返利金额
@property (nonatomic, assign) int cartRebateProductSum; // 所有选中返利商品的 数量
@property (nonatomic, copy) NSString *limitMessage; // 超过限购数量！

@property (nonatomic , assign)BOOL isTogeterBuyAddCar; //yes 代表一起购商品三步加车 （默认为no）
/**
 *  获取服务端购物车列表...<购物车页刷新>
 *
 *  @param successBlock successBlock 成功
 *  @param failureBlock failureBlock 失败
 */
- (void)fetchServiceCartSuccess:(FKYSuccessBlock)successBlock
                        failure:(FKYFailureBlock)failureBlock;
/**
 *  勾选商品实时更新服务端购物车列表
 *
 *  @param successBlock successBlock 成功
 *  @param failureBlock failureBlock 失败
 */
- (void)updateServiceSelectedPorductWithParams:(NSDictionary *)params
                                       Success:(FKYSuccessBlock)successBlock
                                       failure:(FKYFailureBlock)failureBlockk;

// 更新购物车的商品列表中各商品的编辑状态
- (void)updateCartListForIsEdit:(BOOL)isEdit success:(FKYSuccessBlock)successBlock;

- (void)updateSectionModelForEditing:(FKYCartMerchantInfoModel  *)sectionModel
                             success:(FKYSuccessBlock)successBlock;

- (void)updateProductForEditing:(FKYCartMerchantInfoModel *)sectionModel
                        success:(FKYSuccessBlock)successBlock;

- (void)setSelectAllProductForEdit:(BOOL)selectAll success:(FKYSuccessBlock)successBlock;

// 购物车页加车~!@
// 更新购物车...<商品数量变化时需刷新数据>...<包括普通商品&搭配套餐商品>
- (void)updateShopCartForProduct:(NSString *)shoppingCartId
                        quantity:(NSInteger)quantity
                       allBuyNum:(NSInteger)allBuyNum
                         success:(void(^)(BOOL mutiplyPage,id aResponseObject))successBlock
                         failure:(FKYFailureBlock)failureBlock;
- (void)updateShopCartForProductWithParam:(NSDictionary *)param
                         success:(void(^)(BOOL mutiplyPage,id aResponseObject))successBlock
                         failure:(FKYFailureBlock)failureBlock;

// 编辑状态下删除
- (void)deleteSelectedShopCartSuccess:(FKYSuccessBlock)success
                              failure:(FKYFailureBlock)failure;

// 最终的删除请求方法
- (void)deleteShopCart:(NSArray *)shoppingCartIdArray
               success:(FKYSuccessBlock)successBlock
               failure:(FKYFailureBlock)failureBlock;

- (void)checkCartSumbit:(NSDictionary *)dic
                success:(FKYSuccessBlock)successBlock
                failure:(FKYFailureBlock)failureBlock;

- (NSArray *)getSelectedShoppingCartList;
- (NSArray *)getSelectedNeedAlertShoppingCartList;

// 删除换购品
- (void)deleteHuanGouGiftShopCart:(NSString *)shoppingCartChangeId
                          success:(FKYSuccessBlock)successBlock
                          failure:(FKYFailureBlock)failureBlock;

// 是否有商品被勾选
- (BOOL)hasProductSelect;

// 起批价
- (BOOL)allStepPriceUnValid;
- (BOOL)hasStepPriceUnValid;
- (BOOL)sectionProductUnValidForSection:(NSInteger)section;

- (NSInteger)numberOfSection;

// 判断是否为全部未选中状态
- (BOOL)isAllProductUnSelected;
// 判断是否为全选
- (BOOL)isAllProductSelected;
// 判断所有商品是否为编辑状态下的全选
- (BOOL)isAllProductSelectedForEdit;

- (NSArray *)allSelectedProductShoppingCartIds;

// 封装固定套餐数量修改后更新购物车请求时的传参
- (NSMutableDictionary *)getFixedComboRequestParams:(FKYProductGroupListInfoModel *)combo withNumber:(NSInteger)number;

@end

