//
//  HJOperationManager+Upload.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import "HJOperationManager+Upload.h"
#import "HJOperationParam.h"
#import "HJUploadOperationParam.h"
#import "HJUploadFileValue.h"

@interface HJOperationParam ()

#pragma mark - 接口调用相关
@property(nonatomic, copy) NSString *requestUrl;                        //请求url
@property(nonatomic, strong) NSDictionary *requestParam;                //参数

@end

@implementation HJOperationManager (Upload)

- (NSURLSessionTask *)uploadWithParam:(HJUploadOperationParam *)aParam
{
    if (aParam == nil) {
        return nil;
    }
    
    //超时时间
    self.requestSerializer.timeoutInterval = aParam.timeoutTime;
    
    NSURLSessionDataTask *requestOperation = [self POST:aParam.requestUrl parameters:aParam.requestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *mimeTypeStr = nil;
        if (aParam.uploadType == kUpLoadData) {
            switch (aParam.mimeType) {
                case kPng:
                    mimeTypeStr = @"image/png";
                    break;
                case kJpg:
                    mimeTypeStr = @"image/jpg";
                    break;
                default:
                    break;
            }
            if (aParam.uploadFileValues.count > 0) {
                for (HJUploadFileValue *fileValue in aParam.uploadFileValues) {
                    [formData appendPartWithFileData:fileValue.fileData name:aParam.name fileName:fileValue.fileName mimeType:mimeTypeStr];
                }
            } else {
                [formData appendPartWithFileData:aParam.fileData name:aParam.name fileName:aParam.fileName mimeType:mimeTypeStr];
            }
        } else {
            [formData appendPartWithFileURL:aParam.fileUrl name:aParam.name error:nil];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (aParam.callbackBlock) {
            aParam.callbackBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (aParam.callbackBlock) {
            aParam.callbackBlock(nil, error);
        }
    }];
    
    return requestOperation;
}

@end
