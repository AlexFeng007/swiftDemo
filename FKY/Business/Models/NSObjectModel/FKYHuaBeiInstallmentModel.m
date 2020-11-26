//
//  FKYHuaBeiInstallmentModel.m
//  FKY
//
//  Created by 乔羽 on 2018/10/23.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "FKYHuaBeiInstallmentModel.h"

@implementation FKYSubInstallmentModel

@end


@implementation FKYHuaBeiInstallmentModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    // value should be Class or Class name.
    return @{@"hbInstalmentInfoDtoList" : [FKYSubInstallmentModel class]};
}

@end
