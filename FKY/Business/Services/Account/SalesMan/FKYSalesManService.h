//
//  FKYSalesManService.h
//  FKY
//
//  Created by 寒山 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYSalesManModel.h"
@interface FKYSalesManService : FKYBaseService

@property (nonatomic, strong) FKYSalesManModel *salesManModel;

/**
 *  获取业务员列白表
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getSalesManListInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

@end
