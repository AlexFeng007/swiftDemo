//
//  FKYDeliveryModel.h
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYDeliveryModel : FKYBaseModel

@property (nonatomic, strong) NSString *deliveryDate; // 预计送达时间
@property (nonatomic, strong) NSString *deliveryPerson;  // 配送人姓名
@property (nonatomic, strong) NSString *deliveryContactPhone; // 配送人员电话
@property (nonatomic, strong) NSString *deliveryContactPerson; // 物流公司
@property (nonatomic, strong) NSString *deliveryExpressNo; // 物流单号

@end
