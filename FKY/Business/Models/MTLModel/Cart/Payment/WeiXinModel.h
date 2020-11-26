//
//  WeiXinModel.h
//  FKY
//
//  Created by mahui on 2017/3/24.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface WeiXinModel : FKYBaseModel

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *nonceStr;
@property (nonatomic, strong) NSString *packageValue;
@property (nonatomic, strong) NSString *partnerId;
@property (nonatomic, strong) NSString *prepayId;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSNumber *timeStamp;

@end
