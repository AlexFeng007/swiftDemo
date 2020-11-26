//
//  FKYShoppingCartModel.h
//  FKY
//
//  Created by zhangxuewen on 2018/3/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"
@protocol FKYShoppingCartModel
@end

@interface FKYShoppingCartModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *shoppingCartId;       //购物车id
@property (nonatomic, strong) NSNumber *supplyId;       //供应商

@end
