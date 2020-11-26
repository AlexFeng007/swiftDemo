//
//  FKYPublicNetRequestSevice.m
//  FKY
//
//  Created by 寒山 on 2018/8/13.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYPublicNetRequestSevice.h"
#import "FKYPublicServiceNetWork.h"

@implementation FKYPublicNetRequestSevice

#pragma mark -  获取店铺主页（旧版店铺首页）
- (void)getShopIndexBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getShopIndexBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

- (void)getCrmProductListWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock {
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getCrmProductListWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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


#pragma mark -  店铺收藏或者取消
- (void)shopCollectAddCancelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork shopCollectAddCancelBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  店铺是否收藏
- (void)shopIsCollectBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork shopIsCollectBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  收藏店铺列表信息
- (void)shopCollectListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork shopCollectListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  获取销售顾问列表
- (void)getListAdviserBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getListAdviserBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  加入渠道
- (void)applyChannelBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork applyChannelBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  到货通知
- (void)addArrivalNoticeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork addArrivalNoticeBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError)  {
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

#pragma mark -  修改基本资料和企业银行信息
- (void)createSaveEnterpriseDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork createSaveEnterpriseDftBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  首页获取分类列表
- (void)getCategoryListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getCategoryListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  获取个人中心订单数量接口
- (void)getUserTipInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getUserTipInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  查询第三方物流信息
- (void)checkDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork checkDeliveryInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  查询第三方物流信息  承运商等
- (void)queryLogisticsTitleBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork queryLogisticsTitleBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 提交订单接口
- (void)submitShopCartBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork submitShopCartBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  提交一起购订单接口
- (void)createGroupBuyOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork createGroupBuyOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  提交订单之前判断资质
- (void)checkEnterpriseQualificationBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork checkEnterpriseQualificationBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  检查订单接口
- (void)checkOrderPageInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork checkOrderPageInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  一起购检查订单接口
- (void)checkGroupBuyOrderPageBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork checkGroupBuyOrderPageBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 订单详情
- (void)orderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork orderDetailBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  取消待付款自营订单
- (void)cancelOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork cancelOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -   取消已付款订单
- (void)buyerCancelPayedOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork buyerCancelPayedOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 订单列表
- (void)listOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork listOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -    提醒发货
- (void)orderDeliveryRemindBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork orderDeliveryRemindBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 保存发票信息
- (void)saveInvoiceInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveInvoiceInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 延期收货
- (void)delayDeliveryBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork delayDeliveryBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 卖家信息
- (void)selectSalesmanInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork selectSalesmanInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 取消订单更多信息
- (void)cancelOrderInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork cancelOrderInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 新的获取注册时填写的企业类型
-(void)getAllRollTypeNewBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAllRollTypeNewBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取经营范围的药品分类
-(void)getDrugScopeBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getDrugScopeBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 编辑经营范围的药品分类
-(void)saveDrugScopeDftBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveDrugScopeDftBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 物流信息
- (void)getDeliveryInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getDeliveryInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 上传资质
-(void)saveQcDftListBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveQcDftListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取商家银行信息
- (void)getBankInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getBankInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 确认收货列表
- (void)confirmOrderDetailBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork confirmOrderDetailBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 资质审核状态
-(void)getAuditStatusBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAuditStatusBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 确认收货/拒收/补货
- (void)refusedReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork refusedReplenishOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSString class]])  {
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

#pragma mark - 获取支付宝支付参数
- (void)getAppPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAppPayParamsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSString class]])  {
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

#pragma mark - 获取花呗支付参数
- (void)getAlipayHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAlipayHuaBeiPayParamsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSString class]])  {
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

#pragma mark - 获取花呗分期支付参数
- (void)getHuaBeiPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getHuaBeiPayParamsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSString class]])  {
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

#pragma mark - 查询资质信息
-(void)queryEnterpriseByIdBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork queryEnterpriseByIdBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取微信支付参数
- (void)getAppWechatPayParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAppWechatPayParamsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 订单拒收补货列表
- (void)exceptionOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork exceptionOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取H5微信支付参数
- (void)getWechatPayH5ParamsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getWechatPayH5ParamsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 查询原资料（查看原资质文件入口已屏蔽）
-(void)queryPassedEnterpriseInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork queryPassedEnterpriseInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 确定收货  补货
- (void)refusedExceptionReplenishOrderBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork refusedExceptionReplenishOrderBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 提交审核
-(void)submitAuditDftBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork submitAuditDftBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 完善注册信息，获取收货地址
- (void)getReceiverAddressListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getReceiverAddressListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取支付方式列表接口
- (void)getAppPayTypeListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getAppPayTypeListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 常购
- (void)getChangMerchantsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getChangMerchantsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

- (void)getOftenBuyProductListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getOftenBuyProductListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
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

#pragma mark - 完善注册信息，修改收货地址
- (void)updateReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork updateReceiverAddressBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 完善注册信息，删除收货地址
- (void)deleteReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork deleteReceiverAddressBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取sign
- (void)getPaySignBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getPaySignBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSString class]])  {
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

#pragma mark - 商品清单
- (void)getOftenBuyGoodsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getOftenBuyGoodsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 完善注册信息，新增收货地址
- (void)saveReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveReceiverAddressBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 1药贷确认支付接口
- (void)confirmFosunPayBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork confirmFosunPayBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 获取发票信息接口
- (void)getBillInfoByCustIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getBillInfoByCustIdBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取支付订单数据
- (void)getPayInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getPayInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {

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

#pragma mark - 完善注册信息，设置默认收货地址
- (void)updDefReceiverAddressBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork updDefReceiverAddressBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取发票信息接口
- (void)recheckCouponListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork recheckCouponListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 编辑销售设置
- (void)saveDftBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveDftBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 保存基本资质信息
- (void)saveEnterpriseBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork saveEnterpriseBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 首营资质交换提醒
- (void)checkErpInfoBySupplyIdsBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork checkErpInfoBySupplyIdsBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 查看供应商资质
- (void)queryEnterpriseQcListBySupplyIdBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork queryEnterpriseQcListBySupplyIdBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 一起购频道页列表数据
- (void)getTogeterBuyListBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getTogeterBuyListBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 一起购商品详情页数据
- (void)getTogeterBuyDetailDataBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getTogeterBuyDetailDataBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 获取花呗分期列表
- (void)getHuaBeiInstallmentWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getHuaBeiInstallmentWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        
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

#pragma mark - 查询正式表企业信息
- (void)getEnterpriseInfoBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getEnterpriseInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 中药材列表数据
-(void)getChineseMedicineListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getChineseMedicineListInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  套餐信息查询接口
- (void)getDinnerAndProductBySellCodeBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getDinnerAndProductBySellCodeBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 查询满减商品列表
-(void)getFullCutPromotionProductListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getFullCutPromotionProductListInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  查询秒杀场次信息
- (void)getSeckillTabBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getSeckillTabBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 查询特价商品列表
-(void)getBargainPromotionProductListInfoBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getBargainPromotionProductListInfoBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  查询秒杀活动及商品信息
- (void)getSeckillActivityBlockWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getSeckillActivityBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark -  获取常购清单tab名称
- (void)getTabNamesBlockWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getTabNamesBlockWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
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

#pragma mark - 通过企业获取企业信息
- (void)getEnterpriseInfoFromErpWithParam:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYPublicServiceNetWork getEnterpriseInfoFromErpWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
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

#pragma mark - 获取订单列表下方推荐品列表
-(void)getRecommendProductList:(NSDictionary *)param completionBlock:(HJCompletionBlock)aCompletionBlock{
    
}
@end
