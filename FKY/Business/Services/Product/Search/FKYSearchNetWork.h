//
//  FKYSearchNetWork.h
//  FKY
//
//  Created by 寒山 on 2018/7/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJOperationParam.h"

@interface FKYSearchNetWork : NSObject

/**
 *  店铺内搜索联想
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getSearchThinkInShopWithParam:(NSDictionary *)param  completionBlock:(HJCompletionBlock)aCompletionBlock;

@end
