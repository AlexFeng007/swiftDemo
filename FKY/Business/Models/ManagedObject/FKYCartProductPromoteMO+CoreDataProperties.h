//
//  FKYCartProductPromoteMO+CoreDataProperties.h
//  FKY
//
//  Created by yangyouyong on 2016/7/8.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FKYCartProductPromoteMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface FKYCartProductPromoteMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *activityId;
@property (nullable, nonatomic, retain) NSString *activityName;
@property (nullable, nonatomic, retain) NSNumber *activityPrice;
@property (nullable, nonatomic, retain) NSNumber *activitySpuId;
@property (nullable, nonatomic, retain) NSString *activityType;
@property (nullable, nonatomic, retain) NSString *giftDescribe;
@property (nullable, nonatomic, retain) NSString *giftInfo;
@property (nullable, nonatomic, retain) NSNumber *isSelectedPromote;
@property (nullable, nonatomic, retain) NSNumber *productId;
@property (nullable, nonatomic, retain) NSNumber *mostUserBuy;
@property (nullable, nonatomic, retain) NSNumber *leastUserBuy;
@property (nullable, nonatomic, retain) NSString *activityInfo;

@end

NS_ASSUME_NONNULL_END
