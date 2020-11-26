//
//  FKYCartNetRequstSever.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartNetRequstSever.h"
#import "FKYCartServiceNetWork.h"
#import "FKYCartInfoModel.h"

@implementation FKYCartNetRequstSever

#pragma mark - 获取购物车列表
- (void)getCartUpdateListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYCartServiceNetWork getCartUpdateListBlockWithParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
            if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
                if (aCompletionBlock) {
                    aCompletionBlock(aResponseObject,nil);
                }
            }else{
                if (aCompletionBlock) {
                    aCompletionBlock(nil, anError);
                }
            }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 添加商品到购物车
- (void)addGoodsIntoCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork addGoodsInshopCartBlockWithParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 查询在购物车里的商品的满减
- (void)queryFullReductionInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork queryFullReductionInfoBlockWithParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 获取换购子品列表
- (void)changeItemListBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork changeItemListBlockParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 获取购物车商品品种数
- (void)productsCountBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork productsCountBlockWithParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 修改商品购买数量
- (void)updateGoodNumBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork updateGoodNumBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 变更商品勾选状态
- (void)updateGoodSelectStateBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork updateGoodSelectStateBlockParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            
            if (aCompletionBlock) {
                 aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 删除商品
- (void)deleteGoodsBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork deleteGoodsBlockParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

#pragma mark - 结算校验
- (void)getSettlementCheckParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYCartServiceNetWork getSettlementCheckParam:param  completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSArray class]])  {
            
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

@end
