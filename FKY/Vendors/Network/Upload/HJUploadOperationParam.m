//
//  HJUploadOperationParam.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import "HJUploadOperationParam.h"
#import "HJUploadFileValue.h"

@interface HJOperationParam ()

@property(nonatomic, copy) NSString *requestUrl;                        //请求url
@property(nonatomic, assign) ERequestType requestType;                  //请求类型，post还是get方式，默认为post方式
@property(nonatomic, strong) NSDictionary *requestParam;                //参数

@end

@implementation HJUploadOperationParam

#pragma mark- Property

- (NSArray *)uploadFileValues
{
    if (_uploadFileValues == nil) {
        _uploadFileValues = [[NSMutableArray alloc] init];
    }
    return _uploadFileValues;
}
#pragma mark- PublicInterface

+ (instancetype)paramWithUrl:(NSString *)aUrl
                        name:(NSString *)name
                       files:(NSMutableArray *)fileValues
                       param:(NSDictionary *)aParam
                    mimeType:(EUpLoadFileMimeType)mimeType
                    callback:(HJCompletionBlock)aCallback;
{
    HJUploadOperationParam *param = [self new];
    param.requestUrl = aUrl;
    param.requestType = kRequestPost;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:aParam ? aParam : @{}];
    [params setValue:@"ZnJhbmtfMTk5MV9sb3ZlX2phZGVfMTAwNg==" forKey:@"key"];
    param.requestParam = [params copy];
    param.callbackBlock = aCallback;
    [param.uploadFileValues addObjectsFromArray:[fileValues copy]];
    param.name = name;
    param.mimeType = mimeType;
    param.uploadType = kUpLoadData;
    return param;
}

+ (instancetype)paramWithUrl:(NSString *)aUrl
                    fileData:(NSData *)fileData
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    memberId:(NSString *)memberId
                    mimeType:(EUpLoadFileMimeType)mimeType
                    callback:(HJCompletionBlock)aCallback
{    
    HJUploadOperationParam *param = [self new];
    param.requestUrl = aUrl;
    param.requestType = kRequestPost;
    param.requestParam = @{@"key" : @"ZnJhbmtfMTk5MV9sb3ZlX2phZGVfMTAwNg==", @"dir" : @"head", @"simpleFileName" : memberId};
//    param.requestParam = @{@"key" : @"ZnJhbmtfMTk5MV9sb3ZlX2phZGVfMTAwNg=="};
    param.callbackBlock = aCallback;
    param.name = name;
    param.mimeType = mimeType;
    param.uploadType = kUpLoadData;
    HJUploadFileValue *fileValue = [HJUploadFileValue fileValueData:fileData fileName:fileName];
    [param.uploadFileValues addObject:fileValue];
    return param;
}

+ (instancetype)paramWithUrl:(NSString *)aUrl
                     fileUrl:(NSURL *)fileUrl
                        name:(NSString *)name
                    callback:(HJCompletionBlock)aCallback
{
    HJUploadOperationParam *param = [self new];
    param.requestUrl = aUrl;
    param.requestType = kRequestPost;
    param.requestParam = nil;
    param.callbackBlock = aCallback;
    param.fileUrl = fileUrl;
    param.name = name;
    param.uploadType = kUpLoadUrl;
    return param;
}

@end
