//
//  FKYInternal.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYEnvironment.h"

#pragma mark - FKYEnvironment

void FKYInternalSetDefaultEnvironment(FKYEnvironment *eHJ);

#pragma mark - Network

@protocol FKYNetworkAgent <NSObject>

@optional
- (NSString *)switchUrl:(NSString *)url;

@end

void FKYInternalSetNetworkAgent(id<FKYNetworkAgent> agent);
void FKYInternalSetNetworkDomain(NSString *from, NSString *to);
void FKYInternalSetNetworkDelay(NSTimeInterval delay);
void FKYInternalSetNetworkFail(double percent);