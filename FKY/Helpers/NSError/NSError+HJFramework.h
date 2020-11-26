//
//  NSError+HJFramework.h
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HJFramework)

+ (NSError *)frameworkErrorWithMessage:(NSString *)errorMessage;

@end
