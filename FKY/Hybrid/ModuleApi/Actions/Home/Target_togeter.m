//
//  Target_togeter.m
//  FKY
//
//  Created by hui on 2018/12/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "Target_togeter.h"

@implementation Target_togeter
//一起购列表
- (id)Action_jsUniversalRouterToTogeterViewController:(NSDictionary *)params
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TogeterBuy) setProperty:^(id destinationViewController) {
        
    }];
    return nil;
}
@end
