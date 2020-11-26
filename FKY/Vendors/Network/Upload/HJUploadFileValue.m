//
//  HJUploadFileValue.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import "HJUploadFileValue.h"

@implementation HJUploadFileValue

/**
 *  功能:初始化方法
 */
+ (instancetype)fileValueData:(NSData *)aData
                     fileName:(NSString *)aFileName
{
    if (!aData) {
        return nil;
    }
    if (aFileName.length <= 0) {
        aFileName = @"file";
    }
    HJUploadFileValue *fileValue = [[self alloc] init];
    fileValue.fileData = aData;
    fileValue.fileName = aFileName;
    return fileValue;
}

@end
