//
//  FKYCartModel.m
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYCartModel.h"
#import "FKYCartProductMO.h"
#import "FKYCartProductModel.h"
#import "FKYCartProductManagedModel.h"
#import "FKYTranslatorHelper.h"
#import "NSManagedObject+FKYKit.h"
#import "FKYCartService.h"
#import "FKYLoginAPI.h"
#import "NSArray+Block.h"


@interface FKYCartModel ()
{
    NSArray *_localProducts;
    NSInteger _productCount;
}
@end


@implementation FKYCartModel

+ (FKYCartModel *)shareInstance
{
    static dispatch_once_t onceToken;
    static FKYCartModel *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    
    return staticInstance;
}

+ (void)syncServiceCartSuccess:(void (^)(void))successBlock
                       failure:(void (^)(NSString *))failureBlock
{
    return [[FKYCartService new] fetchServiceCartSuccess:^(BOOL mutiplyPage) {
        [[FKYCartModel shareInstance] initilizeLocalProduct];
        successBlock();
    } failure:^(NSString *reason) {
        failureBlock(reason);
    }];
}

- (void)initilizeLocalProduct
{
    NSArray *mos = nil;
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        // 已登录
        NSString *userId = [NSString stringWithFormat:@"%@",[FKYLoginAPI currentUser].userId];
        mos = [FKYCartProductMO MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"userId=%@",userId]];
    }
    else {
        // 未登录
        mos = [FKYCartProductMO MR_findAll];
    }

    // ???
    [mos each:^(FKYCartProductMO *object) {
        if (!object.productWmCount) {
            object.productWmCount = 0;
        }
    }];
    
    NSArray *products = [FKYTranslatorHelper translateCollectionfromManagedObjects:mos withClass:[FKYCartProductManagedModel class]];
    _localProducts = [products map:^FKYCartProductModel *(FKYCartProductManagedModel *object) {
        FKYCartProductModel *model = [FKYCartProductModel new];
        [model copyPropertiesFromBaseModel:object];
        return model;
    }];
    _productCount = _localProducts.count;
    
//    [_localProducts enumerateObjectsUsingBlock:^(FKYCartProductModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
//        _productCount += model.quantity;
//    }];
}

- (NSMutableArray<FKYCartOfInfoModel *> *)productArr
{
    if (!_productArr) {
        _productArr = [NSMutableArray new];
    }
    return _productArr;
}
- (NSMutableArray<FKYCartOfInfoModel *> *)mixProductArr
{
    if (!_mixProductArr) {
        _mixProductArr = [NSMutableArray new];
    }
    return _mixProductArr;
}
-(NSMutableArray<FKYCartOfInfoModel *> *)togeterBuyProductArr{
    if (!_togeterBuyProductArr) {
        _togeterBuyProductArr = [NSMutableArray new];
    }
    return _togeterBuyProductArr;
}
- (NSArray *)products
{
    return _localProducts;
}

- (NSInteger)badgeValue
{
    return _productCount;
}

@end


@implementation FKYCartOfInfoModel

@end
