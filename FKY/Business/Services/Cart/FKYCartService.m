//
//  FKYCartService.m
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartService.h"
#import "FKYCartProductModel.h"
#import "FKYTranslatorHelper.h"
#import "FKYLoginAPI.h"
#import "NSDictionary+FKYKit.h"
#import "NSManagedObject+FKYKit.h"
#import "FKYCartModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSArray+Block.h"
#import "FKYCartCheckModel.h"
#import "NSArray+Block.h"
#import "FKYCartServiceNetWork.h"
#import "FKYCartInfoModel.h"


@interface FKYCartService () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/** 网络请求logic */
@property (nonatomic, strong) FKYCartNetRequstSever *cartRequstSever;

@end


@implementation FKYCartService

#pragma mark - Logic
// 商家数组
- (NSInteger)numberOfSection
{
    return self.sectionArray.count;
}

#pragma mark -  判断是否为全部未选中状态
- (BOOL)isAllProductUnSelected
{
    __block NSInteger unSelectCount = 0;        // 未选中商品数量
    __block NSInteger productCount = 0;         // 商品总数
    __block NSInteger editUnSelectCount = 0;    // 编辑状态下未选中商品数量
    __block NSInteger editProductCount = 0;     // 编辑状态下商品总数
    
    [self.sectionArray each:^(FKYCartMerchantInfoModel *sectionModel) {
        // 普通商品
        [sectionModel.productGroupList each:^(FKYProductGroupListInfoModel *object) {
            [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
                if (0 == item.productStatus.intValue) {
                    productCount += 1;
                    if (![item.checkStatus boolValue]) {
                        unSelectCount += 1;
                    }
                }
                if (self.editing) {
                    editProductCount += 1;
                    if (item.editStatus != 2) {
                        editUnSelectCount += 1;
                    }
                }
            }];
        }];
    }];
    if (self.editing) {
        return editUnSelectCount == editProductCount;
    }
    return unSelectCount == productCount;
}

