//
//  FKYNetworkManager.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNetworkManager.h"
#import "FKYNetworkResponse.h"
#import "FKYEnvironment.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFURLRequestSerialization.h>
@import CocoaLumberjack;
#import <Aspects/Aspects.h>

#import "FKYInternal.h"
#import "FKYNetworkManager_private.h"

NSString * const FKYNetworkingReachabilityDidChangeNotification = @"com.111.networking.reachability.change";
NSString * const FKYNetworkingReachabilityNotificationStatusItem = @"FKYNetworkingReachabilityNotificationStatusItem";

static id<FKYNetworkAgent> __nagent;

void HCInternalSetNetworkAgent(id<FKYNetworkAgent> agent)
{
    __nagent = agent;
}


@interface FKYNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *headerUpdateOperationManager;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@end


@implementation FKYNetworkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FKYNetworkManager *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    
    return staticInstance;
}

- (void)updateURLSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    [self updateURLSessionConfiguration:configuration baseURL:nil];
}

- (void)updateURLSessionConfiguration:(NSURLSessionConfiguration *)configuration baseURL:(NSURL *)baseURL {
    if (self.sessionManager) {
        // 取消所有的请求
        [[self.sessionManager session] invalidateAndCancel];
    }
    AFHTTPSessionManager *newManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    self.sessionManager = newManager;
    [self addLogForSession:self.sessionManager.session];
    
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer new];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    self.sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    // FKYEnvironmentImpl
    FKYEnvironment *environment = [FKYEnvironment defaultEnvironment];
    // 设置超时...<非adapter>
    self.sessionManager.requestSerializer.timeoutInterval = [environment HTTPRequestTimeoutInterval];
    
    // 配置默认的HTTPHeader
    {
        #warning Content-Type 待后台更改后更正过来 //application/json
        [self.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *userAgent = [environment userAgent];
        NSString *userAgentForHTTPHeaderField = [environment userAgentForHTTPHeaderField];
        if (userAgent && userAgentForHTTPHeaderField) {
            [self.sessionManager.requestSerializer setValue:userAgent forHTTPHeaderField:userAgentForHTTPHeaderField];
        }
        
        NSString *deviceId = [environment deviceId];
        NSString *deviceIdForHTTPHeaderField = [environment deviceIdForHTTPHeaderField];
        if (deviceId && deviceIdForHTTPHeaderField) {
            [self.sessionManager.requestSerializer setValue:deviceId forHTTPHeaderField:deviceIdForHTTPHeaderField];
        }
    }
}

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static FKYNetworkManager *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[[self class] alloc] init];
    });
    
    return staticInstance;
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.defaultResponseModel = [FKYNetworkResponse class];
    [self updateURLSessionConfiguration:configuration baseURL:url];
    
    [self startMonitoring];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configUserTokenHeaderWithString:(NSString *)url {
    // 设置token
    NSString *userToken = [[FKYEnvironment defaultEnvironment] userToken];
    NSString *userTokenForHTTPHeaderField = [[FKYEnvironment defaultEnvironment] userTokenForHTTPHeaderField];
    if (userToken && userTokenForHTTPHeaderField) {
        [self.sessionManager.requestSerializer setValue:userToken forHTTPHeaderField:userTokenForHTTPHeaderField];
    }
    
    if ([url containsString:@"aliappPay/getAppPayParams"]) {
        [self.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }else{
        [self.sessionManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
//    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    [self.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    
    // header 信息
    [self.sessionManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"os"];
    [self.sessionManager.requestSerializer setValue:[[FKYEnvironment defaultEnvironment] station]
                                 forHTTPHeaderField:@"station"];
    [self.sessionManager.requestSerializer setValue:[[FKYEnvironment defaultEnvironment] version]
                                 forHTTPHeaderField:@"version"];
    NSString *versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [self.sessionManager.requestSerializer setValue:versionCode
                                 forHTTPHeaderField:@"versionNum"];
}

- (NSString *)adapterUrl:(NSString *)path
{
    if (__nagent && [__nagent respondsToSelector:@selector(switchUrl:)]) {
        return [__nagent switchUrl:path];
    }
    return path;
}

- (NSURLRequest *)adapterRequest:(NSURLRequest *)request
{
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        if (__nagent && [__nagent respondsToSelector:@selector(switchUrl:)]) {
            [((NSMutableURLRequest *)request) setURL:[NSURL URLWithString:[__nagent switchUrl:request.URL.absoluteString]]];
        }
    }
    return request;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                  decodeClass:(Class)decodeClass
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYNetworkFailureBlock)failure {
    
    [self configUserTokenHeaderWithString:URLString];
    return [self.sessionManager GET:[self adapterUrl:URLString]
                         parameters:[self mergeParameters:parameters]
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                [self handleSuccess:success
                                           withTask:task
                                        decodeClass:decodeClass
                                     responseObject:responseObject];
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self handleFailure:failure
                                           withTask:task
                                              error:error];
                            }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                   decodeClass:(Class)decodeClass
                       success:(FKYNetworkSuccessBlock)success
                       failure:(FKYNetworkFailureBlock)failure {
    [self configUserTokenHeaderWithString:URLString];
    return [self.sessionManager POST:[self adapterUrl:URLString]
                          parameters:[self mergeParameters:parameters]
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [self handleSuccess:success
                                            withTask:task
                                         decodeClass:decodeClass
                                      responseObject:responseObject];
                             }
                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 [self handleFailure:failure
                                            withTask:task
                                               error:error];
                             }];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(FKYNetworkSuccessBlock)success
                      failure:(FKYNetworkFailureBlock)failure {
    [self configUserTokenHeaderWithString:URLString];
    return [self.sessionManager PUT:[self adapterUrl:URLString]
                         parameters:[self mergeParameters:parameters]
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                [self handleSuccess:success
                                           withTask:task
                                        decodeClass:nil
                                     responseObject:responseObject];
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self handleFailure:failure
                                           withTask:task
                                              error:error];
                            }];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(FKYNetworkSuccessBlock)success
                         failure:(FKYNetworkFailureBlock)failure {
    [self configUserTokenHeaderWithString:URLString];
    return [self.sessionManager DELETE:[self adapterUrl:URLString]
                            parameters:[self mergeParameters:parameters]
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   [self handleSuccess:success
                                              withTask:task
                                           decodeClass:nil
                                        responseObject:responseObject];
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [self handleFailure:failure
                                              withTask:task
                                                 error:error];
                               }];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                      decodeClass:(Class)decodeClass
                          success:(FKYNetworkSuccessBlock)success
                          failure:(FKYNetworkFailureBlock)failure;
{
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:[self adapterRequest:request] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (responseObject && !error) {
            if (success) {
                FKYNetworkResponse *networkResponse = [self decodeResponseObject:responseObject
                                                                       response:response
                                                                      withClass:decodeClass];
                success(request, networkResponse);
            }
        } else {
            if (failure) {
                FKYNetworkResponse *networkResponse = [FKYNetworkResponse responseWithStatusCode:@(error.code) errorMessage:error.description];
                failure(request, networkResponse, error);
            }
        }
    }];
    [task resume];
    return task;
}

