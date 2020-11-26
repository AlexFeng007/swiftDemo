//
//  PhoneLaunchLogic.m
//  IHome4Phone
//
//  Created by bibibi on 15/7/23.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJLaunchLogic.h"
#import "NSString+RSASecurity.h"
//NI
#import "HJNILaunch.h"
#import "HJGlobalValue.h"


@interface HJGlobalValue()

@property (nonatomic, copy) NSString *signatureKey;//解密后的签名密钥

@end


@implementation HJLaunchLogic

- (void)getMySecretKey:(HJCompletionBlock)aCompletionBlock
{
    HJOperationParam *param = [HJNILaunch getMySecretKey:^(id aResponseObject, NSError *anError) {
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *theDict = aResponseObject;
            NSString *ckey = theDict[@"ckey"];
            NSString *signatureKey = [ckey decryptByRSAKeyWithKeyType:HJRSAKeyTypePrivate error:nil];
            [HJGlobalValue sharedInstance].signatureKey = signatureKey;
            NSNumber *sTime = theDict[@"stime"];
            NSTimeInterval lTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval dTime = sTime.doubleValue/1000 - lTime;
            [HJGlobalValue sharedInstance].deltaTime = dTime;
        }
        
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    
    [self.operationManger requestWithParam:param];
}

@end
