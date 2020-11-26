//
//  FKYCartProductManagedModel.h
//  FKY
//
//  Created by yangyouyong on 2016/7/4.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@class FKYHomeProductionModel;
@class FKYProductionModel;
@class FKYCartProductPromoteModel;


NS_ASSUME_NONNULL_BEGIN

@interface FKYCartProductManagedModel : FKYBaseModel

@property (nonatomic) NSInteger addSaleSize;
@property (nonatomic) NSInteger minSaleSize;
@property (nonatomic) NSInteger maxSaleSize;
@property (nonatomic) NSInteger totalSaleSize;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) NSInteger shopCartId;
@property (nonatomic) float monomerDrugstorePrice;
@property (nonatomic) float policyPrice;
@property (nullable, nonatomic, strong) NSString *policyType;
@property (nonatomic) NSInteger productId;
@property (nonatomic) NSInteger supplyId;
@property (nonatomic) NSInteger productStatus;
@property (nullable, nonatomic, strong) NSString *productName;
@property (nullable, nonatomic, strong) NSString *productProvider;
@property (nullable, nonatomic, strong) NSString *productSize;
@property (nullable, nonatomic, strong) NSString *productVender;
@property (nonatomic) BOOL isSelected;
@property (nullable, nonatomic, strong) NSString *leaveMessage;
@property (nullable, nonatomic, strong) NSString *productUnit;
@property (nonatomic) NSInteger productWmCount;

//@property (nonatomic, strong) NSString *promoteDescrip;
//@property (nonatomic, assign) NSInteger promoteType;

//"spuPicUrl": "/include/uploadImages/spu/29486/29486_1.jpg",
// activitySpuId
// "activityName": "满促05",
// "activityType": "满赠"
// "activityId"
// 参加的促销活动信息
@property (nonatomic) NSInteger activityId;
@property (nonatomic) NSInteger activitySpuId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityType;
@property (nonatomic, strong) NSString *spuPicUrl;
@property (nonatomic, strong) NSString *giftInfo;
@property (nonatomic, strong) NSString *giftDescribe;
//@property (nonatomic) NSInteger leastUserBuy;
//@property (nonatomic) NSInteger mostUserBuy;
//@property (nonatomic) NSInteger productNowQuantity;
//@property (nonatomic) NSInteger activityPrice;

//@property (nonatomic, strong) NSArray *activityDtoList;
//@property (nonatomic, strong) FKYCartProductPromoteModel *activityModel;

- (void)copyPropertiesFromHomeModel:(FKYProductionModel *)model;
- (FKYHomeProductionModel *)transToHomeProductionModel;

@end

NS_ASSUME_NONNULL_END
