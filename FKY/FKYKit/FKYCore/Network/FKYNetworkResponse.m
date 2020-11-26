//
//  FKYNetworkResponse.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNetworkResponse.h"
#import <CocoaLumberjack/DDLog.h>


@interface FKYNetworkResponse ()

@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) id modelObject;
@property (nonatomic, strong) id originalContent;

@end


@implementation FKYNetworkResponse

+ (instancetype)responseWithStatusCode:(NSNumber *)code errorMessage:(NSString *)message
{
    FKYNetworkResponse *response = [[self alloc] init];
    response.statusCode = code;
    response.errorMessage = message;
    return response;
}

- (instancetype)initWithContent:(id)content
                       response:(NSURLResponse *)response
                     modelClass:(Class)modelClass
{
    self = [super init];
    if (self) {
        _originalContent = content;
        _response = response;
        
        if (content && [content isKindOfClass:[NSData class]]) {
            NSError *error;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:0 error:&error];
            if (jsonObj) {
                _originalContent = jsonObj;
            } else {
                DDLogError(@"%@", error);
            }
        }
        
        id parseContent = _originalContent;
        if ([parseContent isKindOfClass:[NSDictionary class]]) {
            _errorMessage = [parseContent valueForKey:@"message"];
            if (modelClass) {
                id data = [parseContent valueForKey:@"data"] ? : [parseContent valueForKey:@"content"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSError *error = nil;
                    _modelObject = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:data error:&error];
                    if (error) {
                        DDLogError(@"%@", error);
                    }
                } else if ([data isKindOfClass:[NSArray class]]) {
                    NSError *error = nil;
                    _modelObject = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:data error:&error];
                    if (error){
                        DDLogError(@"%@", error);
                    }
                }
            }
        }
    }
    return self;
}

- (NSDate *)httpResponseDate
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)self.response;
    NSString *serviceDataString = httpResponse.allHeaderFields[@"Date"];
    
    if (serviceDataString.length == 0) {
        return nil;
    }
    
    static NSDateFormatter *HTTPDateFormatter;
    if (HTTPDateFormatter == nil) {
        HTTPDateFormatter = [[NSDateFormatter alloc] init];
        HTTPDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        
        NSString *calendarIdentifier = nil;
#if defined(__IPHONE_8_0) || defined(__MAC_10_10)
        calendarIdentifier = NSCalendarIdentifierGregorian;
#else
        calendarIdentifier = NSGregorianCalendar;
#endif
        
        HTTPDateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier];
        HTTPDateFormatter.dateFormat = @"EEE', 'dd' 'MMM' 'yyyy' 'HH':'mm':'ss' 'zzz";
    }
    
    return [HTTPDateFormatter dateFromString:serviceDataString];
}


@end
