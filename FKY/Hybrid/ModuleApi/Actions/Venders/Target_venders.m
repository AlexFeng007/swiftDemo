//
//  Target_venders.m
//  FKY
//
//  Created by Rabe on 30/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "Target_venders.h"
#import "NSString+WUMMD5.h"

@implementation Target_venders

- (id)Action_nativeFetchDeviceIdentifierInAboutUsPage:(NSDictionary *)params
{
    NSString *uuid = [[FKYAnalyticsUtility getDeviceUUID] MD5ForUpper16Bate];
    return uuid;
}

@end
