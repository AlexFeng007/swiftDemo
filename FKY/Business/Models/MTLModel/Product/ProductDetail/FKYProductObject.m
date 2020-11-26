//
//  FKYProductObjec.m
//  FKY
//
//  Created by mahui on 16/8/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYProductObject.h"
#import "FKYExtModel.h"
#import "FKYProductPromotionModel.h"


@implementation FKYProductObject

#pragma mark - <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"vipModel" : @"vipInfo",@"isZiYingFlag":@"ziyingFlag",@"ext":@"specification",@"productPromotion":@"specialPromotion",@"rebateProtocol":@"RebateProtocol"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    // 解析协议返利金数据
    if ([key isEqualToString:NSStringFromSelector(@selector(rebateProtocol))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProtocolRebateModel class]];
    }
    
    //新模型
    if ([key isEqualToString:NSStringFromSelector(@selector(dinnerInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductDinnerInfoObject class]];
    }
    
    if ([key isEqualToString:NSStringFromSelector(@selector(discountInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYDiscountPriceInfoModel class]];
    }
    
    if ([key isEqualToString:NSStringFromSelector(@selector(priceInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductpriceInfoObject class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(productLimitInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductLimitInfoObject class]];
    }
    //    if ([key isEqualToString:NSStringFromSelector(@selector(promotionList))]) {
    //        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CartPromotionModel class]];
    //    }
    if ([key isEqualToString:NSStringFromSelector(@selector(rebateInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductRebateInfoObject class]];
    }
    
    if ([key isEqualToString:NSStringFromSelector(@selector(vipModel))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYVipDetailModel class]];
    }
    
    if ([key isEqualToString:NSStringFromSelector(@selector(vipPromotionInfo))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYVipPromotionModel class]];
    }
    
    if ([key isEqualToString:NSStringFromSelector(@selector(ext))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYExtModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(productPromotion))]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYProductPromotionModel class]];
    }
    if ([key isEqualToString:NSStringFromSelector(@selector(entranceInfos))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductEntranceInfoObject class]];
    }
    
    return nil;
}
#pragma mark - Public

// 活动类型: 1:特价活动; 2:单品满减; 3:多品满减; 5:单品满赠；6:多品满赠送; 7:单品满送积分; 8:多品满送积分; 9:单品换购; 10:多品换购; 11:自定义单品活动; 12:自定义多品活动; 13:套餐活动; 14:会员活动; 15:单品满折; 16:多品满折

// 同时含有单品满赠和多品满赠时，只显示单品满赠
// 同时含有单品满送积分和多品满送积分时，只显示单品满送积分
// 满减活动全部显示

// 满减个数
- (NSInteger)promotionCount {
    return _promotionListForProductShow.count;
}

// 满减model
- (ProductPromotionInfo *)promotionModelForIndex:(NSIndexPath *)indexPath {
    if (_promotionListForProductShow.count <= indexPath.row) {
        return nil;
    }
    return _promotionListForProductShow[indexPath.row];
}

// 满减model数组
- (NSArray<ProductPromotionInfo *> *)detailViewAppearPromotions:(NSArray<ProductPromotionInfo *> *)promptions {
    NSMutableArray<ProductPromotionInfo *> *showArray = [NSMutableArray array];
    
    //满减
    NSArray *aryDanPinMJ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"2"]];
    if (aryDanPinMJ.count > 0) {
        [showArray addObject:aryDanPinMJ.firstObject];
    }
    else {
        NSArray *aryDuoPinMJ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"3"]];
        if (aryDuoPinMJ.count > 0) {
            [showArray addObject:aryDuoPinMJ.firstObject];
        }
    }
    
    //换购
    NSArray *aryDanPinHuanGou = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"9"]];
    if (aryDanPinHuanGou.count > 0) {
        [showArray addObject:aryDanPinHuanGou.firstObject];
    }
    
    return [NSArray arrayWithArray:showArray];
}

