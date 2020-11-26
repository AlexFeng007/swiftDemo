//
//  YWSpeedUpLogic.h
//  YYW
//
//  Created by 张斌 on 2017/10/17.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJLogic.h"

#pragma mark -

@interface YWSpeedUpEntity : NSObject

@property (nonatomic, strong) NSNumber *pageid;
@property (nonatomic, strong) NSNumber *pagestarttime;
@property (nonatomic, strong) NSString *pageurl;
@property (nonatomic, strong) NSMutableArray *requestdetail;
@property (nonatomic, strong) NSNumber *usedtime;

@end


@interface YWSpeedUpLogic : HJLogic

- (void)upload:(YWSpeedUpEntity *)entity handle:(HJCompletionBlock)aCompletionBlock;

@end
