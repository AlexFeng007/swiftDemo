//
//  FKYIncreasePriceGiftsProductModel.h
//  FKY
//
//  Created by airWen on 2017/6/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYIncreasePriceGiftsProductModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *shoppingCartId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger oldQuantity;
@property (nonatomic, copy) NSNumber *selectedProduct; // 由于服务器未传值 为false 代表选中, true 代表未选中
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, assign) float productPrice;
@property (nonatomic, assign) float recommendPrice;
@property (nonatomic, assign) NSInteger stockCount;
@property (nonatomic, assign) NSInteger baseCount;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, assign) NSInteger statusDesc;
@property (nonatomic, copy) NSString *factoryName;
@property (nonatomic, copy) NSString *factoryId;
@property (nonatomic, copy) NSString *vendorName;
@property (nonatomic, copy) NSString *vendorId;
@property (nonatomic, copy) NSString *spuCode;
@property (nonatomic, copy) NSString *shoppingCartChangeId;
@property (nonatomic, assign) BOOL changeProduct;//是否是加价购赠品
@property (nonatomic, assign) BOOL normalStatus;
@property (nonatomic, copy) NSString *unNormalStatusReason;

//view Model
@property (nonatomic, strong) NSNumber *isCanSelected;

@end