// 满折个数
- (NSInteger)fullDiscountCount {
    return _fullDiscountListForProductShow.count;
}

// 满折model
- (ProductPromotionInfo *)fullDiscountModelForIndex:(NSIndexPath *)indexPath {
    if (_fullDiscountListForProductShow.count <= indexPath.row) {
        return nil;
    }
    return _fullDiscountListForProductShow[indexPath.row];
}

// 满折model数组
- (NSArray<ProductPromotionInfo *> *)detailViewAppearFullDiscountPromotions:(NSArray *)promptions {
    // 最终数组
    NSMutableArray<ProductPromotionInfo *> *showArray = [NSMutableArray array];
    // 单品满折
    NSArray *aryDanPinMZ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"15"]];
    if (aryDanPinMZ.count > 0) {
        [showArray addObject:aryDanPinMZ.firstObject];
    }
    // 多品满折
    NSArray *aryDuoPinMZ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"16"]];
    if (aryDuoPinMZ.count > 0) {
        [showArray addObject:aryDuoPinMZ.firstObject];
    }
    return [NSArray arrayWithArray:showArray];
}

// 满赠个数
- (NSInteger)fullGiftCount {
    return _fullGiftListForProductShow.count;
}

// 满赠model
- (ProductPromotionInfo *)fullGiftModelForIndex:(NSIndexPath *)indexPath {
    if (_fullGiftListForProductShow.count <= indexPath.row) {
        return nil;
    }
    return _fullGiftListForProductShow[indexPath.row];
}

// 满赠model数组
- (NSArray<ProductPromotionInfo *> *)detailViewAppearFullGiftPromotions:(NSArray<ProductPromotionInfo *> *)promptions {
    NSMutableArray<ProductPromotionInfo *> *showArray = [NSMutableArray array];
    
    //满赠
    NSArray *aryDanPinMZ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"5"]];
    if (aryDanPinMZ.count > 0) {
        [showArray addObject:aryDanPinMZ.firstObject];
    }else {
        NSArray *aryDuoPinMZ = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"6"]];
        if (aryDuoPinMZ.count > 0) {
            [showArray addObject:aryDuoPinMZ.firstObject];
        }
    }
    
    //满赠积分
    NSArray *aryDanPinJF = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"7"]];
    if (aryDanPinJF.count > 0) {
        [showArray addObject:aryDanPinJF.firstObject];
    }else {
        NSArray *aryDuoPinJF = [self filterPromotions:promptions isHasSomeKindPromotion:@[@"8"]];
        if (aryDuoPinJF.count > 0) {
            [showArray addObject:aryDuoPinJF.firstObject];
        }
    }
    
    return [NSArray arrayWithArray:showArray];
}

// 满赠活动
//- (NSArray *)giftActivity:(NSArray *)promotions {
//    return [self filterPromotions:promotions isHasSomeKindPromotion:@[@"5", @"6"]];
//}

// 满赠积分活动
//- (NSArray *)scoreActivity:(NSArray *)promotions {
//    return [self filterPromotions:promotions isHasSomeKindPromotion:@[@"7", @"8"]];
//}
//是否有底价活动
- (BOOL)hasBasePriceActivity{
    NSArray *desArr = [self filterPromotions:_promotionList isHasSomeKindPromotion:@[@"17"]];
    if (desArr.count > 0) {
        return true;
    }
    return false;
}

// 大包装
- (NSString *)bigPackageText
{
    //return [NSString stringWithFormat:@"%@%@", self.bigPacking, self.unit];
    
    NSString *txt = nil;
    if (self.bigPacking) {
        if ([self.bigPacking isKindOfClass:[NSString class]]) {
            txt = self.bigPacking;
        }
        else if ([self.bigPacking isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)self.bigPacking;
            txt = number.stringValue;
        }
    }
    if (self.unit && self.unit.length > 0) {
        if (txt) {
            txt = [NSString stringWithFormat:@"%@%@", txt, self.unit];
        }
        else {
            txt = self.unit;
        }
    }
    return txt;
}

