//
//  FKYVipPromotionModel.h
//  FKY
//
//  Created by hui on 2019/3/28.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"

@interface FKYVipPromotionModel : FKYBaseModel

@property (nonatomic, copy) NSString *visibleVipPrice;      // vip价格
@property (nonatomic, copy) NSString *vipLimitNum;          // vip限购
@property (nonatomic, copy) NSString *vipPromotionId;       // vip活动id
@property (nonatomic, copy) NSString *availableVipPrice;    // vip可用价格
@property (nonatomic, copy) NSString *showPrice;            // 暂无用到
@property (nonatomic, copy) NSString *vipLimitText;            //vip限购文描
@end



