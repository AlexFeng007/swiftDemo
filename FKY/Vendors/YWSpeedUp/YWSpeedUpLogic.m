//
//  YWSpeedUpLogic.m
//  YYW
//
//  Created by 张斌 on 2017/10/17.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "YWSpeedUpLogic.h"


@implementation YWSpeedUpEntity

@end

@implementation YWSpeedUpLogic

- (void)upload:(YWSpeedUpEntity *)entity handle:(HJCompletionBlock)aCompletionBlock
{
    NSDictionary *dic =  [entity yy_modelToJSONObject];
    HJOperationParam *param = [HJOperationParam paramWithBusinessName:@"mobile" methodName:@"statpage" versionNum:nil type:kRequestPost param:dic callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    
    [self.operationManger requestWithParam:param];
}

@end
