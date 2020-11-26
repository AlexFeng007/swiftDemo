//
//  CartSectionViewModel.m
//  FKY
//
//  Created by airWen on 2017/6/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "CartSectionViewModel.h"

@implementation SeparateLineCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end


@implementation SeparateSpaceCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end


@implementation CartTaoCanNameCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeTaoCanName;
    }
    return self;
}
@end


@implementation FixedComboNumberCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeFixedTaoCanNumber;
    }
    return self;
}
@end

@implementation SectionTipsCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeSectionTips;
    }
    return self;
}
@end

@implementation PromotionCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypePromotion;
    }
    return self;
}

- (CGFloat)getCellHeight
{
    switch (self.promotionInfo.promotionType.integerValue) {
        case 2:
        case 3:
        case 5:
        case 6:
        case 15:
        case 16:
        case 101:
        case 9:
            return FKYWH(40);
            break;
        case 7:
        case 8:
            return FKYWH(35);
            break;
        default:
            return FKYWH(0);
            break;
    }
}
@end


@implementation RebateCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeRebate;
    }
    return self;
}
@end

//多品返利
@implementation  MuliRebateCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeMuliRebate;
    }
    return self;
}
@end

@implementation IncreasePriceGiftsPromotionCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeIncreasePriceGiftsPromotion;
    }
    return self;
}
@end


@implementation CartProductCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeProduction;
    }
    return self;
}
@end


@implementation FKYIncreasePriceGiftsProductCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = CartTabelCellTypeIncreasePriceGiftsProduct;
    }
    return self;
}
@end
