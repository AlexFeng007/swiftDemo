//
//  NSError+HJFramework.m
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import "NSError+HJFramework.h"

NSString * const HJFrameworkErrorDomain = @"HJFrameworkError";

@implementation NSError (HJFramework)

+ (NSError *)frameworkErrorWithMessage:(NSString *)errorMessage {
    NSString *message = errorMessage ? errorMessage : @"Unknow reason.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
    id error = [self errorWithDomain:HJFrameworkErrorDomain code:0 userInfo:userInfo];
    return error;
}

@end