#pragma mark -  判断是否为全选
- (BOOL)isAllProductSelected
{
    NSArray<FKYCartMerchantInfoModel *> *selectedArray = [self.sectionArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checkedAll == %@ || isectionProductUnValidForSection == YES ",@(YES)]];
    if (selectedArray.count == self.sectionArray.count) {
        return YES;
    }
    return NO;
}

#pragma mark -  判断所有商品是否为编辑状态下的全选
- (BOOL)isAllProductSelectedForEdit
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelectedAllForEditStatus == NO"];
    if ([self.sectionArray filteredArrayUsingPredicate:predicate].count > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -  获取购物车中所有商品的购物车ID
- (NSArray *)allSelectedProductShoppingCartIds
{
    NSMutableArray *shoppingCartIds = [NSMutableArray array];
    for (FKYCartMerchantInfoModel *sectionModel in self.sectionArray) {
        [shoppingCartIds addObjectsFromArray:[sectionModel getSelectedProductShoppingIds]];
    }
    return shoppingCartIds;
}

#pragma mark - 获取选择的商品
- (NSArray *)getSelectedShoppingCartList
{
    NSMutableArray *shoppingCartIds = [NSMutableArray array];
    for (FKYCartMerchantInfoModel *sectionModel in _sectionArray) {
        [shoppingCartIds addObjectsFromArray:[sectionModel getSelectedShoppingCartList]];
    }
    return [NSArray arrayWithArray:shoppingCartIds];
}
#pragma mark - 获取选择中的需调拨库存的商品
- (NSArray *)getSelectedNeedAlertShoppingCartList
{
    NSMutableArray *shoppingCartArr = [NSMutableArray array];
    for (FKYCartMerchantInfoModel *sectionModel in _sectionArray) {
        [shoppingCartArr addObjectsFromArray:[sectionModel getSelectedNeedAlertShoppingCartProductList]];
    }
    return [NSArray arrayWithArray:shoppingCartArr];
}

#pragma mark - 判断当前购物车中是否有选中的商品，即是否有商家的订单总金额>0
// 根据商家的订单总金额来判断是否有勾选的商品
- (BOOL)hasProductSelect
{
    for (int i = 0; i < self.sectionArray.count; i++) {
        FKYCartMerchantInfoModel *shopModel = self.sectionArray[i];
        if (shopModel.totalAmount && shopModel.totalAmount.floatValue > 0) {
            return YES;
        }
    } // for
    
    return NO;
}

#pragma mark - 判断用户 所有商品都未达到 起批价
// 未有商品被勾选的商家不在考虑范围之内，即只考虑有商品被勾选的商家
- (BOOL)allStepPriceUnValid
{
    // 未达到起批价的商家数量
    NSInteger unvalidcount = 0;
    // 有勾选商品的商家model...<订单总金额，则说明有商品被勾选>
    NSMutableArray *list = [NSMutableArray array];
    
    for (int i = 0; i < self.sectionArray.count; i++) {
        FKYCartMerchantInfoModel *shopModel = self.sectionArray[i];
        if (shopModel.totalAmount && shopModel.totalAmount.floatValue > 0) {
            [list addObject:shopModel];
        }
    } // for
    
    for (int i = 0; i < list.count; i++) {
        FKYCartMerchantInfoModel *shopModel = list[i];
        if ([self checkStepPriceValidForShop: shopModel] == NO) {
            unvalidcount++;
        }
    } // for
    
    if (unvalidcount == list.count) {
        return true;
    }
    return false;
}

#pragma mark - 判断用户 是否有 商品都未达到 起批价
// 未有商品被勾选的商家不在考虑范围之内，即只考虑有商品被勾选的商家
- (BOOL)hasStepPriceUnValid
{
    // 有勾选商品的商家model...<订单总金额，则说明有商品被勾选>
    NSMutableArray *list = [NSMutableArray array];
    
    for (int i = 0; i < self.sectionArray.count; i++) {
        FKYCartMerchantInfoModel *shopModel = self.sectionArray[i];
        if (shopModel.totalAmount && shopModel.totalAmount.floatValue > 0) {
            // 有订单总金额，说明当前商家中一定有商品被勾选
            [list addObject:shopModel];
        }
    } // for
    
    for (int i = 0; i < list.count; i++) {
        FKYCartMerchantInfoModel *shopModel = list[i];
        if ([self checkStepPriceValidForShop: shopModel] == NO) {
            return true;
        }
    } // for
    
    return false;
}

#pragma mark - 判断用户在某店铺商品是否达到起批价
// 当前方法判断有误...<Old>...<不再使用>
//- (BOOL)stepPriceValidForSection:(NSInteger)section
//{
//    if (section >= self.sectionArray.count) {
//        return NO;
//    }
//
//    // 商家model
//    FKYCartMerchantInfoModel *model = self.sectionArray[section];
//    // 当前判断逻辑有误
//    if (model.needAmount.floatValue > 0 && model.totalAmount.floatValue > 0) {
//        return NO;
//    }
//
//    // 默认可结算
//    return YES;
//}

#pragma mark - 判断用户在某店铺商品是否达到起批价...<New>
// 当前商家一定有订单总金额，即一定有商品被勾选
- (BOOL)checkStepPriceValidForShop:(FKYCartMerchantInfoModel *)model
{
    if (!model) {
        return NO;
    }
    
    // 是否可结算判断
    if (model.totalAmount && model.totalAmount.floatValue > 0) {
        // 有订单总金额，即当前商家中有商品被勾选
        if (model.needAmount && model.needAmount.floatValue > 0) {
            // 有起送金差额，不可结算
            return NO;
        }
        else {
            // 无起送金差额，可结算
            return YES;
        }
    }
    else {
        // 无订单总金额，即当前商家中无商品被勾选...<肯定达不到起批价>
        return NO;
    }
    
    return YES;
}


#pragma mark -  判断当前商家下的所有商品是否均无效~!  若均无效，则商家headerview中的勾选按钮置灰 YES-无效
- (BOOL)sectionProductUnValidForSection:(NSInteger)section
{
    if (self.sectionArray.count == 0) {
        return YES;
    }
    if (section >= self.sectionArray.count) {
        return NO;
    }
    
    // 总商品个数
    __block NSInteger total = 0;
    // 无效商品个数统计
    __block NSInteger count = 0;
    
    // 当前商家数据model
    FKYCartMerchantInfoModel *model = self.sectionArray[section];
    
    // 普通商品
    [model.productGroupList each:^(FKYProductGroupListInfoModel *object) {
        [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
            total++;
            if (0 != item.productStatus.intValue) {
                count += 1;
            }
        }];
    }];
    return count == total;
}

#pragma mark -  更新所有商品的编辑状态
- (void)updateSectionModelForEditing:(FKYCartMerchantInfoModel *)sectionModel success:(FKYSuccessBlock)successBlock
{
    if (!self.editing) {
        return;
    }
    
    sectionModel.editStatus = sectionModel.editStatus == 1? 2 : 1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // [self.sectionArray eachWithIndex:^(FKYCartMerchantInfoModel *model, NSUInteger index) {
        // 普通商品
        [sectionModel.productGroupList each:^(FKYProductGroupListInfoModel *object) {
            [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
                // if (item.supplyId  == sectionModel.supplyId) {
                item.editStatus = sectionModel.editStatus;
                object.editStatus = sectionModel.editStatus;
                // }
            }];
        }];
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            // 判断所有商品是否为编辑状态下的全选
            self.selectedAll = [self isAllProductSelectedForEdit];
            safeBlock(successBlock,NO);
        });
    });
}

