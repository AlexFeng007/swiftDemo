//
//  FKYCarVipModel.h
//  FKY
//
//  Created by hui on 2019/3/28.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"

@interface FKYCartVipModel : FKYBaseModel
@property (nonatomic, strong) NSNumber *visibleVipPrice;//vip价格
@property (nonatomic, assign) NSInteger vipLimitNum;//vip限购
@property (nonatomic, assign) NSInteger vipPromotionId;//vip活动id
@property (nonatomic, strong) NSNumber *availableVipPrice;//vip可用价格
@property (nonatomic, assign) BOOL reachVipLimitNum;//是否达到了会员限购数量
@property (nonatomic, assign) NSInteger surplusMaxNum;//暂无用到
@end


