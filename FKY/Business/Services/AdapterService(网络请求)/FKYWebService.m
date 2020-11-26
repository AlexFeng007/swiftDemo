//
//  FKYWebService.m
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "FKYWebService.h"

@implementation FKYWebService

#pragma mark - Public

// get
+ (HJOperationParam *)getRequest:(NSString *)action
                           param:(NSDictionary *)param
                     returnClass:(Class)returnClass
                         success:(RequestSuccessBlock)success
                         failure:(RequestFailureBlock)fail
{
    HJOperationParam *operationParam = [HJOperationParam paramWithApiName:action type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        // parse and return data-model
        [FKYWebService handleResponseData:aResponseObject error:anError returnClass:returnClass success:success failure:fail];
    }];
    return operationParam;
}

// post
+ (HJOperationParam *)postRequest:(NSString *)action
                            param:(NSDictionary *)param
                      returnClass:(Class)returnClass
                          success:(RequestSuccessBlock)success
                          failure:(RequestFailureBlock)fail
{
    HJOperationParam *operationParam = [HJOperationParam paramWithApiName:action type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        // parse and return data-model
        [FKYWebService handleResponseData:aResponseObject error:anError returnClass:returnClass success:success failure:fail];
    }];
    return operationParam;
}

// post for bi
+ (HJOperationParam *)postBiRequest:(NSString *)url
                              param:(NSDictionary *)param
                        returnClass:(Class)returnClass
                            success:(RequestSuccessBlock)success
                            failure:(RequestFailureBlock)fail
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBiUrl:url type:kRequestPost param:param callback:^(id aResponseObject, NSError *anError) {
        // parse and return data-model
        [FKYWebService handleResponseData:aResponseObject error:anError returnClass:returnClass success:success failure:fail];
    }];
    return operationParam;
}
// get for bi
+ (HJOperationParam *)getBiRequest:(NSString *)url
                             param:(NSDictionary *)param
                       returnClass:(Class)returnClass
                           success:(RequestSuccessBlock)success
                           failure:(RequestFailureBlock)fail
{
    HJOperationParam *operationParam = [HJOperationParam paramWithBiUrl:url type:kRequestGet param:param callback:^(id aResponseObject, NSError *anError) {
        // parse and return data-model
        [FKYWebService handleResponseData:aResponseObject error:anError returnClass:returnClass success:success failure:fail];
    }];
    return operationParam;
}
// upload...<image>
+ (void)uploadImage:(NSString *)action
               data:(NSData *)imgData
              param:(NSDictionary *)param
        returnClass:(Class)returnClass
            success:(RequestSuccessBlock)success
            failure:(RequestFailureBlock)fail
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:action]];
    request.HTTPMethod = @"POST";
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:imgData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // parse and return data-model
        [FKYWebService handleResponseData:responseObject error:error returnClass:returnClass success:success failure:fail];
    }];
    [uploadTask resume];
}

// download



#pragma mark - Private

// 数据解析及返回...<aResponseObject为接口返回数据中的data字段对应内容>
+ (void)handleResponseData:(id)aResponseObject
                     error:(NSError *)anError
               returnClass:(Class)returnClass
                   success:(RequestSuccessBlock)successBlock
                   failure:(RequestFailureBlock)failBlock
{
    if (!anError) {
        // 请求成功
        if (successBlock) {
            // block不为空
            id model = nil; // json解析后的model对象
            if (aResponseObject && returnClass) {
                //                [FKYWebService getAllProperties:returnClass];
                //                [FKYWebService logAllMethods:returnClass];
                // 分类判断
                if ([aResponseObject isKindOfClass:[NSString class]]
                    || [aResponseObject isKindOfClass:[NSNumber class]]) {
                    // 字符串 or 数字
                }
                else if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
                    // 字典...<解析>
                    if ([returnClass respondsToSelector:@selector(fromJSON:)]) {
                        // swift定义的model...<升到Swift4.2后，fromJSON前需加@objc，否则方法不识别>
                        model = [returnClass fromJSON:aResponseObject];
                    }
                    else {
                        // oc定义的model
                        // 注：当前使用OC的YYModel进行解析，故对应的Model需按YYModel的要求来使用，具体可参照FKYProductRecommendListModel...<YYModel比Mantle更优>
                        model = [returnClass yy_modelWithDictionary:aResponseObject];
                    }
                    // YYModel框架可以解析oc与swift两种方式定义的model...<swfit-model中的Int?类型无法解析>
                    //                    model = [returnClass yy_modelWithDictionary:aResponseObject];
                }
                else if ([aResponseObject isKindOfClass:[NSArray class]]) {
                    // 数组...<解析>
                    NSMutableArray *arrayModel = [NSMutableArray array];
                    for (NSDictionary *item in (NSArray *)aResponseObject) {
                        if ([returnClass respondsToSelector:@selector(fromJSON:)]) {
                            // swift定义的model...<升到Swift4.2后，fromJSON前需加@objc，否则方法不识别>
                            id obj = [returnClass fromJSON:item];
                            if (obj) {
                                [arrayModel addObject:obj];
                            }
                        }
                        else {
                            // oc定义的model
                            // 注：当前使用OC的YYModel进行解析，故对应的Model需按YYModel的要求来使用，具体可参照FKYProductRecommendListModel...<YYModel比Mantle更优>
                            id obj = [returnClass yy_modelWithDictionary:item];
                            if (obj) {
                                [arrayModel addObject:obj];
                            }
                        }
                        // YYModel框架可以解析oc与swift两种方式定义的model...<swfit-model中的Int?类型无法解析>
                        //                        id obj = [returnClass yy_modelWithDictionary:item];
                        //                        if (obj) {
                        //                            [arrayModel addObject:obj];
                        //                        }
                    } // for
                    if (arrayModel.count > 0) {
                        model = arrayModel;
                    }
                } // type
            } // not nil
            // 返回数据
            successBlock(aResponseObject, model);
        }
    }
    else {
        // 请求失败
        if (failBlock) {
            // block不为空
            failBlock(nil, anError);
        }
    }
}


#pragma mark - Test

+ (NSArray *)getAllProperties:(Class)class
{
    u_int count;
    
    //使用class_copyPropertyList及property_getName获取类的属性列表及每个属性的名称
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char* propertyName = property_getName(properties[i]);
        NSLog(@"属性%@\n", [NSString stringWithUTF8String: propertyName]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

+ (void)logAllMethods:(Class)class
{
    u_int count;
    
    //class_copyMethodList 获取类的所有方法列表
    Method *mothList_f = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method temp_f = mothList_f[i];
        // method_getImplementation 由Method得到IMP函数指针
        IMP imp_f = method_getImplementation(temp_f);
        // method_getName 由Method得到SEL
        SEL name_f = method_getName(temp_f);
        
        const char * name_s = sel_getName(name_f);
        // method_getNumberOfArguments  由Method得到参数个数
        int arguments = method_getNumberOfArguments(temp_f);
        // method_getTypeEncoding  由Method得到Encoding 类型
        const char * encoding = method_getTypeEncoding(temp_f);
        
        NSLog(@"方法名：%@\n, 参数个数：%d\n, 编码方式：%@\n", [NSString stringWithUTF8String:name_s],
              arguments, [NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}


@end
