//
//  FKYProductDetailManage.m
//  FKY
//
//  Created by mahui on 2017/2/15.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYProductDetailManage.h"


@implementation FKYProductDetailManage

#pragma mark - CellTypeList

+ (NSArray *)getListForCellType
{    
    return @[
        @(PDCellTypeBanner),               // 轮播图
        @(PDCellTypePrice),                // 价格
        @(PDCellTypeNoBuy),                // 不可购买之缺少经营范围
        @(PDCellTypeWhiteEmptyNoPrice),    // [白底空行]...<无价格时对名称cell的UI优化>
        @(PDCellTypeName),                 // 名称
        @(PDCellTypeTitle),                // 标题(描述)
        @(PDCellTypeLimit),                // 限购
        @(PDCellTypeWhiteEmpty),           // [白底空行]
        @(PDCellTypeDate),                 // 基本信息...<包括生产厂家、批准文号、有效期至、生产日期>
        @(PDCellTypeCosmetics),            // 化妆品说明
        @(PDCellTypeStock),                // 库存 & 最小批零包装 & 限购
        @(PDCellTypeEmptyPromotion),       // [空行]
        @(PDCellTypePromotionTitle),       // 促销标题<已隐藏>
        
        @(PDCellTypeVip),                  // vip...<促销>
        @(PDCellTypePackageRate),          // 单品包邮...<促销>
        @(PDCellTypeCombo),                // 套餐...<促销>
        @(PDCellTypeFullReduce),           // 满减...<促销>
        @(PDCellTypeFullGift),             // 满赠...<促销>
        @(PDCellTypeFullDiscount),         // 满折...<促销>
        @(PDCellTypeRebate),               // 返利...<促销>
        @(PDCellTypeProtocolRebate),       // 协议返利...<促销>
        @(PDCellTypeBounty),               // 奖励金...<促销>
        @(PDCellTypeSlowPayOrHoldPrice),   //慢必赔or保价
        
        @(PDCellTypeEmptyCoupon),          // [空行]
        @(PDCellTypeCoupon),               // 优惠券
        @(PDCellTypeEmptyGroup),           // [空行]
        @(PDCellTypeGroup),                // 套餐
        @(PDCellTypeEmpty),                // [空行]
        @(PDCellTypeShop),                 // 店铺(供应商)
        @(PDCellTypeEmptyHotSale),         // [空行]
        //@(PDCellTypeRecommend)             // 同品热卖...<注：由于iOS13真机上会crash，故将同品热卖从cell改成tablefooterview>
    ];
}


#pragma mark - ShowOrHide

// 轮播图cell是否显示
+ (BOOL)showBannerCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}

// 价格cell是否显示
+ (BOOL)showPriceCell:(FKYProductObject *)model
{
    if (model.priceInfo.showPrice == true) {
        //显示价格
        return true;
    }else {
        //不显示价格
        return false;
    }
    // 只要是不可购买，则统一不展示价格，但显示“不可购买”文描
//    if (model.priceInfo.productStatus == NO) {
//        return NO;
//    }
//
//    if (model && model.priceInfo && model.priceInfo.status &&
//        ![model.priceInfo.status  isEqual: @"-6"] &&
//        ![model.priceInfo.status  isEqual: @"-2"] &&
//        ![model.priceInfo.status  isEqual: @"-4"]) {
//        return YES;
//    }
//
//    return NO;
}

// 不可购买之缺少经营范围cell是否显示
+ (BOOL)showNoBuyCell:(FKYProductObject *)model
{
    if (model.priceInfo == nil) {
        return false;
    }else {
        // 显示价格或未返回显示不可购买原因
        if (model.priceInfo.showPrice == true || model.priceInfo.priceText.length == 0) {
            return false;
        }
        return true;
    }
}

// 名称cell是否显示
+ (BOOL)showNameCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}

