//
//  NSString+AESSecurity.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AESSecurity)

/**
 *  AES解密。
 *  解密流程：Base64 decode --> AES decrypt --> to string (NSUTF8StringEncoding)
 *
 *  @param key         秘钥
 *
 *  @return 明文
 */
- (NSString *)decryptByAESKey:(NSString *)key
                      error:(NSError **)anError;


/**
 *  AES加密。
 *  加密流程：AES encrypt --> Base64 encode
 *
 *  @param key       秘钥 (java 生成 --> to hex string)
 *
 *  @return 密文
 */
- (NSString *)encryptByAESKey:(NSString *)key
                        error:(NSError *__autoreleasing *)anError;

@end
