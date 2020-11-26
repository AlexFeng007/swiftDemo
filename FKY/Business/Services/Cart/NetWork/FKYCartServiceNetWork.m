//
//  FKYCartServiceNetWork.m
//  FKY
//
//  Created by 寒山 on 2018/6/25.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartServiceNetWork.h"

@implementation FKYCartServiceNetWork
#pragma mark -  获取购物车列表

+ (HJOperationParam *)getCartUpdateListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"list" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -   添加商品到购物车

+ (HJOperationParam *)addGoodsInshopCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"add" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark -  查询在购物车里的商品的满减
+ (HJOperationParam *)queryFullReductionInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"queryFullReductionInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark -  获取换购子品列表

+ (HJOperationParam *)changeItemListBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"changeItemList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark -  获取购物车商品品种数

+ (HJOperationParam *)productsCountBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"productsCount" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark -  修改商品购买数量

+(HJOperationParam *)updateGoodNumBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"updateNum" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
 
#pragma mark -  变更商品勾选状态

+(HJOperationParam *)updateGoodSelectStateBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"updateCheckStatus" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark -  删除商品

+(HJOperationParam *)deleteGoodsBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"delete" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
#pragma mark - 结算校验

+(HJOperationParam *)getSettlementCheckParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"submitCheck" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}
@end
