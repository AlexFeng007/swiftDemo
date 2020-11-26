//
//  HJOperationManager+Upload.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJOperationManager.h"
@class HJUploadOperationParam;

@interface HJOperationManager (Upload)

/**
 *  上传文件
 */
- (NSURLSessionTask *)uploadWithParam:(HJUploadOperationParam *)aParam;

@end