#pragma mark - networkReachabilityStatus
- (void)startMonitoring
{
    [self.sessionManager.reachabilityManager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (FKYNetworkReachabilityStatus)networkReachabilityStatus
{
    return [self transferStatus:self.sessionManager.reachabilityManager.networkReachabilityStatus];
}

- (void)setReachabilityStatusChangeBlock:(void (^)(FKYNetworkReachabilityStatus status))block
{
    __weak FKYNetworkManager *weakSelf = self;
    [self.sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            block([weakSelf transferStatus:status]);
        }
    }];
}

- (void)networkingReachabilityDidChangeNotification:(NSNotification *)n
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FKYNetworkingReachabilityDidChangeNotification
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:@(self.networkReachabilityStatus) forKey:FKYNetworkingReachabilityNotificationStatusItem]];
}


#pragma mark - Private

- (FKYNetworkReachabilityStatus)transferStatus:(AFNetworkReachabilityStatus)status
{
    FKYNetworkReachabilityStatus hjStatus = FKYNetworkReachabilityStatusUnknown;
    
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        hjStatus = FKYNetworkReachabilityStatusReachableViaWiFi;
    } else if (status == FKYNetworkReachabilityStatusReachableViaWWAN) {
        hjStatus = FKYNetworkReachabilityStatusReachableViaWWAN;
    } else if (status == AFNetworkReachabilityStatusNotReachable) {
        hjStatus = FKYNetworkReachabilityStatusNotReachable;
    }
    
    return hjStatus;
}

- (NSDictionary *)mergeParameters:(NSDictionary *)parameters {
    NSMutableDictionary *newParameters = [parameters mutableCopy];
    [newParameters addEntriesFromDictionary:self.commonParameters];
    return [newParameters copy];
}

- (FKYNetworkResponse *)decodeResponseObject:(id)responseObject response:(NSURLResponse *)response withClass:(Class)aClass {
    return [[self.defaultResponseModel alloc] initWithContent:responseObject response:response modelClass:aClass];
}

- (void)addLogForSession:(NSURLSession *)session {
    [session aspect_hookSelector:@selector(dataTaskWithRequest:)
                     withOptions:AspectPositionAfter
                      usingBlock:^(id<AspectInfo> aspectInfo, NSURLRequest *request){
     }error:nil];
}

- (void)handleFailure:(FKYNetworkFailureBlock)failure withTask:(NSURLSessionDataTask *)task error:(NSError *)error
{
    if (failure) {
        FKYNetworkResponse *networkResponse = [FKYNetworkResponse responseWithStatusCode:@(error.code) errorMessage:error.description];
        [WUMonitorInstance saveApiError:task.originalRequest.URL.absoluteString error:error];
        failure(task.currentRequest, networkResponse, error);
    }
}

- (void)handleSuccess:(FKYNetworkSuccessBlock)success withTask:(NSURLSessionDataTask *)task decodeClass:(Class)decodeClass responseObject:(id)responseObject
{
    if (success) {
        FKYNetworkResponse *networkResponse = [self decodeResponseObject:responseObject
                                                               response:task.response
                                                              withClass:decodeClass];
        
        success(task.currentRequest, networkResponse);
    }
}

- (void)cancelTaskWithIdentifier:(NSUInteger)taskIdentifier
{
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        if (task.taskIdentifier == taskIdentifier) {
            [task cancel];
        }
    }
}

- (void)cancelAllTasks
{
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

- (void)cancelHTTPTaskWithMethod:(NSString *)method path:(NSString *)path
{
    if (path.length <= 0) return;
    
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer] requestWithMethod:(method ?: @"GET") URLString:path parameters:nil error:nil];
    NSString *requestPath = request.URL.path;
    NSString *requestMethod = [request HTTPMethod];
    
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        if ([task.originalRequest.URL.path isEqualToString: requestPath]) {
            if ([task.originalRequest.HTTPMethod isEqualToString:requestMethod]) {
                [task cancel];
            }
        }
    }
}

- (NSString *)componentUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        NSURLRequest *request = [self.sessionManager.requestSerializer requestBySerializingRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] withParameters:parameters error:nil];
        return request.URL.absoluteString;
    } else {
        return url;
    }
}

@end
