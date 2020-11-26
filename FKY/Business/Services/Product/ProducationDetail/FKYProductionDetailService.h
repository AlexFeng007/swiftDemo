//
//  FKYProducationDetailService.h
//  FKY
//
//  Created by mahui on 15/9/18.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  商详相关接口请求类...<商详基本数据、单品加车、套餐加车>

#import "FKYBaseService.h"
#import "FKYTranslatorHelper.h"
#import "FKYProductObject.h"
#import "FKYProductGroupModel.h"
#import "FKYFixedComboItemModel.h"


@interface FKYProductionDetailService : FKYBaseService

/**
 *    @brief    获取商品详情（基本信息）
 *
 *    @param     productionId     商品id
 *    @param     vendorId     供应商id
 */
- (void)producationInfoWithParam:(NSDictionary *)param
                                 success:(void(^)(FKYProductObject *model))successBlock
                                 failure:(void(^)(NSString *reason))failureBlock;

/**
 *  @brief    加入购物车(单品加车)
 *
 *  @param productId      priceList下 productId
 *  @param quantity       加入数量
 *  @param successBlock   successBlock
 *  @param failureBlock   failureBlock
 */
- (void)addToCartWithProductId:(NSString *)productId
                      quantity:(NSInteger)quantity
                       success:(FKYRequestSuccessBlock)successBlock
                        falure:(FKYRequestFailureBlock)failureBlock;

/**
 *    @brief    (搭配)套餐加车
 *
 *    @param     group     套餐model
 *    @param     successBlock     加车成功回调block
 *    @param     failureBlock     加车失败回调block
 */
- (void)addToCartWithGroup:(FKYProductGroupModel *)group
                   success:(FKYRequestSuccessBlock)successBlock
                    falure:(FKYRequestFailureBlock)failureBlock;

/**
 *    @brief    (固定)套餐加车
 *
 *    @param     group     套餐model
 *    @param     successBlock     加车成功回调block
 *    @param     failureBlock     加车失败回调block
 */
- (void)addToCartWithFixedGroup:(FKYProductGroupModel *)group
                        success:(FKYRequestSuccessBlock)successBlock
                         falure:(FKYRequestFailureBlock)failureBlock;

/**
 *    @brief    获取商品满赠信息
 *
 *    @param     pId     商品促销id
 *    @param     successBlock     请求成功回调block
 *    @param     failureBlock     请求失败回调block
 */
+ (void)requestProductFullGiftInfo:(NSString *)pId
                           success:(FKYRequestSuccessBlock)successBlock
                            falure:(FKYRequestFailureBlock)failureBlock;

#pragma mark -

/**
 *    @brief    浏览商详页记录浏览次数达30次送券
 *
 *    @param    商品编码     卖家编码(包含jbp)  supplyId 卖家编码(包含jbp)
 *    @param     successBlock     请求成功回调block
 *    @param     failureBlock     请求失败回调block
 */
+ (void)sendViewInfoForCoupon:(NSString *)spuCode
                       senderId:(NSString *)supplyId
                      success:(FKYRequestSuccessBlock)successBlock
                       falure:(FKYRequestFailureBlock)failureBlock;

@end