// 标题cell是否显示
+ (BOOL)showTitleCell:(FKYProductObject *)model
{
    if (model && model.title && model.title.length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

// 规格cell是否显示
+ (BOOL)showSpecificationCell:(FKYProductObject *)model
{
    if (model && model.spec && model.spec.length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

// 限购cell是否显示
+ (BOOL)showLimitCell:(FKYProductObject *)model
{
    if (model && model.productLimitInfo && model.productLimitInfo.limitInfo && model.productLimitInfo.limitInfo.length > 0) {
        // 有(每日/周)限购说明
        return YES;
    }
    if (model && model.productPromotion && model.productPromotion.limitText && model.productPromotion.limitText.length > 0) {
        // 有特价限购说明
        return YES;
    }
    if (model.vipPromotionInfo != nil && model.vipPromotionInfo.vipLimitText != nil && model.vipPromotionInfo.vipLimitText.length > 0){
        // 会员价限购
        return YES;
    }
    
    return NO;
}

// 基本信息cell是否显示
+ (BOOL)showBaseInfoCell:(FKYProductObject *)model
{
    if (model) {
        if (model.factoryName && model.factoryName.length > 0) {
            return YES;
        }
        if (model.approvalNum && model.approvalNum.length > 0) {
            return YES;
        }
        if ([model bigPackageText] && [model bigPackageText].length > 0) {
            return YES;
        }
        if (model.drugFormType && model.drugFormType.length > 0) {
            return YES;
        }
        if (model.deadline && model.deadline.length > 0) {
            return YES;
        }
        if (model.producedTime && model.producedTime.length > 0) {
            return YES;
        }
    }
    
    return NO;
}

// 化妆品说明cell是否显示
+ (BOOL)showCosmeticsCell:(FKYProductObject *)model
{
    if (model) {
        if (model.cosmeticsInfo && model.cosmeticsInfo.length > 0) {
            return YES;
        }
    }
    
    return NO;
}

// 库存cell是否显示
+ (BOOL)showStockCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}

// 优惠券cell是否显示
+ (BOOL)showCouponCell:(FKYProductObject *)model
{
    // 需判断用户是否登录
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        // 未登录，不显示
        return NO;
    }
    
    if (model && model.couponList && model.couponList.count > 0) {
        // 只有在显示价格的情况下，才显示优惠券~!@
        if (model.priceInfo.status && ([model.priceInfo.status isEqual: @"0"] || [model.priceInfo.status  isEqual: @"-5"])) {
            // 0 or -5时，一定会显示价格
            return YES;
        }
        else {
            // 其它状态下，不显示价格
            return NO;
        }
    }
    
    return NO;
}

// 促销cell是否显示
+ (BOOL)showPromotionCell:(FKYProductObject *)model
{
    if (model && [model promotionCount] > 0) {
        // 满减
        return YES;
    }
    if (model && [model fullGiftCount] > 0) {
        // 满赠
        return YES;
    }
    if (model && model.rebateInfo && model.rebateInfo.isRebate && model.rebateInfo.isRebate.integerValue == 1 && model.rebateInfo.rebateDesc && model.rebateInfo.rebateDesc.length > 0) {
        // 返利
        return YES;
    }
    if (model && model.vipModel && model.vipModel.vipSymbol != 2) {
        // vip
        return YES;
    }
    if (model && model.dinnerInfo && model.dinnerInfo.dinnerList &&  model.dinnerInfo.dinnerList.count > 0) {
        // 套餐
        for (FKYProductGroupModel *dinner in model.dinnerInfo.dinnerList) {
            if (dinner.promotionRule.integerValue == 2) {
                return YES;
            }
        } // for
    }
    if (model && [model fullDiscountCount] > 0) {
        // 满折
        return YES;
    }
    if (model && model.rebateProtocol && model.rebateProtocol.protocolRebate) {
        // 协议返利金
        return YES;
    }
    
    return NO;
}

// 促销之vip-cell是否显示
+ (BOOL)showPromotionVipCell:(FKYProductObject *)model
{
    if (model && model.vipModel && model.vipModel.vipSymbol != 2) {
        // vip
        return YES;
    }
    
    return NO;
}
// 促销之单品包邮或者其他入口列表里的cell是否显示
+ (BOOL)showPromotionEntranceInfoCell:(FKYProductObject *)model entranceType:(NSNumber *)entranceType
{
    NSArray<FKYProductEntranceInfoObject *> *filterArray = [model.entranceInfos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entranceType == %@",entranceType]];
    if (filterArray.count == 0) {
        return NO;
    }
    
    return YES;
}

// 促销之满减cell是否显示
+ (BOOL)showPromotionFullReduceCell:(FKYProductObject *)model
{
    if (model && [model promotionCount] > 0) {
        // 满减
        return YES;
    }
    
    return NO;
}

// 促销之满赠cell是否显示
+ (BOOL)showPromotionFullGiftCell:(FKYProductObject *)model
{
    if (model && [model fullGiftCount] > 0) {
        // 满赠
        return YES;
    }
    
    return NO;
}

// 促销之返利cell是否显示
+ (BOOL)showPromotionRebateCell:(FKYProductObject *)model
{
    if (model && model.rebateInfo.isRebate.integerValue == 1 && model.rebateInfo.rebateDesc && model.rebateInfo.rebateDesc.length > 0) {
        // 返利
        return YES;
    }
    
    return NO;
}

// 促销之套餐(固定套餐和搭配套餐)cell是否显示
+ (BOOL)showPromotionComboCell:(FKYProductObject *)model
{
    if (model && model.dinnerInfo && model.dinnerInfo.dinnerList &&  model.dinnerInfo.dinnerList.count > 0) {
        //        for (FKYProductGroupModel *dinner in model.dinnerProInfos) {
        //            if (dinner.promotionRule.integerValue == 2) {
        //                return YES;
        //            }
        //        }
        return YES;
    }
    else {
        return NO;
    }
}
//判断是搭配套餐还是固定套餐
+ (BOOL)isFixedComboView:(FKYProductObject *)model{
    if (model && model.dinnerInfo && model.dinnerInfo.dinnerList &&  model.dinnerInfo.dinnerList.count > 0) {
        for (FKYProductGroupModel *dinner in model.dinnerInfo.dinnerList) {
            if (dinner.promotionRule.integerValue == 2) {
                return YES;
            }
        }
        return NO;
    }
    else {
        return NO;
    }
}

// 促销之满折cell是否显示
+ (BOOL)showPromotionFullDiscountCell:(FKYProductObject *)model
{
    if (model && [model fullDiscountCount] > 0) {
        // 满折
        return YES;
    }
    
    return NO;
}
// 促销之奖励金cell是否显示
+ (BOOL)showPromotionBountyCell:(FKYProductObject *)model
{
    if (model && model.bonusTag  && model.bonusTag == true) {
        // 奖励金
        return YES;
    }
    
    return NO;
}
// 促销之协议返利金cell是否显示
+ (BOOL)showPromotionProtocolRebateCell:(FKYProductObject *)model
{
    if (model && model.rebateProtocol && model.rebateProtocol.protocolRebate) {
        return YES;
    }
    else {
        return NO;
    }
}

// 套餐cell是否显示
+ (BOOL)showGroupCell:(FKYProductObject *)model
{
    if (model && model.dinnerInfo && model.dinnerInfo.dinnerList && model.dinnerInfo.dinnerList.count > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

// 其它信息cell是否显示
+ (BOOL)showOtherInfoCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}

// 供应商cell是否显示
//+ (BOOL)showSupplierCell:(FKYProductObject *)model
//{
//    if (model) {
//        return YES;
//    }
//
//    return NO;
//}

// 店铺(供应商)cell是否显示
+ (BOOL)showShopCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}

// 同品热卖cell是否显示
+ (BOOL)showRecommendCell:(FKYProductObject *)model
{
    if (model && model.recommendModel && model.recommendModel.hotSell && model.recommendModel.hotSell.productList && model.recommendModel.hotSell.productList.count > 0) {
        return YES;
    }
    
    return NO;
}

// 没有更多cell是否显示
+ (BOOL)showNoMoreCell:(FKYProductObject *)model
{
    if (model) {
        return YES;
    }
    
    return NO;
}


#pragma mark - CellHeight

// 计算轮播图高度
+ (CGFloat)getBannerCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showBannerCell:model]) {
        // 显示轮播图
        return FKYWH(220);
    }
    
    return CGFLOAT_MIN;
}

