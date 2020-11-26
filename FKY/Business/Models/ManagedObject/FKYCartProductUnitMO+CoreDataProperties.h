//
//  FKYCartProductUnitMO+CoreDataProperties.h
//  FKY
//
//  Created by yangyouyong on 2016/6/27.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FKYCartProductUnitMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface FKYCartProductUnitMO (CoreDataProperties)

@property (nullable, nonatomic, strong) NSNumber *productId;
@property (nullable, nonatomic, copy) NSString *productProvider;
@property (nullable, nonatomic, strong) NSNumber *subItemCount; // 统计商品或者活动的数量
@property (nullable, nonatomic, strong) NSNumber *supplyId;
@property (nullable, nonatomic, strong) FKYCartProductMO *cartProductMO;
@property (nullable, nonatomic, strong) FKYCartProductPromoteMO *cartProductPromoteMO;

@end

NS_ASSUME_NONNULL_END
