//
//  FKYSearchRequest.m
//  FKY
//
//  Created by 寒山 on 2018/7/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSearchRequest.h"

@implementation FKYSearchRequest

#pragma mark - 店铺内搜索联想
- (void)getSearchThinkInShopWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *operationParam = [FKYSearchNetWork getSearchThinkInShopWithParam:param completionBlock:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]])  {
            if (aCompletionBlock) {
                aCompletionBlock(aResponseObject,nil);
            }
        }else{
            if (aCompletionBlock) {
                aCompletionBlock(nil, anError);
            }
        }
    }];
    [self.operationManger requestWithParam:operationParam];
}

@end
