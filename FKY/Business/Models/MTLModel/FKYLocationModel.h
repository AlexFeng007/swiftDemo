//
//  FKYLocationModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYLocationModel : FKYBaseModel<NSCoding>

@property (nonatomic, copy) NSString *substationName;   // 站点(省份)名称
@property (nonatomic, copy) NSString *substationCode;   // 站点(省份)code
@property (nonatomic, strong) NSNumber *showIndex;      // ???
@property (nonatomic, strong) NSNumber *isCommon;       // ??? 0 通用城市  1 试点城市

+ (instancetype)defaultModel;

@end
