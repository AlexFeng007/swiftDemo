//
//  FKYCartProductModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"
#import "FKYBaseModel+FKYModelTranslator.h"

@class FKYHomeProductionModel;
@class FKYProductionModel;
@class FKYCartProductPromoteModel;


NS_ASSUME_NONNULL_BEGIN

@interface FKYCartProductModel : FKYBaseModel

@property (nonatomic) NSInteger addSaleSize;
@property (nonatomic) NSInteger minSaleSize;
@property (nonatomic) NSInteger maxSaleSize;
@property (nonatomic) NSInteger totalSaleSize;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) NSInteger shopCartId;
@property (nonatomic) float monomerDrugstorePrice;
@property (nonatomic) float policyPrice;
@property (nullable, nonatomic, copy) NSString *policyType;
@property (nonatomic) NSInteger productId;
@property (nonatomic) NSInteger supplyId;
@property (nonatomic) NSInteger productStatus;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSString *productProvider;
@property (nullable, nonatomic, copy) NSString *productSize;
@property (nullable, nonatomic, copy) NSString *productVender;
@property (nonatomic) BOOL isSelected;
@property (nullable, nonatomic, copy) NSString *leaveMessage;
@property (nullable, nonatomic, copy) NSString *productUnit;
@property (nonatomic) NSInteger productWmCount;
@property (nonatomic, strong) NSArray *activityDtoList;   // 活动类型

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

@property (nonatomic, strong) FKYCartProductPromoteModel *activityModel;

- (void)copyPropertiesFromHomeModel:(FKYProductionModel *)model;
- (FKYHomeProductionModel *)transToHomeProductionModel;

@end

NS_ASSUME_NONNULL_END
