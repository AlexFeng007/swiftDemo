//
//  FKYSearchRequest.h
//  FKY
//
//  Created by 寒山 on 2018/7/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "HJLogic.h"
#import "FKYSearchNetWork.h"

@interface FKYSearchRequest : HJLogic

/**
 *  店铺内搜索联想
 *
 *  @param aCompletionBlock
 */
- (void)getSearchThinkInShopWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

@end
