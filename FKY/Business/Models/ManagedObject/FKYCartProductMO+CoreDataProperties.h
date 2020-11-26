//
//  FKYCartProductMO+CoreDataProperties.h
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FKYCartProductMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface FKYCartProductMO (CoreDataProperties)

@property (nonatomic) int64_t addSaleSize;
@property (nonatomic) int64_t minSaleSize;
@property (nonatomic) int64_t maxSaleSize;
@property (nonatomic) int64_t totalSaleSize;
@property (nonatomic) int64_t quantity;
@property (nonatomic) int64_t shopCartId;
@property (nonatomic) int64_t supplyId;
@property (nonatomic) int64_t productStatus;
@property (nonatomic) int64_t productPriceId;
@property (nonatomic) int64_t productWmCount;
@property (nonatomic) float monomerDrugstorePrice;
@property (nonatomic) float policyPrice;
@property (nullable, nonatomic, retain) NSString *policyType;
@property (nonatomic) int64_t productId;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSString *productProvider;
@property (nullable, nonatomic, retain) NSString *productSize;
@property (nullable, nonatomic, retain) NSString *productVender;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *leaveMessage;
@property (nullable, nonatomic, retain) NSString *productUnit;
@property (nonatomic) BOOL isSelected;

@property (nonatomic) int64_t activitySpuId;
@property (nullable, nonatomic, retain) NSString *spuPicUrl;
@property (nullable, nonatomic, retain) NSString *activityName;
@property (nullable, nonatomic, retain) NSString *activityType;
@property (nullable, nonatomic, retain) NSString *giftInfo;
@property (nullable, nonatomic, retain) NSString *giftDescribe;
@property (nonatomic) int64_t activityId;

@end

NS_ASSUME_NONNULL_END