// 计算价格高度
+ (CGFloat)getPriceCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showPriceCell:model]){
        // 展示价格
        float showPrice = 0;
        //
        if (model.productPromotion && model.productPromotion.promotionPrice.floatValue > 0) {
            // 活动价格
            showPrice = model.productPromotion.promotionPrice.floatValue;
        }
        else if (model.vipModel && model.vipModel.vipSymbol != 2 &&
                 model.vipPromotionInfo && model.vipPromotionInfo.vipPromotionId &&
                 model.vipPromotionInfo.visibleVipPrice.floatValue > 0) {
            // vip
            if (model.vipModel.vipSymbol == 1) {
                // 会员
                showPrice = model.vipPromotionInfo.visibleVipPrice.floatValue;
            }
            else {
                // 非会员
                showPrice = model.priceInfo.price.floatValue;
            }
        }
        else if (model.priceInfo.price.floatValue > 0) {
            // 商品价格
            showPrice = model.priceInfo.price.floatValue;
        }
        
        if (model.isZiYingFlag == 1 && model.priceInfo.recommendPrice.floatValue > 0 && model.priceInfo.recommendPrice.floatValue > showPrice) {
            // 需展示零售价和毛利
            return FKYWH(40+17+4);
        }
        // 不展示零售价和毛利
        return FKYWH(40);
    }else {
        return CGFLOAT_MIN;
    }
    