#pragma mark - 更新某个店铺商品的编辑
- (void)updateProductForEditing:(FKYCartMerchantInfoModel *)sectionModel success:(FKYSuccessBlock)successBlock
{
    if (!self.editing) {
        return;
    }
    
    sectionModel.editStatus = sectionModel.editStatus == 1? 2 : 1;
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        if (sectionModel.isSelectedAllForEditStatus) {
            sectionModel.editStatus = 2;
        }else{
            sectionModel.editStatus = 1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedAll = [self isAllProductSelectedForEdit];
            safeBlock(successBlock,NO);
        });
    });
}

#pragma mark - 边际状态下全选
- (void)setSelectAllProductForEdit:(BOOL)selectAll success:(FKYSuccessBlock)successBlock
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.sectionArray eachWithIndex:^(FKYCartMerchantInfoModel *model, NSUInteger index) {
            @strongify(self);
            // 普通商品
            [model.productGroupList each:^(FKYProductGroupListInfoModel *object) {
                if (self.editing) {
                    object.editStatus = selectAll == YES? 2 : 1;
                }
                [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
                    if (self.editing) {
                        item.editStatus = selectAll == YES? 2 : 1;
                    }
                }];
            }];
            if (self.editing) {
                model.editStatus = selectAll == YES? 2 : 1;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.editing) {
                self.selectedAll = selectAll;
            }
            safeBlock(successBlock,NO);
        });
    });
}

#pragma mark - Request
#pragma mark -获取服务端购物车列表...<购物车页刷新>
/**
 *  获取服务端购物车列表...<购物车页刷新>
 *
 *  @param successBlock successBlock 成功
 *  @param failureBlock failureBlock 失败
 */
