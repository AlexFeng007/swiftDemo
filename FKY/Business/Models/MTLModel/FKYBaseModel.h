//
//  FKYBaseModel.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "FKYBaseModelPictureUrlAppendHostProtocol.h"

@interface FKYBaseModel : MTLModel <MTLJSONSerializing, FKYBaseModelPictureUrlAppendHostProtocol>

+ (NSDateFormatter *)defaultDateFormatter;        //  RESTful 日期格式

@end