//    if ([FKYProductDetailManage showPriceCell:model]) {
//        // 显示价格
//        if ([model.priceInfo.status  isEqual: @"-1"] ||
//            [model.priceInfo.status  isEqual: @"-3"] ||
//            [model.priceInfo.status  isEqual: @"-7"] ||
//            [model.priceInfo.status  isEqual: @"-9"] ||
//            [model.priceInfo.status  isEqual: @"-10"] ||
//            [model.priceInfo.status  isEqual: @"-11"] ||
//            [model.priceInfo.status  isEqual: @"-12"] ||
//            model.isZiYingFlag != 1) {
//            return FKYWH(40);
//        }
//        else {
//            // 展示价格
//            float showPrice = 0;
//            //
//            if (model.productPromotion && model.productPromotion.promotionPrice.floatValue > 0) {
//                // 活动价格
//                showPrice = model.productPromotion.promotionPrice.floatValue;
//            }
//            else if (model.vipModel && model.vipModel.vipSymbol != 2 &&
//                     model.vipPromotionInfo && model.vipPromotionInfo.vipPromotionId &&
//                     model.vipPromotionInfo.visibleVipPrice.floatValue > 0) {
//                // vip
//                if (model.vipModel.vipSymbol == 1) {
//                    // 会员
//                    showPrice = model.vipPromotionInfo.visibleVipPrice.floatValue;
//                }
//                else {
//                    // 非会员
//                    showPrice = model.priceInfo.price.floatValue;
//                }
//            }
//            else if (model.priceInfo.price.floatValue > 0) {
//                // 商品价格
//                showPrice = model.priceInfo.price.floatValue;
//            }
//
//            if (model.priceInfo.recommendPrice.floatValue > 0 && model.priceInfo.recommendPrice.floatValue > showPrice) {
//                // 需展示零售价和毛利
//                return FKYWH(40+17+4);
//            }
//            // 不展示零售价和毛利
//            return FKYWH(40);
//        }
//    }
    
   // return CGFLOAT_MIN;
}

// 计算不可购买之缺少经营范围高度
+ (CGFloat)getNoBuyCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showNoBuyCell:model]) {
        // 显示
        if (model && model.priceInfo.status && [model.priceInfo.status  isEqual: @"2"] && model.drugSecondCategoryName.length > 0) {
            return FKYWH(62);
        }
        else {
            return FKYWH(40);
        }
    }
    return CGFLOAT_MIN;
}

// 计算名称高度
+ (CGFloat)getNameCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showNameCell:model]) {
        // 显示名称
        //        CGFloat height = FKYWH(38);
        //
        //        // 套餐是否打标
        //        BOOL hasGroup = [FKYProductDetailManage showGroupCell:model];
        //        // 特价是否打标
        //        BOOL hasSpecial = NO;
        //        // 需要增加的宽度
        //        CGFloat width = 0;
        //
        //        // 商品状态
        //        int status = 0;
        //        if (model.statusDesc) {
        //            status = model.statusDesc.intValue;
        //        }
        //        if (status == 0 || status == -5) {
        //            // 正常 or 缺货
        //            if (model.productPromotion != nil && model.productPromotion.promotionId != nil) {
        //                hasSpecial = YES;
        //            }
        //        }
        //        else if (status == -1) {
        //            // 未登录
        //            if (model.productPromotion != nil && model.productPromotion.promotionId != nil && model.productPromotion.priceVisible == 1) {
        //                hasSpecial = YES;
        //            }
        //        }
        //        else {
        //            // 其它
        //            hasSpecial = NO;
        //        }
        //
        //        // 有套餐标签
        //        if (hasGroup) {
        //            width += FKYWH(40);
        //        }
        //        // 有特价标签
        //        if (hasSpecial) {
        //            width += FKYWH(40);
        //        }
        
        // 商品名称...<名称 + 规格>
        NSString *name = @"";
        if (model.shortName && model.shortName.length > 0) {
            name = model.shortName;
        }
        if (model.spec && model.spec.length > 0) {
            name = [NSString stringWithFormat:@"%@ %@", name, model.spec];
        }
        
        if (model.isZiYingFlag == 1) {
            // 若是自营，则需要加自营标签
            if (model.ziyingWarehouseName.length) {
                name = [NSString stringWithFormat:@"自营 %@%@", model.ziyingWarehouseName,name];
            }else {
                name = [NSString stringWithFormat:@"自营 %@", name];
            }
            
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:FKYWH(17)],
                                    NSParagraphStyleAttributeName : paragraphStyle};
        CGFloat width = SCREEN_WIDTH - FKYWH(10) * 2;
        CGSize size = [name boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil].size;
        CGFloat height = ceil(size.height) + 2 + FKYWH(2) * 2;
        if (height >= FKYWH(208)) {
            // 最多只显示10行
            height = FKYWH(208);
        }
        if (height <= FKYWH(28)) {
            // 最小高度...<一行>
            height = FKYWH(28);
        }
        
        return height;
    }
    
    return CGFLOAT_MIN;
}

