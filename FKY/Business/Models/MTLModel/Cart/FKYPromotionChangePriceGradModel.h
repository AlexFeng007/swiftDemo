//
//  FKYPromotionChangeProductModel.h
//  FKY
//
//  Created by airWen on 2017/6/8.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"
#import "FKYIncreasePriceGiftsProductModel.h"

@interface FKYPromotionChangePriceGradModel : FKYBaseModel
@property(nonatomic, copy)NSString *promotionId;
@property(nonatomic, copy)NSString *ruleId;
@property(nonatomic, copy)NSString *ruleDesc;
@property(nonatomic, strong)NSNumber *promotionSum;
@property(nonatomic, strong)NSArray<FKYIncreasePriceGiftsProductModel*> *changeProductList;
@property(nonatomic, strong)NSArray<FKYIncreasePriceGiftsProductModel*> *promitionChangeProductList;
@property(nonatomic, assign)BOOL selectRule;
@property(nonatomic, assign)BOOL change;//当前主品是否符合价格阶梯
@end


