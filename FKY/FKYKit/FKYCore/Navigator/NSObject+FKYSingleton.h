//
//  NSObject+FKYSingleton.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FKYSingleton)

+ (BOOL)isAlreadyInStackForPop;

@end
