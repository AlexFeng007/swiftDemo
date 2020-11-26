//
//  FKYBatchModel.h
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYBatchModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *productId; // 商品Id
@property (nonatomic, strong) NSNumber *batchId; // 批次号
@property (nonatomic, strong) NSNumber *buyNumber; // 发货数
@property (nonatomic, copy) NSString *validUntil;//有效期

@end