- (void)fetchServiceCartSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUncertify) {
        safeBlock(failureBlock,@"");
        return;
    }
    
    @weakify(self);
    [self.cartRequstSever getCartUpdateListBlockWithParam:nil completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            safeBlock(successBlock,NO);
        }
        else {
            self.sectionArray = nil;
            self.editing = NO;
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

#pragma mark - 修改商品购买数量
#pragma mark -  更新购物车...<商品数量变化时需刷新数据>...<包括普通商品&商品详情搭配套餐商品>
- (void)updateShopCartForProduct:(NSString *)shoppingCartId
                        quantity:(NSInteger)quantity
                       allBuyNum:(NSInteger)allBuyNum
                         success:(void(^)(BOOL mutiplyPage,id aResponseObject))successBlock
                         failure:(FKYFailureBlock)failureBlock
{
    // 先清空限购msg
    self.limitMessage = nil;
    
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"shoppingCartId"] = shoppingCartId; // 购物车id
    para[@"productNum"] = @(quantity); // 要修改为的商品数量
    if ([FKYPush sharedInstance].pushID != nil && ![[FKYPush sharedInstance].pushID isEqual:[NSNull null]] && [FKYPush sharedInstance].pushID.length >1) {
        para[@"pushId"] = [FKYPush sharedInstance].pushID;
    }
    NSMutableArray *contentArray = @[].mutableCopy;
    [contentArray addObject:para];
    
    NSMutableDictionary *jsonInfo = @{}.mutableCopy;
    jsonInfo[@"itemList"] = contentArray;
    //一起购商品更改数量需要
    if (self.isTogeterBuyAddCar) {
        jsonInfo[@"fromwhere"] = @"2";
    }
    if (allBuyNum == -1) {
        jsonInfo[@"updateType"] = @"1";
    }
    //分享bd 的佣金Id
    if ([FKYLoginAPI shareInstance].bdShardId != nil && [[FKYLoginAPI shareInstance].bdShardId length] >0){
        jsonInfo[@"shareUserId"] = [FKYLoginAPI shareInstance].bdShardId;
    }
    @weakify(self);
    [self.cartRequstSever updateGoodNumBlockWithParam:jsonInfo completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            // 限购新增逻辑
            safeBlock(successBlock,NO,aResponseObject);
            //弹出共享仓提示
            //            NSArray *needArr = cartInfo.needAlertCartList;
            //            if (needArr.count > 0) {
            //                cartInfo.needAlertCartList = [FKYPostphoneProductModel parsePostphoneProductArr:needArr];
            //                PDShareStockTipVC *shareStockVC = [[PDShareStockTipVC alloc] init];
            //                shareStockVC.popTitle = @"调拨发货提醒";
            //                shareStockVC.tipTxt = cartInfo.shareStockDesc;
            //                shareStockVC.dataList = cartInfo.needAlertCartList;
            //                [shareStockVC showOrHidePopView:true];
            //            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}
#pragma mark -  更新购物车<套餐列表商品>

- (void)updateShopCartForProductWithParam:(NSDictionary *)param
                                  success:(void(^)(BOOL mutiplyPage,id aResponseObject))successBlock
                                  failure:(FKYFailureBlock)failureBlock
{
    self.limitMessage = nil;
    @weakify(self);
    [self.cartRequstSever updateGoodNumBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            safeBlock(successBlock,NO,aResponseObject);
            //非购物车调用时判断是否需要弹调拨发货提醒
            //            if (self.isCartSever == false) {
            //                //弹出共享仓提示
            //                NSArray *needArr = cartInfo.needAlertCartList;
            //                if (needArr.count > 0) {
            //                    cartInfo.needAlertCartList = [FKYPostphoneProductModel parsePostphoneProductArr:needArr];
            //                    PDShareStockTipVC *shareStockVC = [[PDShareStockTipVC alloc] init];
            //                    shareStockVC.popTitle = @"调拨发货提醒";
            //                    shareStockVC.tipTxt = cartInfo.shareStockDesc;
            //                    shareStockVC.dataList = cartInfo.needAlertCartList;
            //                    [shareStockVC showOrHidePopView:true];
            //                }
            //            }
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
    
}

#pragma mark -  封装固定套餐数量修改后更新购物车请求时的传参
- (NSMutableDictionary *)getFixedComboRequestParams:(FKYProductGroupListInfoModel *)combo withNumber:(NSInteger)number
{
    if (combo && combo.groupItemList && combo.groupItemList .count > 0) {
        // 套餐子品对象
        NSMutableArray *shoppingCartDtoList = @[].mutableCopy;
        [combo.groupItemList eachWithIndex:^(id object, NSUInteger index) {
            // 当前套餐中的单个商品model
            FKYCartGroupInfoModel *obj = (FKYCartGroupInfoModel *)object;
            // 用于传参的dic
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"shoppingCartId"] = (obj.shoppingCartId ? obj.shoppingCartId : @""); // 购物车id
            dic[@"productNum"] = @(number*obj.saleStartNum.intValue); // 套餐单品数量
            [shoppingCartDtoList addObject:dic];
        }];
        
        // 商品套餐对象
        NSMutableDictionary *comboItemDto = @{}.mutableCopy;
        //        comboItemDto[@"comboNum"] = @(number); // 套餐数量
        comboItemDto[@"itemList"] = shoppingCartDtoList; // 套餐子品对象
        return comboItemDto;
    }
    return nil;
}

////更新购物车总的订单的 返利金 运费 和 金额
//- (void)updateFreightShoppingCart:(FKYNetworkResponse *)response {
//    //2018.05.03 运费接口更新字段
//    NSString *orderFreight = nil;//运费总额
//    NSString *productTotalPrice = nil;//商品总额
//    NSString *fullReductionMoney = nil;//商品满减总额
//
//    orderFreight = StringValue(response.originalContent[@"data"][@"cartFreightSum"]);
//    productTotalPrice = StringValue(response.originalContent[@"data"][@"cartAmountSum"]);
//    fullReductionMoney = StringValue(response.originalContent[@"data"][@"cartDiscountSum"]);
//    // 获取预计返利的总金额
//    self.selectedTotalRebate = [response.originalContent[@"data"][@"cartRebateSum"] floatValue];
//    // 老字段 2018.05.04 废弃 商家运费需求
////    orderFreight = StringValue(response.originalContent[@"data"][@"orderFreight"]);
////    productTotalPrice = StringValue(response.originalContent[@"data"][@"productTotalPrice"]);
////    fullReductionMoney = StringValue(response.originalContent[@"data"][@"fullReductionMoney"]);
////    // 获取预计返利的总金额
////    self.selectedTotalRebate = [response.originalContent[@"data"][@"orderRebateSum"] floatValue];

#pragma mark -勾选商品实时更新服务端购物车列表  添加商品道购物车
/**
 *  勾选商品实时更新服务端购物车列表
 *
 *  @param successBlock successBlock 成功
 *  @param failureBlock failureBlock 失败
 */
- (void)updateServiceSelectedPorductWithParams:(NSDictionary *)params Success:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUncertify) {
        safeBlock(successBlock,NO);
        return;
    }
    @weakify(self);
    [self.cartRequstSever updateGoodSelectStateBlockParam:params  completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            safeBlock(successBlock,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

#pragma mark - 更新购物车的商品列表中各商品的编辑状态
- (void)updateCartListForIsEdit:(BOOL)isEdit success:(FKYSuccessBlock)successBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.sectionArray eachWithIndex:^(FKYCartMerchantInfoModel *model, NSUInteger index) {
            // 普通商品
            [model.productGroupList each:^(FKYProductGroupListInfoModel *object) {
                if (self.editing) {
                    object.editStatus = 1;
                }else {
                    object.editStatus = 0;
                }
                [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
                    if (self.editing) {
                        item.editStatus = 1;
                    }else {
                        item.editStatus = 0;
                    }
                }];
            }];
            if (self.editing) {
                model.editStatus = 1;
            }else {
                model.editStatus = 0;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.editing) {
                self.selectedAll = NO;
            }else {
                self.selectedAll = [self isAllProductSelected];
            }
            safeBlock(successBlock,NO);
        });
    });
}