////获取库存埋点数据
-(NSString *)getStorageData{
    NSMutableArray *storageArray = [NSMutableArray array];
    //特价 非会员价限购数目
    if (self.productPromotion != nil && self.productPromotion.limitNum != nil && self.productPromotion.limitNum.intValue > 0){
        [storageArray addObject:[NSString stringWithFormat:@"%d",self.productPromotion.limitNum.intValue]];
    }else if (self.vipPromotionInfo != nil && self.vipPromotionInfo.vipLimitNum != nil && self.vipPromotionInfo.vipLimitNum.intValue > 0 && self.vipPromotionInfo.availableVipPrice != nil && self.vipPromotionInfo.availableVipPrice.floatValue > 0){
        [storageArray addObject:[NSString stringWithFormat:@"%d",self.vipPromotionInfo.vipLimitNum.intValue]];
    }
    //库存
    NSInteger canBuyNum = 0;
    if (self.productLimitInfo != nil) {
        if (self.productLimitInfo.surplusBuyNum > 0){
            canBuyNum = self.productLimitInfo.surplusBuyNum;
        }
        if(self.stockCount.intValue < self.productLimitInfo.surplusBuyNum || canBuyNum == 0 ){
            canBuyNum = self.stockCount.intValue;
        }
    }else{
        canBuyNum = self.stockCount.intValue;
    }
    
    [storageArray addObject:[NSString stringWithFormat:@"%d",canBuyNum]];
    if (storageArray.count == 0){
        return @"0";
    }else{
        return [storageArray componentsJoinedByString:@"|"];
    }
}
//获取入口信息
-(FKYProductEntranceInfoObject *)getEntranceInfoObject:(NSNumber *)entranceType{
    NSArray<FKYProductEntranceInfoObject *> *filterArray = [self.entranceInfos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entranceType == %@",entranceType]];
    if (filterArray.count != 0) {
        return  filterArray[0];
    }
    return  nil;
}
//获取促销埋点数据
-(NSString *)getPm_pmtn_type{
    NSMutableArray *promationArray = [NSMutableArray array];
    
    if ([self promotionCount] > 0) {
        [promationArray addObject: @"满减"];
    }
    if ([self fullGiftCount] > 0) {
        [promationArray addObject: @"满赠"];
    }
    // 15:单品满折,16多品满折
    if ([self fullDiscountCount] > 0) {
        [promationArray addObject: @"满折"];
    }
    // 返利金
    if (self.rebateInfo.isRebate.integerValue == 1 && self.rebateInfo.rebateDesc && self.rebateInfo.rebateDesc.length > 0)  {
        [promationArray addObject: @"返利"];
    }
    // 协议返利金
    if (self.rebateProtocol && self.rebateProtocol.protocolRebate)  {
        [promationArray addObject: @"协议奖励金"];
    }
    // 套餐
    if (self.dinnerInfo.dinnerList &&  self.dinnerInfo.dinnerList.count > 0)  {
        [promationArray addObject: @"套餐"];
    }
    
    if ((self.productLimitInfo.limitInfo && self.productLimitInfo.limitInfo.length > 0)||(self.productPromotion && self.productPromotion.limitNum && [self.productPromotion.limitNum intValue] > 0)||(self.vipPromotionInfo != nil && self.vipPromotionInfo.vipLimitText != nil && self.vipPromotionInfo.vipLimitText.length > 0)) {
        [promationArray addObject: @"限购"];
    }
    //特价
    if (self.productPromotion && self.productPromotion.promotionPrice.floatValue > 0) {
        [promationArray addObject: @"特价"];
    }
    //会员  会员才加入 有会员价的商品
    if ((self.vipPromotionInfo.availableVipPrice != nil && self.vipPromotionInfo.availableVipPrice.floatValue > 0)) {
        [promationArray addObject: @"会员"];
    }
    // 优惠券
    if (self.couponList && self.couponList.count > 0) {
        [promationArray addObject: @"券"];
    }
    return (promationArray.count == 0) ? @"":[promationArray componentsJoinedByString:@","];
}
//获取价格埋点数据
-(NSString *)getPm_price{
    NSMutableArray *priceArray = [NSMutableArray array];
    if (self.vipPromotionInfo.availableVipPrice != nil && self.vipPromotionInfo.availableVipPrice.floatValue > 0){
        [priceArray addObject:[NSString stringWithFormat:@"%.2f",self.vipPromotionInfo.availableVipPrice.floatValue]];
    }else if (self.productPromotion.promotionPrice != nil && self.productPromotion.promotionPrice.floatValue > 0){
        [priceArray addObject:[NSString stringWithFormat:@"%.2f",self.productPromotion.promotionPrice.floatValue]];
    }
    if(self.priceInfo.price.floatValue > 0){
        [priceArray addObject:[NSString stringWithFormat:@"%.2f",self.priceInfo.price.floatValue]];
    }
    if (priceArray.count == 0){
        return self.priceInfo.priceText;
    }else{
        return [priceArray componentsJoinedByString:@"|"];
    }
}
#pragma mark - Setter

- (void)setPromotionList:(NSArray *)promotionList
{
    _promotionList = [ProductPromotionInfo getPromotionArr:promotionList];
    self.promotionListForProductShow = [self detailViewAppearPromotions:_promotionList];
    self.fullDiscountListForProductShow = [self detailViewAppearFullDiscountPromotions:_promotionList];
    self.fullGiftListForProductShow = [self detailViewAppearFullGiftPromotions:_promotionList];
}
//MARK:是否能点击加车
//- (BOOL)getCanAddCarBtn{
//    NSString *status = self.priceInfo.status;
//    NSMutableArray *noCanArr = [NSMutableArray arrayWithObjects:@"-9",@"-10",@"-11",@"-12",@"-13",@"-2",@"-3",@"-4",@"-5",@"-6",@"-7",@"2",@"1",@"4", nil];
//    if (self.priceInfo.productStatus == false||[noCanArr containsObject:status]) {
//        //不可加车
//        return false;
//    }
//    return true;
//}
//MARK:未登录
//- (BOOL)getNoLoginStatus{
//    NSString *status = self.priceInfo.status;
//    if ([status isEqualToString:@"-1"]){
//        return  true;
//    }else {
//        return false;
//    }
//}
//MARK:判断单品是否可购买(false:单品不可购买)
- (BOOL)getSigleCanBuy{
    if ([self.priceInfo.status isEqual: @"-14"]) {
        return false;
    }
    return true;
}
//MARK:处理活动相关
- (NSArray<ProductPromotionInfo *> *)filterPromotions:(NSArray<ProductPromotionInfo *> *)promotionList isHasSomeKindPromotion:(NSArray<NSString *> *)promotionKinds {
    if ((nil == promotionList) || (0 >= promotionList.count)) {
        return nil;
    }
    
    if ((nil == promotionKinds) || (0 >= promotionKinds.count)) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"promotionType IN %@",promotionKinds];
    NSArray *aryResult = [promotionList filteredArrayUsingPredicate:predicate];
    return aryResult;
}


@end


//套餐
@implementation FKYProductDinnerInfoObject

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    // 解析套餐数据...<数组>
    if ([key isEqualToString:NSStringFromSelector(@selector(dinnerList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductGroupModel class]];
    }
    return nil;
}

@end

@implementation FKYProductpriceInfoObject
@end
@implementation FKYProductLimitInfoObject
@end
@implementation FKYProductRebateInfoObject
@end
@implementation FKYProductEntranceInfoObject
@end
