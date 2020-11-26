//
//  NSUserDefaults+FKYExtension.h
//  FKY
//
//  Created by yangyouyong on 15/9/9.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - UserDefaults 简写
#define UD                      [NSUserDefaults standardUserDefaults]
#define UD_OB(_key)             [UD objectForKey:_key]
#define UD_ADD_OB(_ob, _key)    [UD setObject:_ob forKey:_key]
#define UD_RM_OB(_key)          [UD removeObjectForKey:_key]


#pragma mark - UserDefaults Keys

FOUNDATION_EXTERN NSString *const FKYLocationKey;

FOUNDATION_EXTERN NSString *const FKYCurrentUserKey;
FOUNDATION_EXTERN NSString *const FKYCurrentAddressKey;
FOUNDATION_EXTERN NSString *const FKYMarkAuditStatusForHomeWebPage;


#pragma mark - debugAPI

FOUNDATION_EXTERN NSString *const FKYMainAPIKey;

FOUNDATION_EXTERN NSString * GET_MAIN_API(void);
FOUNDATION_EXTERN void SET_MAIN_API(NSString *apiString);
FOUNDATION_EXTERN NSString * GET_PIC_HOST(void);
FOUNDATION_EXTERN NSString * GET_PC_HOST(void);

@interface NSUserDefaults (FKYExtension)

@end
