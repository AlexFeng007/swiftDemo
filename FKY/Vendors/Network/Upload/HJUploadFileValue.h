//
//  HJUploadFileValue.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJUploadFileValue : NSObject

@property(nonatomic, strong) NSData *fileData; //文件数据
@property(nonatomic, strong) NSString *fileName;

/**
 *  功能:初始化方法
 */
+ (instancetype)fileValueData:(NSData *)aData
                     fileName:(NSString *)aFileName;

@end
