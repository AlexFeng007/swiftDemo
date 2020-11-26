//
//  FKYPublicServiceNetWork.h
//  FKY
//
//  Created by 寒山 on 2018/8/13.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYPublicServiceNetWork : NSObject

/**
 *  获取店铺主页（旧版店铺首页）
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getShopIndexBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

//店铺  口令分享
+ (HJOperationParam *)getCrmProductListWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  店铺收藏或者取消
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)shopCollectAddCancelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  店铺是否收藏
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)shopIsCollectBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  收藏店铺列表信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)shopCollectListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取销售顾问列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getListAdviserBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  加入渠道
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)applyChannelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  到货通知
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)addArrivalNoticeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  修改基本资料和企业银行信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)createSaveEnterpriseDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  首页获取分类列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getCategoryListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取个人中心订单数量接口
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getUserTipInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询第三方物流信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询第三方物流信息  承运商等
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)queryLogisticsTitleBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  提交订单接口
 
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)submitShopCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  提交一起购订单接口  /
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)createGroupBuyOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  提交订单之前判断资质
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkEnterpriseQualificationBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  检查订单接口
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkOrderPageInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  一起购检查订单接口
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkGroupBuyOrderPageBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  订单详情
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)orderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  取消待付款自营订单
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)cancelOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  取消已付款订单
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)buyerCancelPayedOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  订单列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)listOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   提醒发货
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)orderDeliveryRemindBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   保存发票信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveInvoiceInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   卖家信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)selectSalesmanInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   新的获取注册时填写的企业类型
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getAllRollTypeNewBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   获取经营范围的药品分类
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getDrugScopeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   编辑经营范围的药品分类
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveDrugScopeDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   上传资质
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveQcDftListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  资质审核状态
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getAuditStatusBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询资质信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)queryEnterpriseByIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询原资料（查看原资质文件入口已屏蔽）
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)queryPassedEnterpriseInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  提交审核
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)submitAuditDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  完善注册信息，获取收货地址
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getReceiverAddressListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  完善注册信息，修改收货地址
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)updateReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  完善注册信息，删除收货地址
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)deleteReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  完善注册信息，新增收货地址
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  完善注册信息，设置默认收货地址
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)updDefReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  编辑销售设置
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  保存基本资质信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)saveEnterpriseBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  首营资质交换提醒
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkErpInfoBySupplyIdsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查看供应商资质
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)queryEnterpriseQcListBySupplyIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  延期收货
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)delayDeliveryBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  取消订单更多信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)cancelOrderInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  物流信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  确认收货列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)confirmOrderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  确认收货/拒收/补货
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)refusedReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  订单拒收补货列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)exceptionOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  确定收货  补货
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)refusedExceptionReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  常购商家
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getChangMerchantsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  常购清单...<混合接口>
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getOftenBuyProductListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  商品清单...<单个类型接口>
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getOftenBuyGoodsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   获取发票信息接口
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getBillInfoByCustIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 * 获取发票信息接口
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)recheckCouponListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取商家银行信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getBankInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取支付宝支付参数
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getAppPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取微信支付参数
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getAppWechatPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取H5微信支付参数
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getWechatPayH5ParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取支付方式列表接口
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getAppPayTypeListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取sign
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getPaySignBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  1药贷确认支付接口
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)confirmFosunPayBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
*  获取支付订单数据
*
*  @param aCompletionBlock
*/
+ (HJOperationParam *)getPayInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  一起购频道页列表数据
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getTogeterBuyListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  一起购商品详情页数据
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getTogeterBuyDetailDataBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取花呗分期列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getHuaBeiInstallmentWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取花呗支付参数
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getAlipayHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取花呗分期支付参数
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询正式表企业信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getEnterpriseInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  中药材列表数据
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getChineseMedicineListInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询满减商品列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getFullCutPromotionProductListInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  查询特价商品列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getBargainPromotionProductListInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 套餐信息查询接口 for app
 
 @param aCompletionBlock
 */
+ (HJOperationParam *)getDinnerAndProductBySellCodeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 查询秒杀场次信息
 
 @param aCompletionBlock
 */
+ (HJOperationParam *)getSeckillTabBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 查询秒杀活动及商品信息
 
 @param aCompletionBlock
 */
+ (HJOperationParam *)getSeckillActivityBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 @param aCompletionBlock 获取常购清单tab名称
*/
+ (HJOperationParam *)getTabNamesBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 @param aCompletionBlock 通过企业名称获取企业信息
 */
+ (HJOperationParam *)getEnterpriseInfoFromErpWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

@end
