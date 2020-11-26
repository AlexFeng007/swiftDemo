//
//  FKYVirtualInventoryModel.m
//  FKY
//
//  Created by Rabe on 17/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "FKYVirtualInventoryModel.h"

@implementation FKYVirtualInventoryPriceModel

@end

@implementation FKYVirtualInventoryProductModel

@end

@implementation FKYSubmitCartOrderModel

@end

@implementation FKYYSubmitCartModel
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:NSStringFromSelector(@selector(orderList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYSubmitCartOrderModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(productList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYVirtualInventoryProductModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(orderMoney))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYVirtualInventoryPriceModel class]];
    }
    return nil;
}
@end

@implementation FKYVirtualInventoryModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"priceModel" : @"orderMoney",
             @"productModels" : @"productList"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"productModels" : [FKYVirtualInventoryProductModel class]};
}

// 第一次提交订单，有缺货商品，过滤接口数组
- (void)filterProducts
{
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.productModels];
    [list enumerateObjectsUsingBlock:^(FKYVirtualInventoryProductModel * _Nonnull product, NSUInteger idx, BOOL * _Nonnull stop) {
        if (product.productNormalCount - product.stockAmount <= 0) { // 库存充足
            product.state = FKYVirtualInventorySufficientStock;
            product.itemSelected = YES;
        }
        else if (product.stockAmount == 0) { // 无库存
            product.state = FKYVirtualInventoryStockZero;
        }
        else { // 有库存但库存不足
            product.state = FKYVirtualInventoryUnderStock;
            product.itemSelected = YES;
        }
    }];
    self.productModels = list.copy;
}

// 库存发生改变时，重新过滤接口数组
- (void)filterProductsWhenStockChanged
{
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.productModels];
    [list enumerateObjectsUsingBlock:^(FKYVirtualInventoryProductModel * _Nonnull product, NSUInteger idx, BOOL * _Nonnull stop) {
        if (product.productNormalCount - product.stockAmount <= 0) { // 库存充足
            product.state = FKYVirtualInventorySufficientStock;
        }
        else if (product.stockAmount == 0) { // 无库存
            product.state = FKYVirtualInventoryStockZero;
        }
        else { // 有库存但库存不足
            product.state = FKYVirtualInventoryUnderStock;
        }
        
        // 库存变化后 返回的product中  如果productCount>0，且stockCount>0. 则代表该商品用户勾选
        if (product.productCount > 0 && product.stockAmount > 0) {
            product.itemSelected = YES;
        } else {
            product.itemSelected = NO;
        }
    }];
    self.productModels = list.copy;
}

- (NSDictionary *)changeOrderURL2Dic
{
    self.orderUrl.orderMoney = self.priceModel;
    self.orderUrl.productList = self.productModels;
    NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:self.orderUrl.dictionaryValue];
    // 去掉该属性，否则接口无法解析会报错
    NSMutableDictionary *mOrderMoney = [NSMutableDictionary dictionaryWithDictionary:self.orderUrl.orderMoney.dictionaryValue];
    [mOrderMoney removeObjectForKey:@"sellerOrderSamount"];
    [dicData setObject:mOrderMoney.copy forKey:@"orderMoney"];
    NSMutableArray<NSDictionary *> *aryProductList = [[self.orderUrl.productList valueForKeyPath:@"dictionaryValue"] mutableCopy];
    NSMutableArray *array = [NSMutableArray array];
    // 去掉自定义属性，否则接口无法解析会报错
    for (NSDictionary *dictionary in aryProductList) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [mDict removeObjectForKey:@"state"];
        [mDict removeObjectForKey:@"itemSelected"];
        [array addObject:mDict.copy];
    }
    [dicData setObject:array forKey:@"productList"];
    NSArray<NSDictionary *> *aryOrderList = [self.orderUrl.orderList valueForKeyPath:@"dictionaryValue"];
    [dicData setObject:aryOrderList forKey:@"orderList"];
    return [NSDictionary dictionaryWithDictionary:dicData];
}

- (NSArray *)shopCartIdList
{
    NSArray<NSDictionary *> *aryOrderList = [self.orderUrl.orderList valueForKeyPath:@"dictionaryValue"];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *order in aryOrderList) {
        NSArray *shopCartIdList = [order valueForKey:@"shopCartIdList"];
        [resultArray addObjectsFromArray:shopCartIdList];
    }
    return resultArray;
}

// Init Data From API For Swift&Object混编
+ (FKYVirtualInventoryModel *)changeOrderURLDic2Model:(NSDictionary *)dataDictionary
{
    FKYVirtualInventoryModel *model = [FKYVirtualInventoryModel yy_modelWithDictionary:dataDictionary];
    NSDictionary *money = dataDictionary[@"orderMoney"] ? : @{};
    NSArray *productlist = dataDictionary[@"productList"] ? : @[];
    NSArray *orderIdList = dataDictionary[@"orderUrl"][@"orderList"] ? : @[];
    model.orderUrl.productList = [FKYTranslatorHelper translateCollectionFromJSON:productlist withClass:[FKYVirtualInventoryProductModel class]];
    model.orderUrl.orderMoney = [FKYTranslatorHelper translateModelFromJSON:money withClass:[FKYVirtualInventoryPriceModel class]];
    model.orderUrl.orderList = [FKYTranslatorHelper translateCollectionFromJSON:orderIdList withClass:[FKYSubmitCartOrderModel class]];
    return model;
}

@end

