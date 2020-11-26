//
//  NSString+WUMMD5.h
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WUMMD5)

-(NSString *)MD5ForLower32Bate; // MD5加密, 32位 小写
-(NSString *)MD5ForUpper32Bate; // MD5加密, 32位 大写
-(NSString *)MD5ForLower16Bate; // MD5加密, 16位 小写
-(NSString *)MD5ForUpper16Bate; // MD5加密, 16位 大写

- (NSString *)stringFromMD5;

@end
