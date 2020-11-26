//
//  FKYWebService.h
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  网络层

#import <Foundation/Foundation.h>
#import "FKYApiList.h"


// 请求成功
typedef void (^RequestSuccessBlock)(id response, id model);
// 请求失败
typedef void (^RequestFailureBlock)(id response, NSError *error);



@interface FKYWebService : NSObject

// get
+ (HJOperationParam *)getRequest:(NSString *)action
                           param:(NSDictionary *)param
                     returnClass:(Class)returnClass
                         success:(RequestSuccessBlock)success
                         failure:(RequestFailureBlock)fail;

// post
+ (HJOperationParam *)postRequest:(NSString *)action
                            param:(NSDictionary *)param
                      returnClass:(Class)returnClass
                          success:(RequestSuccessBlock)success
                          failure:(RequestFailureBlock)fail;

// post for bi
+ (HJOperationParam *)postBiRequest:(NSString *)action
                              param:(NSDictionary *)param
                        returnClass:(Class)returnClass
                            success:(RequestSuccessBlock)success
                            failure:(RequestFailureBlock)fail;
//get for bi
+ (HJOperationParam *)getBiRequest:(NSString *)url
                              param:(NSDictionary *)param
                        returnClass:(Class)returnClass
                            success:(RequestSuccessBlock)success
                            failure:(RequestFailureBlock)fail;
// upload
+ (void)uploadImage:(NSString *)action
               data:(NSData *)imgData
              param:(NSDictionary *)param
        returnClass:(Class)returnClass
            success:(RequestSuccessBlock)success
            failure:(RequestFailureBlock)fail;

// download


@end
