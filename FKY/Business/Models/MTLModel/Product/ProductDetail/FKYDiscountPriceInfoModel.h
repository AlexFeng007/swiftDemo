//
//  FKYDiscountPriceInfoModel.h
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之折后价信息model

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"


@interface FKYDiscountPriceItemModel : FKYBaseModel

@property (nonatomic, copy) NSString *discountAmount;   // eg: -￥0.30
@property (nonatomic, copy) NSString *desc;             // eg: 返利优惠10%

@end


@interface FKYDiscountPriceInfoModel : FKYBaseModel

@property (nonatomic, copy) NSString *discountPrice;    // 折后价 eg: ￥8.30
@property (nonatomic, copy) NSString *word;             // 折后价说明
@property (nonatomic, copy) NSString *bestBuyNumDesc; // 折后价最优
@property (nonatomic, strong) NSArray<FKYDiscountPriceItemModel *> *discountDetail; // 优惠折扣项

@end