#pragma mark -  编辑状态下删除...<批量>
- (void)deleteSelectedShopCartSuccess:(FKYSuccessBlock)success failure:(FKYFailureBlock)failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *arr = @[].mutableCopy;
        if (self.editing) {
            // 编辑状态
            [self.sectionArray each:^(FKYCartMerchantInfoModel *sectionModel) {
                // 普通商品
                [sectionModel.productGroupList each:^(FKYProductGroupListInfoModel *object) {
                    //
                    [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
                        if (item.editStatus == 2) {
                            [arr addObject:item.shoppingCartId];
                        }
                    }];
                }];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteShopCart:arr success:success failure:failure];
        });
    });
}

#pragma mark -  最终的删除商品(or套餐)请求方法...<可批量删除>
- (void)deleteShopCart:(NSArray *)shoppingCartIdArray success:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"shoppingcartid"] = shoppingCartIdArray;
    if (self.isTogeterBuyAddCar) {
        para[@"fromwhere"] = @"2";
    }
    if (self.isCartSever){
        para[@"deleteType"] = @"0";
    }
    //分享bd 的佣金Id
    if ([FKYLoginAPI shareInstance].bdShardId != nil && [[FKYLoginAPI shareInstance].bdShardId length] >0){
        para[@"shareUserId"] = [FKYLoginAPI shareInstance].bdShardId;
    }
    @weakify(self);
    [self.cartRequstSever deleteGoodsBlockParam:para  completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            //            // 限购新增逻辑
            //            [self updateCartNum];
            safeBlock(successBlock,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

#pragma mark -  删除换购商品???
- (void)deleteHuanGouGiftShopCart:(NSString *)shoppingCartChangeId success:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"shoppingcartid"] = @[shoppingCartChangeId];
    @weakify(self);
    [self.cartRequstSever deleteGoodsBlockParam:para  completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            //            FKYCartInfoModel *cartInfo = [FKYTranslatorHelper translateModelFromJSON:aResponseObject withClass:[FKYCartInfoModel class]];
            //            [cartInfo.supplyCartList each:^(FKYCartMerchantInfoModel *sectionModel) {
            //                [sectionModel configCartSectionRowData];
            //            }];
            //            self.sectionArray = [NSArray arrayWithArray:cartInfo.supplyCartList];
            //            self.editing = NO;
            //            [self updateFreightInShoppingCart:cartInfo];
            //            [self updateCartNum];
            safeBlock(successBlock,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

#pragma mark -  结算校验接口，当购买商品与库存有不同时，返回对应的商品列表
- (void)checkCartSumbit:(NSDictionary *)dic
                success:(FKYSuccessBlock)successBlock
                failure:(FKYFailureBlock)failureBlock
{
    
    @weakify(self);
    [self.cartRequstSever getSettlementCheckParam:dic completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            @strongify(self);
            
            NSArray *result = [FKYTranslatorHelper translateCollectionFromJSON:aResponseObject withClass:[FKYCartCheckModel class]];
            NSMutableArray *resultList = [NSMutableArray array];
            for (FKYCartCheckModel *item in result) {
                NSString *name = [NSString stringWithFormat:@"%@  %@", item.productName, item.specification ];
                [resultList addObject:name];
            }
            self.changedArray = [NSArray arrayWithArray:resultList];
            safeBlock(successBlock,NO);
        }
        else {
            NSString *errMsg = anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败";
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            safeBlock(failureBlock, errMsg);
        }
    }];
}

- (void)updateFreightInShoppingCart:(FKYCartInfoModel *)infoModel
{
    //2018.05.03 运费接口更新字段
    // NSString * productTotalPrice = StringValue(infoModel.totalAmount);
    // NSString *fullReductionMoney = StringValue(infoModel.discountAmount);
    // 获取预计返利的总金额
    //- [fullReductionMoney floatValue];
    self.cartRebateProductSum  = infoModel.checkedRebateProducts.intValue;
    self.selectedTypeCount = [infoModel.checkedProducts  intValue];
    self.discountAmount = infoModel.discountAmount;
    self.selectedTotalPrice = infoModel.appShowMoney;
    self.cartPaySum = infoModel.totalAmount;
    self.selectedTotalRebate = infoModel.rebateAmount;
    // 是否为全选
    self.selectedAll = infoModel.checkedAll;
}

- (FKYCartNetRequstSever *)cartRequstSever
{
    if (_cartRequstSever == nil) {
        _cartRequstSever  = [FKYCartNetRequstSever logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _cartRequstSever;
}
//更新购物车数量(当购物车数量被清空时)
-(void)updateCartNum{
    [[FKYVersionCheckService shareInstance] syncMixCartNumberSuccess:nil failure:nil];
}
@end

