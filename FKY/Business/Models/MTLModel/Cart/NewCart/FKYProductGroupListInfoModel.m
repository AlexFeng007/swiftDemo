//
//  FKYProductGroupListInfoModel.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYProductGroupListInfoModel.h"
#import "CartSectionViewModel.h"
#import "CartPromotionModel.h"
#import "FKYPromationInfoModel.h"
#import "NSDictionary+SafeAccess.h"

@implementation FKYProductGroupListInfoModel

// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(groupItemList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYCartGroupInfoModel class]];
    }
    
    return nil;
}

- (NSArray *)getSectionDeatilInfo
{
    NSMutableArray<NSObject<FKYBaseCellProtocol> *> *aryShowData = [[NSMutableArray alloc] init];
    if (self.groupType == 0) {
       // FKYCartGroupInfoModel * lastItem = nil ;
        for(FKYCartGroupInfoModel *item in self.groupItemList){
           // item.supplyId = self.supplyId;
            //普通商品
            // 返利金
            SeparateLineCellModel *LineCell = [[SeparateLineCellModel alloc] init];
            LineCell.cellType = CartTabelCellTypeSeparateTopLine;
            [aryShowData addObject:LineCell];

            CartProductCellModel *product = [[CartProductCellModel alloc] init];
            product.productModel = item;
            product.comboType = ComboTypeNone;
            [aryShowData addObject:product];
            //协议返利金
            if(item.agreementRebate != nil){
                if (aryShowData.count >0) {
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.agreementRebate withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.agreementRebate stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_ProtocolReabte];
                
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = promotionInfo.promationDescription;
                [aryShowData addObject:promotion];
            }
             // 促销活动
            if (item.promotionJF) {
                if (aryShowData.count >0) {
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionJF withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionJF stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinScore];
                
                
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionJF stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            
            if (item.promotionMJ) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionMJ withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionMJ stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinMJ];
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionMJ stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            
            if (item.promotionMZ) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionMZ withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionMZ stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinMZ];
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionMZ stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            
            if (item.promotionManzhe) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionManzhe withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionManzhe stringForKey:@"description"];
                //15是单品，16是多品
                if ([item.promotionManzhe integerForKey:@"type"] == 15){
                     promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinManZhe];
                }else if([item.promotionManzhe integerForKey:@"type"] == 16){
                     promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DuoPinManZhe];
                }else{
                     promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinManZhe];
                }
               
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = promotionInfo.promationDescription;
                [aryShowData addObject:promotion];
            }
            
