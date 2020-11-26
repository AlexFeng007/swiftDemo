//
//  FKYPersonModel.m
//  FKY
//
//  Created by mahui on 15/12/2.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPersonModel.h"

@implementation FKYPersonModel

- (NSString *)receiveAddress{
    if ([_addressDetail isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _addressDetail;
}


- (NSString *)contact{
    if ([_deliveryPhone isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return _deliveryPhone;
}
@end
