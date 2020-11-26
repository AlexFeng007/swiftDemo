//
//  HJLogic.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJUploadFileValue.h"
#import "HJOperationParam.h"
#import "HJUploadOperationParam.h"
#import "HJOperationManager.h"


@interface HJLogic : NSObject

@property (nonatomic, strong, readonly) HJOperationManager *operationManger;
@property (nonatomic) BOOL loading;

+ (id)logicWithOperationManager:(HJOperationManager *)aOperationManger;

@end
