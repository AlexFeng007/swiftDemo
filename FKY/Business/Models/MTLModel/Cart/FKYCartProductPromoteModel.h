//
//  FKYCartProductPromoteModel.h
//  FKY
//
//  Created by yangyouyong on 15/11/18.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYCartProductPromoteModel : FKYBaseModel

@property (nonatomic, assign) NSInteger productId;

@property (nonatomic) NSInteger activityId;
@property (nonatomic) NSInteger activitySpuId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityType;
@property (nonatomic, strong) NSString *giftInfo;
@property (nonatomic, strong) NSString *giftDescribe;
@property (nonatomic, strong) NSString *activityPrice;
@property (nonatomic, assign) BOOL isSelectedPromote;
@property (nonatomic, strong) NSString *activityInfo;
@property (nonatomic) NSInteger leastUserBuy;
@property (nonatomic) NSInteger mostUserBuy;

@end