// 计算标题高度
+ (CGFloat)getTitleCellHeight:(FKYProductObject *)model
{
    NSString *oldStr = @"";
    if (model&&model.title&&model.title.length >0) {
        oldStr = [oldStr stringByAppendingString:model.title];
    }
    if (model&&model.giftLinkTxt&&model.giftLinkTxt.length >0) {
        oldStr = [oldStr stringByAppendingString:model.giftLinkTxt];
    }
    if (oldStr.length > 0) {
        // 显示标题
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = FKYWH(4);
        NSDictionary *attribute = @{NSFontAttributeName : FKYSystemFont(FKYWH(13)),
                                    NSParagraphStyleAttributeName : paragraphStyle};
        CGFloat width = SCREEN_WIDTH - FKYWH(10) * 2;
        CGSize size = [oldStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        CGFloat height = ceil(size.height) + 2 + FKYWH(2) * 2;
        //        if (height > FKYWH(58)) {
        //            // 最多只显示3行
        //            height = FKYWH(58);
        //        }
        if (height < FKYWH(22)) {
            // 最小高度
            height = FKYWH(22);
        }
        return height;
    }
    
    return CGFLOAT_MIN;
}

// 计算规格高度
+ (CGFloat)getSpecificationCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showSpecificationCell:model]) {
        // 显示规格
        return FKYWH(22);
    }
    
    return CGFLOAT_MIN;
}

// 计算限购高度
+ (CGFloat)getLimitCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showLimitCell:model]) {
        // 显示限购
        float cellHeight = FKYWH(5);
        float maxW = FKYWH(0);
        if ((model.productPromotion != nil && model.productPromotion.limitText != nil && model.productPromotion.limitText.length > 0)||(model.vipPromotionInfo != nil && model.vipPromotionInfo.vipLimitText != nil && model.vipPromotionInfo.vipLimitText.length > 0)){
            // 特价限购
            if ((model.productPromotion != nil && model.productPromotion.limitText != nil && model.productPromotion.limitText.length > 0)){
                NSString *descStr = [NSString stringWithFormat:@" %@ ",model.productPromotion.limitText];
                float descWidth = [descStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - FKYWH(20),FKYWH(18)) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FKYWH(12)]} context:nil].size.width;
                maxW += (descWidth + FKYWH(4));
            }else if((model.vipPromotionInfo != nil && model.vipPromotionInfo.vipLimitText != nil && model.vipPromotionInfo.vipLimitText.length > 0)){
                NSString *descStr = [NSString stringWithFormat:@" %@ ",model.vipPromotionInfo.vipLimitText];
                float descWidth = [descStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - FKYWH(20),FKYWH(18)) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FKYWH(12)]} context:nil].size.width;
                maxW += (descWidth + FKYWH(4));
            }
            cellHeight += FKYWH(23);
        }
        if ( model.productLimitInfo.limitInfo != nil &&  model.productLimitInfo.limitInfo.length > 0){
            if (maxW == 0){
                cellHeight += FKYWH(23);
            }else{
                NSString *descStr = [NSString stringWithFormat:@" %@ ",model.productLimitInfo.limitInfo];
                float descWidth = [descStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - FKYWH(20),FKYWH(18)) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FKYWH(12)]} context:nil].size.width;
                if ((descWidth + maxW + FKYWH(10))>SCREEN_WIDTH - FKYWH(20)){
                    cellHeight += FKYWH(23);
                }
            }
            
        }
        return cellHeight;
    }
    
    return CGFLOAT_MIN;
}

// 计算基本信息高度
+ (CGFloat)getBaseInfoCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showBaseInfoCell:model]) {
        // 显示基本信息
        CGFloat height = 0;
        CGFloat step = FKYWH(25);
        if (model.factoryName && model.factoryName.length > 0) {
            CGSize contentSize = [model.factoryName sizeWithFont:[UIFont systemFontOfSize:FKYWH(13)] constrainedToWidth:SCREEN_WIDTH - FKYWH(86)];
            height += (((contentSize.height + (FKYWH(12))) > step) ? (contentSize.height + (FKYWH(12))) : step );
        }
        if (model.approvalNum && model.approvalNum.length > 0) {
            height += step;
        }
        BOOL hasFlag = NO;
        if ([model bigPackageText] && [model bigPackageText].length > 0) {
            hasFlag = YES;
        }
        if (model.drugFormType && model.drugFormType.length > 0) {
            hasFlag = YES;
        }
        if (hasFlag) {
            height += step;
        }
        hasFlag = NO;
        if (model.deadline && model.deadline.length > 0) {
            hasFlag = YES;
        }
        if (model.producedTime && model.producedTime.length > 0) {
            hasFlag = YES;
        }
        if (hasFlag) {
            height += step;
        }
        if (height > 0) {
            return height += FKYWH(7) * 2;
        }
    }
    
    return CGFLOAT_MIN;
}

