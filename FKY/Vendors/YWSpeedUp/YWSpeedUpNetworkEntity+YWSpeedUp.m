//
//  YWSpeedUpNetworkEntity+YWSpeedUp.m
//  YYW
//
//  Created by 张斌 on 2017/10/18.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "YWSpeedUpNetworkEntity+YWSpeedUp.h"

#import "YWSpeedUpManager.h"

#import "AFHTTPSessionManager.h"
#import "HJOperationManager.h"

@implementation YWSpeedUpNetworkEntity (YWSpeedUp)

- (void)configWithObject:(id)object
{
    if (object && [object isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask *task = object;
        if (![task respondsToSelector:@selector(response)]) {
            return;
        }
        
        id res = task.response;
        if (res && [res isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *responses = (NSHTTPURLResponse *)res;
            
            self.url = [YWSpeedUpManager urlExceptSecondParamFromStr:[responses.URL absoluteString]];
            self.contentLength = @(task.countOfBytesReceived);
            self.httpStatusCode = [NSString stringWithFormat:@"%zd",responses.statusCode];
            self.usedTime = @([[YWSpeedUpManager currentMillisecond] longLongValue]-[self.requestStartTime longLongValue]);
        }
    }
}

@end
