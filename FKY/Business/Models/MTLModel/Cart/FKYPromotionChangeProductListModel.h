//
//  FKYPromotionChangeProductListModel.h
//  FKY
//
//  Created by airWen on 2017/6/8.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"
@class FKYPromotionChangePriceGradModel;

@interface FKYPromotionChangeProductListModel : FKYBaseModel 
@property(nonatomic, strong)NSNumber *isLevel;
@property(nonatomic, strong)NSNumber *promotionPre;
@property(nonatomic, copy)NSString *promotionName;
@property(nonatomic, strong)NSArray<FKYPromotionChangePriceGradModel*> *changeRuleList;
@end