// 计算化妆品说明高度
+ (CGFloat)getCosmeticsCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showCosmeticsCell:model]) {
        // 显示化妆品说明
        NSString *txt = @"";
        if (model && model.cosmeticsInfo && model.cosmeticsInfo.length > 0) {
            txt = model.cosmeticsInfo;
        }
        else {
            return CGFLOAT_MIN;
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:FKYWH(12)],
                                    NSParagraphStyleAttributeName : paragraphStyle};
        CGFloat width = SCREEN_WIDTH - FKYWH(10) * 2;
        CGSize size = [txt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil].size;
        CGFloat height = ceil(size.height) + 2 + FKYWH(8);
        if (height >= FKYWH(60)) {
            // 最多只显示3行
            height = FKYWH(60);
        }
        if (height <= FKYWH(28)) {
            // 最小高度...<一行>
            height = FKYWH(28);
        }
        
        return height;
    }
    
    return CGFLOAT_MIN;
}

// 计算库存高度
+ (CGFloat)getStockCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showStockCell:model]) {
        // 显示库存
        //return FKYWH(35);
        
        if (model && model.shareStockDesc && model.shareStockDesc.length > 0) {
            // 有共享库存文描，则需要展示楼层
            return FKYWH(35) + FKYWH(40);
        }
        return FKYWH(35);
    }
    
    return CGFLOAT_MIN;
}

// 计算优惠券高度
+ (CGFloat)getCouponCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showCouponCell:model]) {
        // 显示优惠券
        //return [FKYProductDetailManage calculateCouponCellHeight:model];
        
        // 因为各优惠券item的宽度固定，所以可以直接计算cell高度
        //        if (model && model.couponList && model.couponList.count > 0) {
        //            // 只有在显示价格的情况下，才显示优惠券~!@
        //            if (model.statusDesc && (model.statusDesc.intValue == 0 || model.statusDesc.intValue == -5)) {
        //                // 0 or -5时，一定会显示价格
        //                NSInteger count = model.couponList.count;
        //                NSInteger row = count / 3;
        //                NSInteger offset = count % 3;
        //                if (offset > 0) {
        //                    row += 1;
        //                }
        //                return FKYWH(15) * 2 + FKYWH(20) * row + FKYWH(10) * (row - 1);
        //            }
        //        }
        
        // 优惠券cell固定只显示一行，最多三个item，所以高度固定。
        return FKYWH(50);
    }
    
    return CGFLOAT_MIN;
}

// 计算促销高度...<暂不使用>
//+ (CGFloat)getPromotionCellHeight:(FKYProductObject *)model
//{
//    if ([FKYProductDetailManage showPromotionCell:model]) {
//        // 显示库存
//        CGFloat height = FKYWH(35);
//        if (model && [model promotionCount] > 0) {
//            // 满减
//            height += FKYWH(40) * [model promotionCount];
//        }
//        if (model && [model fullGiftCount] > 0) {
//            // 满赠
//            height += FKYWH(40) * [model fullGiftCount];
//        }
//        if (model && model.isRebate.integerValue == 1 && model.rebateDesc.length > 0) {
//            // 返利金
//            height += FKYWH(40);
//        }
//        if (model && model.dinnerInfo.dinnerList &&  model.dinnerInfo.dinnerList.count > 0) {
//            for (FKYProductGroupModel *dinner in model.dinnerInfo.dinnerList) {
//                if (dinner.promotionRule.integerValue == 2){
//                    // 套餐
//                    height += FKYWH(40);
//                }
//            }
//        }
//        return height;
//    }
//    
//    return CGFLOAT_MIN;
//}

// 计算套餐高度
+ (CGFloat)getGroupCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showGroupCell:model]) {
        // 显示套餐
        return FKYWH(200);
    }
    
    return CGFLOAT_MIN;
}

// 计算其它信息高度
//+ (CGFloat)getOtherInfoCellHeight:(FKYProductObject *)model
//{
//    if ([FKYProductDetailManage showOtherInfoCell:model]) {
//        // 显示其它信息
//        if (model.producedTime != nil && [model.producedTime length] > 0) {
//            // 生产日期
//            return FKYWH(170 + 25);
//        }
//        else {
//            return FKYWH(170);
//        }
//        
//    }
//    
//    return CGFLOAT_MIN;
//}

