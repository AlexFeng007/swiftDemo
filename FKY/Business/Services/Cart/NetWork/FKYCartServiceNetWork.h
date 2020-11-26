//
//  FKYCartServiceNetWork.h
//  FKY
//
//  Created by 寒山 on 2018/6/25.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJOperationParam.h"
@interface FKYCartServiceNetWork : NSObject
/**
*  获取购物车列表
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getCartUpdateListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  添加商品到购物车
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)addGoodsInshopCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询在购物车里的商品的满减
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)queryFullReductionInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
/**
 *  获取换购子品列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)changeItemListBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
/**
 *  获取购物车商品品种数
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)productsCountBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
/**
 *  修改商品购买数量
 *
 *  @param aCompletionBlock
 */
+(HJOperationParam *)updateGoodNumBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
 
/**
 *  变更商品勾选状态
 *
 *  @param aCompletionBlock
 */

+(HJOperationParam *)updateGoodSelectStateBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
/**
 *  删除商品
 *
 *  @param aCompletionBlock
 */
+(HJOperationParam *)deleteGoodsBlockParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
/**
 *  结算校验
 *
 *  @param aCompletionBlock
 */
+(HJOperationParam *)getSettlementCheckParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;
@end
