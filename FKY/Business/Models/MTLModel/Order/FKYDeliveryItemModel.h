//
//  FKYDeliveryItemModel.h
//  FKY
//
//  Created by zengyao on 2017/6/9.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYDeliveryItemModel : FKYBaseModel

@property (nonatomic, strong) NSString *remark; // 状态
@property (nonatomic, strong) NSString *logSource;
@property (nonatomic) NSTimeInterval doOpTime; // 时间

@end
