//
//  FKYDeliveryHeadModel.h
//  FKY
//
//  Created by zengyao on 2017/6/9.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYDeliveryHeadModel : FKYBaseModel

@property (nonatomic, strong) NSString *status; // 配送状态
@property (nonatomic, strong) NSString *carrierName; // 物流公司
@property (nonatomic, strong) NSString *expressNum; // 物流单号

@end
