//
//  FKYSearchNetWork.m
//  FKY
//
//  Created by 寒山 on 2018/7/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSearchNetWork.h"

@implementation FKYSearchNetWork

#pragma mark - 店铺内搜索联想 searchAssociation
+ (HJOperationParam *)getSearchThinkInShopWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBusinessName:@"api/search" methodName:@"suggest" versionNum:nil type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    return operationParam;
}

@end
