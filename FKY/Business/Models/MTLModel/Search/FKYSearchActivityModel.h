//
//  FKYSearchActivityModel.h
//  FKY
//
//  Created by 寒山 on 2019/6/20.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKYBaseModel.h"

@interface FKYSearchActivityModel : FKYBaseModel

@property (nonatomic, copy) NSString *imgPath;         // 商品名称
@property (nonatomic, copy) NSString *jumpInfo;       // 商家名称
@property (nonatomic, copy) NSString *name;   // 商家id

@end