// 计算供应商高度
//+ (CGFloat)getSupplierCellHeight:(FKYProductObject *)model
//{
//    if ([FKYProductDetailManage showSupplierCell:model]) {
//        // 显示供应商
//        return FKYWH(45);
//    }
//
//    return CGFLOAT_MIN;
//}

// 计算店铺(供应商)高度
+ (CGFloat)getShopCellHeight:(FKYProductObject *)model withDiscountModel:(FKYDiscountPackageModel *)discountModel
{
    if ([FKYProductDetailManage showShopCell:model]) {
        // 显示供应商
        return [PDShopCell getCellHeight:model discountModel:discountModel];
    }
    
    return CGFLOAT_MIN;
}

// 计算同品热卖高度
+ (CGFloat)getRecommendCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showRecommendCell:model]) {
        // 显示供应商
        return [PDRecommendCell getCellHeight:model.recommendModel.hotSell];
    }
    
    return CGFLOAT_MIN;
}

// 计算没有更多高度
+ (CGFloat)getNoMoreCellHeight:(FKYProductObject *)model
{
    if ([FKYProductDetailManage showNoMoreCell:model]) {
        // 显示供应商
        return FKYWH(54);
    }
    
    return CGFLOAT_MIN;
}


#pragma mark - CouponCellHeight

