//
//  WUSignatureHelper.h
//  FKY
//
//  Created by Rabe on 01/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUSignatureHelper : NSObject

+ (NSString *)getLocalTimeStamp;
+ (NSString *)getSignature:(NSDictionary *)aDict secretKey:(NSString *)secretKey;

@end
