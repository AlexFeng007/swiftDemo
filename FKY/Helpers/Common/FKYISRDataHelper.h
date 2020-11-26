//
//  FKYISRDataHelper.h
//  FKY
//
//  Created by hui on 2018/6/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYISRDataHelper : NSObject

/**
 parse JSON data
 **/
+ (NSString *)stringFromJson:(NSString*)params;//

/**
 parse JSON data for cloud grammar recognition
 **/
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end
