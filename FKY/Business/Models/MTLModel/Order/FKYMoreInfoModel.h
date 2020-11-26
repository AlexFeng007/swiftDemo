//
//  FKYMoreInfoModel.h
//  FKY
//
//  Created by mahui on 2016/10/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYMoreInfoModel : FKYBaseModel

@property (nonatomic, strong) NSString *cancelResult;
@property (nonatomic, strong) NSString *cancelTime;
@property (nonatomic, strong) NSString *otherCancelReason;
@property (nonatomic, strong) NSString *cancelReasonType;
@property (nonatomic, strong) NSString *cancelReasonValue;
 
@end