// 计算优惠券高度...<不再使用，无需再手动计算高度>
+ (CGFloat)calculateCouponCellHeight:(FKYProductObject *)model
{
    // 优惠券个数
    NSInteger number = (model && model.couponList && model.couponList.count > 0) ? model.couponList.count : 0;
    if (number > 0) {
        // 有优惠券
        
        // 说明：每行最多放3个，最少放1个
        
        if (number == 1) {
            return FKYWH(40);
        }
        else if (number == 2) {
            // 计算一行是否放得下2个
            CouponTempModel *item0 = model.couponList[0];
            CouponTempModel *item1 = model.couponList[1];
            CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
            CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
            CGFloat total = SCREEN_WIDTH - FKYWH(97);
            CGFloat width = width0 + width1 + FKYWH(5);
            if (total >= width) {
                // 一行放得下2个
                return FKYWH(40);
            }
            else {
                // 一行放不下2个
                return FKYWH(70);
            }
            
            // 默认1行
            return FKYWH(40);
        }
        else if (number == 3) {
            // 计算一行是否放得下3个
            CouponTempModel *item0 = model.couponList[0];
            CouponTempModel *item1 = model.couponList[1];
            CouponTempModel *item2 = model.couponList[2];
            CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
            CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
            CGFloat width2 = [PDCouponItemCCell getCouponItemWidth:item2];
            CGFloat total = SCREEN_WIDTH - FKYWH(97);
            CGFloat width = width0 + width1 + width2 + FKYWH(5) * 2;
            if (total >= width) {
                // 一行放得下3个
                return FKYWH(40);
            }
            else {
                // 一行放不下3个
                
                // 再计算第一行是否放得下2个
                CouponTempModel *item0 = model.couponList[0];
                CouponTempModel *item1 = model.couponList[1];
                CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                CGFloat total = SCREEN_WIDTH - FKYWH(97);
                CGFloat width = width0 + width1 + FKYWH(5);
                if (total >= width) {
                    // 第一行放得下2个
                    return FKYWH(70);
                }
                else {
                    // 第一行放不下2个
                    
                    // 再计算第二行是否放得下2个
                    CouponTempModel *item0 = model.couponList[1];
                    CouponTempModel *item1 = model.couponList[2];
                    CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                    CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                    CGFloat total = SCREEN_WIDTH - FKYWH(97);
                    CGFloat width = width0 + width1 + FKYWH(5);
                    if (total >= width) {
                        // 第二行放得下2个
                        return FKYWH(70);
                    }
                    else {
                        // 第二行放不下2个
                        return FKYWH(100);
                    }
                }
            }
            
            // 默认2行
            return FKYWH(70);
        }
        else { // >= 4
            // 计算一行是否放得下3个
            CouponTempModel *item0 = model.couponList[0];
            CouponTempModel *item1 = model.couponList[1];
            CouponTempModel *item2 = model.couponList[2];
            CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
            CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
            CGFloat width2 = [PDCouponItemCCell getCouponItemWidth:item2];
            CGFloat total = SCREEN_WIDTH - FKYWH(97);
            CGFloat width = width0 + width1 + width2 + FKYWH(5) * 2;
            if (total >= width) {
                // 一行放得下3个
                return FKYWH(70);
            }
            else {
                // 一行放不下3个
                
                // 再计算第一行是否放得下2个
                CouponTempModel *item0 = model.couponList[0];
                CouponTempModel *item1 = model.couponList[1];
                CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                CGFloat total = SCREEN_WIDTH - FKYWH(97);
                CGFloat width = width0 + width1 + FKYWH(5);
                if (total >= width) {
                    // 第一行放得下2个
                    
                    // 再计算第二行是否放得下2个
                    CouponTempModel *item0 = model.couponList[2];
                    CouponTempModel *item1 = model.couponList[3];
                    CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                    CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                    CGFloat total = SCREEN_WIDTH - FKYWH(97);
                    CGFloat width = width0 + width1 + FKYWH(5);
                    if (total >= width) {
                        // 第二行放得下2个
                        return FKYWH(70);
                    }
                    else {
                        // 第二行放不下2个
                        return FKYWH(100);
                    }
                }
                else {
                    // 第一行放不下2个
                    
                    // 再计算第二行是否放得下3个
                    CouponTempModel *item0 = model.couponList[1];
                    CouponTempModel *item1 = model.couponList[2];
                    CouponTempModel *item2 = model.couponList[3];
                    CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                    CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                    CGFloat width2 = [PDCouponItemCCell getCouponItemWidth:item2];
                    CGFloat total = SCREEN_WIDTH - FKYWH(97);
                    CGFloat width = width0 + width1 + width2 + FKYWH(5) * 2;
                    if (total >= width) {
                        // 第二放得下3个
                        return FKYWH(70);
                    }
                    else {
                        // 第二行放不下3个
                        
                        // 再计算第二行是否放得下2个
                        CouponTempModel *item0 = model.couponList[1];
                        CouponTempModel *item1 = model.couponList[2];
                        CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                        CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                        CGFloat total = SCREEN_WIDTH - FKYWH(97);
                        CGFloat width = width0 + width1 + FKYWH(5);
                        if (total >= width) {
                            // 第二行放得下2个
                            return FKYWH(100);
                        }
                        else {
                            // 第二行放不下2个
                            
                            // 再计算第三行是否放得下2个
                            CouponTempModel *item0 = model.couponList[2];
                            CouponTempModel *item1 = model.couponList[3];
                            CGFloat width0 = [PDCouponItemCCell getCouponItemWidth:item0];
                            CGFloat width1 = [PDCouponItemCCell getCouponItemWidth:item1];
                            CGFloat total = SCREEN_WIDTH - FKYWH(97);
                            CGFloat width = width0 + width1 + FKYWH(5);
                            if (total >= width) {
                                // 第三行放得下2个
                                return FKYWH(100);
                            }
                            else {
                                // 第三行放不下2个
                                return FKYWH(130);
                            }
                        }
                    }
                }
            }
            
            // 默认2行
            return FKYWH(70);
        }
        
        // 以上为复杂处理
        /********************************************/
        // 以下为简单处理
        
        //        if (number < 3) {
        //            // <1 or 2> 一行至少显示2个
        //            return FKYWH(40);
        //        }
        //        else if (number >= 4) {
        //            // <4 or more> 最多两行...<最多只显示4个>
        //            return FKYWH(70);
        //        }
        //        else {
        //            // <3> 当为3时，需根据屏幕宽度来判断是否一行可以放得下
        ////            CGFloat total = SCREEN_WIDTH - FKYWH(97);
        ////            CGFloat width = FKYWH(88) * 3 + FKYWH(10);
        ////            if (total >= width) {
        ////                // 一行放得下3个
        ////                return FKYWH(40);
        ////            }
        ////            else {
        ////                // 一行放不下3个
        ////                return FKYWH(70);
        ////            }
        //
        //            // 计算一行是否放得下3个
        //            CouponTempModel *item0 = model.couponList[0];
        //            CouponTempModel *item1 = model.couponList[1];
        //            CouponTempModel *item2 = model.couponList[2];
        //            CGFloat width0 = [FKYPDCouponItemCCell getCouponItemWidth:item0];
        //            CGFloat width1 = [FKYPDCouponItemCCell getCouponItemWidth:item1];
        //            CGFloat width2 = [FKYPDCouponItemCCell getCouponItemWidth:item2];
        //            CGFloat total = SCREEN_WIDTH - FKYWH(97);
        //            CGFloat width = width0 + width1 + width2 + FKYWH(5) * 2;
        //            if (total >= width) {
        //                // 一行放得下3个
        //                return FKYWH(40);
        //            }
        //            else {
        //                // 一行放不下3个
        //                return FKYWH(70);
        //            }
        //        }
        //
        //        // 默认只有一行
        //        return FKYWH(40);
    }
    else {
        // 无优惠券
        return 0;
    }
}


@end