//            if (item.promotionTJ) {
//                if (aryShowData.count >0){
//                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
//                    if(cellData.cellType == CartTabelCellTypeProduction){
//                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
//                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
//                        [aryShowData addObject:bottomLineCell];
//                    }
//                }
//
//                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionTJ withClass:[FKYPromationInfoModel class]];
//                promotionInfo.promationDescription = [item.promotionTJ stringForKey:@"description"];
//                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_TeJia];
//                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
//                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
//                promotion.promotionInfo = promotionInfo;
//                promotion.promotionDes = [item.promotionTJ stringForKey:@"description"];
//                [aryShowData addObject:promotion];
//            }
            if (item.productRebate && [[item.productRebate stringForKey:@"rebateTextMsg"] length]>0) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                RebateCellModel *rebateModel = [[RebateCellModel alloc] init];
                rebateModel.rebateDesc = [item.productRebate stringForKey:@"rebateTextMsg"];
                [aryShowData addObject:rebateModel];
            }
        }
    }
    else if (self.groupType == 1) {
        //搭配套餐
        // 0.套餐名称cell-model
        SeparateLineCellModel *LineCell = [[SeparateLineCellModel alloc] init];
        LineCell.cellType = CartTabelCellTypeSeparateTopLine;
        [aryShowData addObject:LineCell];
        
        CartTaoCanNameCellModel *taoCan = [[CartTaoCanNameCellModel alloc] init];
        taoCan.taoCanGroudItemList = self.groupItemList; // 套餐中的商品列表
        //taoCan.promotionModel = item.taoCanItemList[0].productPromotion; // 用于确定套餐名称?!
         taoCan.taocanModel = self; // 固定套餐model
        taoCan.comboType = ComboTypeCombine;
        [aryShowData addObject:taoCan];
        
        for(int i=0 ;i<self.groupItemList.count;i++ ){
            FKYCartGroupInfoModel * item =  self.groupItemList[i];
           // item.supplyId = self.supplyId;
            // 1.套餐中单个商品cell-model
            CartProductCellModel *product = [[CartProductCellModel alloc] init];
            product.productModel = item;
            product.comboType = ComboTypeCombine;
            [aryShowData addObject:product];
            
            if(i< self.groupItemList.count -1){
                SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                [aryShowData addObject:bottomLineCell];
            }
        }
        
        // 加空行分隔~!@
        // 3.套餐底部的空行model
        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
        [aryShowData addObject:bottomLineCell];
        
    }
    else if (self.groupType == 2) {
        //固定套餐
        SeparateLineCellModel *LineCell = [[SeparateLineCellModel alloc] init];
        LineCell.cellType = CartTabelCellTypeSeparateTopLine;
        [aryShowData addObject:LineCell];
        
        CartTaoCanNameCellModel *taoCan = [[CartTaoCanNameCellModel alloc] init];
        taoCan.taoCanGroudItemList = self.groupItemList; // 套餐中的商品列表
        //taoCan.promotionModel = item.shoppingItemList[0].productPromotion; // 用于确定套餐名称?!
        taoCan.taocanModel = self; // 固定套餐model
        taoCan.comboType = ComboTypeFixed;
        [aryShowData addObject:taoCan];
        
       
        for(int i=0 ;i<self.groupItemList.count;i++ ){
           FKYCartGroupInfoModel * item =  self.groupItemList[i];
          // item.supplyId = self.supplyId;
           CartProductCellModel *product = [[CartProductCellModel alloc] init];
           product.productModel = item;
           product.comboType = ComboTypeFixed;
           [aryShowData addObject:product];
           //if(i< self.groupItemList.count -1){
            SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
            bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
            [aryShowData addObject:bottomLineCell];
           // }
         }
        if (self.valid == YES) {
            // 3.套餐数量cell
            FixedComboNumberCellModel *fixedCell = [[FixedComboNumberCellModel alloc] init];
            fixedCell.cellType = CartTabelCellTypeFixedTaoCanNumber;
            fixedCell.taocanModel = self;
            [aryShowData addObject:fixedCell];
        }
    }else if (self.groupType == 3) {
        //多品返利组
        //顶部分割线
        SeparateLineCellModel *LineCell = [[SeparateLineCellModel alloc] init];
        LineCell.cellType = CartTabelCellTypeSeparateTopLine;
        [aryShowData addObject:LineCell];
        //多品返利描述
        if (self.multiRebateTip && [self.multiRebateTip length]>0) {
            MuliRebateCellModel *rebateModel = [[MuliRebateCellModel alloc] init];
            rebateModel.rebateDesc = self.multiRebateTip;
            rebateModel.groupId = self.groupId;
            rebateModel.shopId = [NSString stringWithFormat:@"%d",self.supplyId];
            [aryShowData addObject:rebateModel];
        }
        //多品返利
        for(int i=0 ;i<self.groupItemList.count;i++ ){
            FKYCartGroupInfoModel * item =  self.groupItemList[i];
            //item.supplyId = self.supplyId;
            //商品
            CartProductCellModel *product = [[CartProductCellModel alloc] init];
            item.isMixRebate = YES;
            product.productModel = item;
            product.comboType = ComboTypeNone;
            [aryShowData addObject:product];
            
             // 促销活动
            
            if (item.promotionJF) {
                if (aryShowData.count >0) {
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionJF withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionJF stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinScore];
                promotionInfo.isMixRebate = YES;
                
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionJF stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            
            if (item.promotionMJ) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionMJ withClass:[FKYPromationInfoModel class]];
                promotionInfo.isMixRebate = YES;
                promotionInfo.promationDescription = [item.promotionMJ stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinMJ];
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionMJ stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            
            if (item.promotionMZ) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionMZ withClass:[FKYPromationInfoModel class]];
                promotionInfo.isMixRebate = YES;
                promotionInfo.promationDescription = [item.promotionMZ stringForKey:@"description"];
                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinMZ];
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = [item.promotionMZ stringForKey:@"description"];
                [aryShowData addObject:promotion];
            }
            //满折
            if (item.promotionManzhe) {
                if (aryShowData.count >0){
                    NSObject<FKYBaseCellProtocol> *cellData = aryShowData.lastObject;
                    if(cellData.cellType == CartTabelCellTypeProduction){
                        SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                        bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                        [aryShowData addObject:bottomLineCell];
                    }
                }
                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionManzhe withClass:[FKYPromationInfoModel class]];
                promotionInfo.promationDescription = [item.promotionManzhe stringForKey:@"description"];
                //15是单品，16是多品
                if ([item.promotionManzhe integerForKey:@"type"] == 15){
                    promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinManZhe];
                }else if([item.promotionManzhe integerForKey:@"type"] == 16){
                    promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DuoPinManZhe];
                }else{
                    promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_DanPinManZhe];
                }
                
                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
                promotion.promotionInfo = promotionInfo;
                promotion.promotionDes = promotionInfo.promationDescription;
                [aryShowData addObject:promotion];
            }
            
//            if (item.promotionTJ) {
//                FKYPromationInfoModel *promotionInfo = [FKYTranslatorHelper translateModelFromJSON:item.promotionTJ withClass:[FKYPromationInfoModel class]];
//                promotionInfo.isMixRebate = YES;
//                promotionInfo.promationDescription = [item.promotionTJ stringForKey:@"description"];
//                promotionInfo.promotionType = [NSNumber numberWithInt:CartPromotionType_TeJia];
//                PromotionCellModel *promotion = [[PromotionCellModel alloc] init];
//                promotion.shopId = [NSString stringWithFormat:@"%d",item.supplyId];
//                promotion.promotionInfo = promotionInfo;
//                promotion.promotionDes = [item.promotionTJ stringForKey:@"description"];
//                [aryShowData addObject:promotion];
//            }
            //商品分割线
            if(i< self.groupItemList.count -1){
                SeparateLineCellModel *bottomLineCell = [[SeparateLineCellModel alloc] init];
                bottomLineCell.cellType = CartTabelCellTypeSeparateBottomLine;
                [aryShowData addObject:bottomLineCell];
            }
        }
    }

    return aryShowData;
}

// 判断当前商家中的所有商品是否为编辑全选中状态
- (BOOL)isSelectedAllForEditStatus
{
    // 普通商品
    NSArray<FKYCartGroupInfoModel *> *unSelectedArray = [self.groupItemList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"editStatus == 1"]];
    if (unSelectedArray.count > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isCanHuanGou:(FKYCartGroupInfoModel *)infoModel
{
    if ([infoModel.checkStatus boolValue]) {
//        if ((nil == _fullPromotionChangeText) || (0 >= _fullPromotionChangeText.length)) {
//            return NO;
//        }else{
//            return YES;
//        }
         return YES;
    }else{
        return NO;
    }
}

- (NSString *)canHuanGouDes:(FKYPromotionHGInfo  *)infoModel
{
    if (infoModel.hgOptionItem.count > 0) {
        return @"更换换购 >";
    }else {
        return @"去换购 >";
    }
}

@end
