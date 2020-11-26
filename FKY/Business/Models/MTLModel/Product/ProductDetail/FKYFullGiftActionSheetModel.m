//
//  FKYFullGiftActionSheetModel.m
//  FKY
//
//  Created by 乔羽 on 2018/6/5.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYFullGiftActionSheetModel.h"

@implementation FKYFullGiftImg

@end


@implementation FKYFullGiftActionSheetModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"giftInfoList" : [FKYFullGiftImg class]};
}

@end
