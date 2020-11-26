//
//  FKYPublicServiceNetWork.m
//  FKY
//
//  Created by 寒山 on 2018/8/13.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYPublicServiceNetWork.h"

@implementation FKYPublicServiceNetWork

#pragma mark -  获取店铺主页（旧版店铺首页）
+ (HJOperationParam *)getShopIndexBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"druggmp/index" methodName:@"shopSpecPro" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}


+ (HJOperationParam *)getCrmProductListWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock {
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"mobile/dcso" methodName:@"getCrmProductList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}


#pragma mark - 店铺收藏或者取消
+ (HJOperationParam *)shopCollectAddCancelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"druggmp/index" methodName:@"shopCollectAddCancel" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 店铺是否收藏
+ (HJOperationParam *)shopIsCollectBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"druggmp/index" methodName:@"shopIsCollect" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 收藏店铺列表信息
+ (HJOperationParam *)shopCollectListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"druggmp/index" methodName:@"shopCollectList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  获取销售顾问列表
+ (HJOperationParam *)getListAdviserBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/adviser" methodName:@"listAdviser" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  加入渠道
+ (HJOperationParam *)applyChannelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/channel" methodName:@"applyChannel" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  到货通知
+ (HJOperationParam *)addArrivalNoticeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ycapp/notice" methodName:@"arrivalNotice" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  修改基本资料和企业银行信息
+ (HJOperationParam *)createSaveEnterpriseDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"createSaveEnterpriseDft" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  首页获取分类列表
+ (HJOperationParam *)getCategoryListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"druggmp/category/" methodName:@"getCategoryList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  获取个人中心订单数量接口
+ (HJOperationParam *)getUserTipInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"getUserTipInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  查询第三方物流信息
+ (HJOperationParam *)checkDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"queryLogistics" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  查询第三方物流信息  承运商等
+ (HJOperationParam *)queryLogisticsTitleBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"queryLogisticsTitle" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 提交订单接口
+ (HJOperationParam *)submitShopCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"submitShopCart" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  提交一起购订单接口
+ (HJOperationParam *)createGroupBuyOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/groupBuy" methodName:@"createGroupBuyOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  提交订单之前判断资质
+ (HJOperationParam *)checkEnterpriseQualificationBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"checkEnterpriseQualification" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  检查订单接口
+ (HJOperationParam *)checkOrderPageInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"checkOrderPageInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  一起购检查订单接口
+ (HJOperationParam *)checkGroupBuyOrderPageBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/groupBuy" methodName:@"checkGroupBuyOrderPage" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 订单详情
+ (HJOperationParam *)orderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"detail" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  取消待付款自营订单
+ (HJOperationParam *)cancelOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"buyerCancelNotPayedOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 取消已付款订单
+ (HJOperationParam *)buyerCancelPayedOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"buyerCancelPayedOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 订单列表
+ (HJOperationParam *)listOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"list" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 提醒发货
+ (HJOperationParam *)orderDeliveryRemindBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"orderDeliveryRemind/remind" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark-/********卢俊组接口*****************/
#pragma mark - 保存发票信息（y）
+(HJOperationParam *)saveInvoiceInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/invoice" methodName:@"saveInvoiceInfo.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 延期收货
+ (HJOperationParam *)delayDeliveryBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"delayDelivery" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 卖家信息(负责业务人员)（y）
+(HJOperationParam *)selectSalesmanInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"selectSalesmanInfo.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 新的获取注册时填写的企业类型（y）
+(HJOperationParam *)getAllRollTypeNewBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getAllRollTypeNew.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取经营范围的药品分类(y)
+(HJOperationParam *)getDrugScopeBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getDrugScope.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 编辑经营范围的药品分类（y）
+(HJOperationParam *)saveDrugScopeDftBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"saveDrugScopeDft.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 上传资质(参数可能不一样)(y)
+(HJOperationParam *)saveQcDftListBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"saveQcDftList.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 资质审核状态（y）
+(HJOperationParam *)getAuditStatusBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getAuditStatus.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取商家银行信息
+ (HJOperationParam *)getBankInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"orderPay/enterprise" methodName:@"bankInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查询资质信息(y)
+(HJOperationParam *)queryEnterpriseByIdBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"queryEnterpriseById.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取支付宝支付参数
+ (HJOperationParam *)getAppPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"aliappPay" methodName:@"getAppPayParams" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取花呗支付参数
+ (HJOperationParam *)getAlipayHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock {
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"aliappPay" methodName:@"getAppHbFrontPayParams" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取花呗分期支付参数
+ (HJOperationParam *)getHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock {
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"aliappPay" methodName:@"getAppHbPayParams" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查询原资料（查看原资质文件入口已屏蔽/已未使用/未调试）
+(HJOperationParam *)queryPassedEnterpriseInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"queryPassedEnterpriseInfo.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取微信支付参数
+ (HJOperationParam *)getAppWechatPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"wechatPay" methodName:@"getAppWechatPayParams" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 提交审核(y)
+(HJOperationParam *)submitAuditDftBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"submitAuditDft.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取H5微信支付参数
+ (HJOperationParam *)getWechatPayH5ParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"wechatPay" methodName:@"getWechatPayH5Params" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 取消订单更多信息
+ (HJOperationParam *)cancelOrderInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"cancelOrderInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 完善注册信息，获取收货地址(y)
+(HJOperationParam *)getReceiverAddressListBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getReceiverAddressList.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取支付方式列表接口
+ (HJOperationParam *)getAppPayTypeListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"orderPay/V2" methodName:@"getAppPayTypeList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取花呗分期列表
+ (HJOperationParam *)getHuaBeiInstallmentWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock {
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"aliappPay" methodName:@"getAliHbPayInstalmentAmount" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 物流信息
+ (HJOperationParam *)getDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"deliveryInfo" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 完善注册信息，修改收货地址(y)
+ (HJOperationParam *)updateReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"updateReceiverAddress.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取sign
+ (HJOperationParam *)getPaySignBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"pay/another" methodName:@"sign" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 确认收货列表
+ (HJOperationParam *)confirmOrderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"orderDeliveryDetail/confirmOrderDetail" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 1药贷确认支付接口
+ (HJOperationParam *)confirmFosunPayBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"fusonPay" methodName:@"confirmFosunPay" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 完善注册信息，删除收货地址(y)
+ (HJOperationParam *)deleteReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"deleteReceiverAddress.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 确认收货/拒收/补货
+ (HJOperationParam *)refusedReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"orderDeliveryDetail/refusedReplenishOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {

        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 完善注册信息，新增收货地址(y)
+ (HJOperationParam *)saveReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"saveReceiverAddress.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取支付订单数据
+ (HJOperationParam *)getPayInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"orderPay" methodName:@"pay" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 订单拒收补货列表
+ (HJOperationParam *)exceptionOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"exceptionOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 完善注册信息，设置默认收货地址(y)
+ (HJOperationParam *)updDefReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"updDefReceiverAddress.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 确定收货  补货
+ (HJOperationParam *)refusedExceptionReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"orderDeliveryDetail/refusedExceptionReplenishOrder" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 编辑销售设置(相关功能已屏蔽，无法调试)
+ (HJOperationParam *)saveDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"saveDft.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 常购商家
+ (HJOperationParam *)getChangMerchantsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"getChangMerchants" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 常购清单
+ (HJOperationParam *)getOftenBuyProductListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"home/recommend" methodName:@"mix" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 保存基本资质信息（y）
+ (HJOperationParam *)saveEnterpriseBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterprise" methodName:@"saveEnterprise.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 商品清单
+ (HJOperationParam *)getOftenBuyGoodsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"getOftenBuyGoods" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 首营资质交换提醒（已未使用）
+ (HJOperationParam *)checkErpInfoBySupplyIdsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"checkErpInfoBySupplyIds.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 获取发票信息接口
+ (HJOperationParam *)getBillInfoByCustIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/order" methodName:@"getBillInfoByCustId" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查看供应商资质（y）
+ (HJOperationParam *)queryEnterpriseQcListBySupplyIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterprise" methodName:@"queryEnterpriseQcListBySupplyId.json" versionNum:nil type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 重选优惠券
+ (HJOperationParam *)recheckCouponListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/cart" methodName:@"recheckCouponList2" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 一起购频道页列表数据（接口负责人:李煜文）
+ (HJOperationParam *)getTogeterBuyListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ycapp" methodName:@"buyTogetherList" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 一起购商品详情页数据
+ (HJOperationParam *)getTogeterBuyDetailDataBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"promotion/buyTogether" methodName:@"searchDetail.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查询正式表企业信息
+ (HJOperationParam *)getEnterpriseInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getEnterpriseInfo.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 中药材列表数据
+(HJOperationParam *)getChineseMedicineListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"home/mpHome" methodName:@"ChineseMedicine" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  套餐信息查询接口
+ (HJOperationParam *)getDinnerAndProductBySellCodeBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"ycapp/promotion/" methodName:@"collectionDinner" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查询满减商品列表
+(HJOperationParam *)getFullCutPromotionProductListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"promotion/fullcut" methodName:@"getFullCutPromotionProductByCustId.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  查询秒杀场次信息
+ (HJOperationParam *)getSeckillTabBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"promotion/seckill" methodName:@"getSeckillTab" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark - 查询特价商品列表
+(HJOperationParam *)getBargainPromotionProductListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"promotion/bargain" methodName:@"getBargainPromotionProductByCustId.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  查询秒杀活动及商品信息
+ (HJOperationParam *)getSeckillActivityBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"promotion/seckill" methodName:@"getSeckillActivity" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  获取常购清单tab名称
+ (HJOperationParam *)getTabNamesBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"home/recommend" methodName:@"tabNames" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

#pragma mark -  通过企业名称获取企业信息 
// http://gateway-b2b.fangkuaiyi.com/usermanage/enterpriseInfo/getEnterpriseInfoByErp.json
+ (HJOperationParam *)getEnterpriseInfoFromErpWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"usermanage/enterpriseInfo" methodName:@"getEnterpriseInfoByErp.json" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

@end
