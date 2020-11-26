//
//  FKYCartMerchantInfoModel.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartMerchantInfoModel.h"
#import "CartSectionViewModel.h"
#import "FKYShoppingCartModel.h"
#import "NSArray+Block.h"

@implementation FKYCartMerchantInfoModel

// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(productGroupList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductGroupListInfoModel class]];
    }
    
    return nil;
}

// 数据解析完后，需要封装对应的楼层展示model
- (void)configCartSectionRowData{
    NSMutableArray<NSObject<FKYBaseCellProtocol> *> *aryShowData = [[NSMutableArray alloc] init];
    if(self.needAmount.floatValue > 0){
        //商品未达起送金额
        SectionTipsCellModel *tipsModel = [[SectionTipsCellModel alloc]init];
        tipsModel.cartMerchantInfoModel = self;
        [aryShowData addObject:tipsModel];
    }else if (self.freeShippingNeed.floatValue > 0) {
        //商品未达包邮金额
        SectionTipsCellModel *tipsModel = [[SectionTipsCellModel alloc]init];
        tipsModel.cartMerchantInfoModel = self;
        [aryShowData addObject:tipsModel];
    }
    
    for (FKYProductGroupListInfoModel *item in self.productGroupList) {
        item.supplyId = self.supplyId;
        [aryShowData addObjectsFromArray:item.getSectionDeatilInfo];
    }
    SeparateLineCellModel *LineCell = [[SeparateLineCellModel alloc] init];
    LineCell.cellType = CartTabelCellTypeSeparateTopLine;
    [aryShowData addObject:LineCell];
    
     _rowDataForShow = [NSArray arrayWithArray:aryShowData];
}

- (NSMutableArray *)getSelectedProductShoppingIds{
    NSMutableArray *selectCartListArray = [NSMutableArray array];
    
    for (FKYProductGroupListInfoModel *item in self.productGroupList) {
        for (FKYCartGroupInfoModel *object in item.groupItemList) {
            if(object.productStatus.intValue == 0 && object.checkStatus.boolValue)
                [selectCartListArray addObject:object.shoppingCartId];
        }
    }
    return selectCartListArray;
}

- (NSArray *)getSelectedShoppingCartList{
    NSMutableArray *selectCartListArray = [NSMutableArray array];
    for (FKYProductGroupListInfoModel *item in self.productGroupList) {
        for (FKYCartGroupInfoModel *object in item.groupItemList) {
            if(object.productStatus.intValue == 0 && object.checkStatus.boolValue)
               [selectCartListArray addObject:object.shoppingCartId];
        }
    }
    return [NSArray arrayWithArray:selectCartListArray];
}

- (NSArray *)getSelectedShoppingCartProductList{
    NSMutableArray *selectCartListArray = [NSMutableArray array];
    for (FKYProductGroupListInfoModel *item in self.productGroupList) {
        for (FKYCartGroupInfoModel *object in item.groupItemList) {
            if(object.productStatus.intValue == 0 && object.checkStatus.boolValue)
                [selectCartListArray addObject:object];
        }
    }
    return [NSArray arrayWithArray:selectCartListArray];
}
//获取被选中的并且有调拨提示的
- (NSArray *)getSelectedNeedAlertShoppingCartProductList{
    NSMutableArray *selectNeedAlertCartListArray = [NSMutableArray array];
    for (FKYProductGroupListInfoModel *item in self.productGroupList) {
        for (FKYCartGroupInfoModel *object in item.groupItemList) {
            if(object.productStatus.intValue == 0 && object.checkStatus.boolValue && object.shareStockVO != nil){
                [selectNeedAlertCartListArray addObject:object];
            }
        }
    }
    return [NSArray arrayWithArray:selectNeedAlertCartListArray];
}

// 判断当前商家中的所有商品是否为编辑全选中状态
- (BOOL)isSelectedAllForEditStatus
{
    // 普通商品
    NSMutableArray *unSelectedArray = [NSMutableArray array];
    [self.productGroupList each:^(FKYProductGroupListInfoModel *object) {
        NSArray *itemUnSelectedArray = [object.groupItemList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"editStatus == 1"]];
        [unSelectedArray addObjectsFromArray:itemUnSelectedArray];
    }];
    if (unSelectedArray.count > 0) {
        return NO;
    }
    return YES;
}

// 判断当前商家中的所有商品是否全部无效
- (BOOL)isectionProductUnValidForSection{
    // 总商品个数
    __block NSInteger total = 0;
    // 无效商品个数统计
    __block NSInteger count = 0;
    
    [self.productGroupList each:^(FKYProductGroupListInfoModel *object) {
        [object.groupItemList each:^(FKYCartGroupInfoModel *item) {
            total++;
            if (0 != item.productStatus.intValue) {
                count += 1;
            }
        }];
    }];
  
    return count == total;
}

@end
