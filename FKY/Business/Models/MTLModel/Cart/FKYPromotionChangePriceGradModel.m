//
//  FKYPromotionChangeProductModel.m
//  FKY
//
//  Created by airWen on 2017/6/8.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYPromotionChangePriceGradModel.h"

@implementation FKYPromotionChangePriceGradModel
#pragma mark - private
- (void)synchronizationGiftSelectedStatus
{
    if ((_promitionChangeProductList.count <= 0) || (_changeProductList.count <= 0)) {
        return;
    }
    if (_selectRule) {//只同步选择的价格梯度下面的赠品商品选择状态
        NSArray<NSString *> *arySelectedProductIds = [_changeProductList valueForKeyPath:@"productId"];
        NSArray<FKYIncreasePriceGiftsProductModel *> *resultArray = [self.promitionChangeProductList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.productId IN %@",arySelectedProductIds]];
        [resultArray makeObjectsPerformSelector:@selector(setSelectedProduct:) withObject:@(YES)];
    }
}

#pragma mark - override FKYBaseModel
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:NSStringFromSelector(@selector(changeProductList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYIncreasePriceGiftsProductModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(promitionChangeProductList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYIncreasePriceGiftsProductModel class]];
    }
    return nil;
}


#pragma mark - For View Show

//如果不符合条件，则该价格梯度下的商品全部可选
- (void)setChange:(BOOL)change
{
    _change = change;
    [self.promitionChangeProductList makeObjectsPerformSelector:@selector(setIsCanSelected:) withObject:@(change)];
}

-  (void)setSelectRule:(BOOL)selectRule
{
    _selectRule = selectRule;
    
    [self synchronizationGiftSelectedStatus];
}

- (void)setChangeProductList:(NSArray<FKYIncreasePriceGiftsProductModel *> *)changeProductList
{
    _changeProductList = changeProductList;
    
    [self synchronizationGiftSelectedStatus];
}

- (void)setPromitionChangeProductList:(NSArray<FKYIncreasePriceGiftsProductModel *> *)promitionChangeProductList
{
    _promitionChangeProductList = promitionChangeProductList;
    
    [self synchronizationGiftSelectedStatus];
    
    [self.promitionChangeProductList makeObjectsPerformSelector:@selector(setIsCanSelected:) withObject:@(_change)];
}

@end
