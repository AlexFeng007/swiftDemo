//
//  NSString+RSASecurity.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import "NSString+RSASecurity.h"

#import <openssl/pem.h>
#import <openssl/err.h>
#import <openssl/bio.h>
#import "NSData+Base64.h"
#import "NSError+HJFramework.h"

typedef enum {
    kRsaPaddingTypeNone = RSA_NO_PADDING,
    kRsaPaddingTypePKCS1 = RSA_PKCS1_PADDING,
    kRsaPaddingTypeSSLV23 = RSA_SSLV23_PADDING
} ERsaPaddingType;

@implementation NSString (RSASecurity)

- (NSString *)rsaKey
{
    return
        @"-----BEGIN RSA PRIVATE KEY-----\n"
         "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANdAbyufGGyWb7Z/\n"
         "sSm7dsHSKeucJpMeFRAJgT7Zf6pZCBymf4e/DKSzcDrua+QhzK9XQQPccUN/4A2g\n"
         "xZXUTHnp0qo6ZJSaOuTuzlyNB6IizFftDeFLM7rX+Quko0f40TqIA+mb3oWDXmsK\n"
         "Nub7mtH3oOEs0bvO3YmA53ajXBeRAgMBAAECgYEAwXj+83xqnZ+SBb08ZkBDe+8F\n"
         "EuslmPJfCC0i6HTiVSD1M5tL4Z2NJbTLWYzXmRPwQGHy5B+OBpe3sUgikItjuEKR\n"
         "4PRAd2vtkTErnbPxwautgtgDyYLxn6IfuQqTYbxso2yZTO7CCb7QhL2gRfpfhYgf\n"
         "KaoH/4MC48FSEmB+xmECQQDxozXVZ2bqETK1XGECIYqWnWx64UUEA+K4pvbIU+MB\n"
         "wpzQyk9CKKJ5q00x+SuJT6/Jov+a3dSOk4Qyrzl9Hz2tAkEA5Au7vrnNCsnCgD7I\n"
         "tMCSM0LJdFGCX4//z22jXsow5KwajQXqLQEYTmp/l5q6R2kGa2eyOrSuWaH6gmf1\n"
         "Tx519QJAFEV27LJCBfzvXhuj38PkloIaaaygV5fj203WgjPXZXxoH3P5djlmeAKQ\n"
         "9VJL/rb6rlXIT7uwa02g14evsPl/+QJBALb2pwImBlmCeNf2B4fl/Sa9je4SO3y6\n"
         "hu6As5Oou0OsxXyh4zmKaFr53TbggFYs8GaaAwhQ0JW/fMLF764z7UUCQDKhKa4G\n"
         "uMpdEq0SDzXAWcSGydq315B5KAe+qfCS1kv5aPn04nKwv09B1C3Tbu6UWjf52kK/\n"
         "/kZ63n/Uv4HWwDs=\n"
         "-----END RSA PRIVATE KEY-----";
}

- (NSString *)encryptByRSAKeyWithKeyType:(HJRSAKeyType)keyType
                                   error:(NSError *__autoreleasing *)anError
{
    return [self encryptByRSAKey:[self rsaKey] keyType:keyType error:anError];
}

- (NSString *)decryptByRSAKeyWithKeyType:(HJRSAKeyType)keyType error:(NSError *__autoreleasing *)anError
{
    return [self decryptByRSAKey:[self rsaKey] keyType:keyType error:anError];
}

#define PADDING kRsaPaddingTypePKCS1

#pragma mark - 加密

/**
 *  RSA加密字符串。
 *  加密流程：RSA encrypt --> base64 encode
 *
 *  @param key       RSA秘钥
 *  @param keyType   秘钥类型（私钥 or 公钥）
 *  @param anError   错误信息
 *
 *  @return 加密并base64后的密文（NSUTF8Encoding）
 */
- (NSString *)encryptByRSAKey:(NSString *)textKey
                      keyType:(HJRSAKeyType)keyType
                        error:(NSError *__autoreleasing *)anError
{
    RSA *key = [self rsaKeyWithString:textKey withType:keyType];
    NSData *data = [self encryptByRSA:key
                              keyType:keyType
                                error:anError];
    return [data base64EncodedString];
}

// 未测试！！！！
- (NSString *)encryptByRSAKeyPath:(NSString *)keyName
                          keyType:(HJRSAKeyType)keyType
                            error:(NSError *__autoreleasing *)error
{
    RSA *key = [self rsaKeyWithPath:keyName keyType:keyType];
    NSData *data = [self encryptByRSA:key
                              keyType:keyType
                                error:error];
    return [data base64EncodedString];
}

- (NSData *)encryptByRSA:(RSA *)rsaKey
                 keyType:(HJRSAKeyType)keyType
                   error:(NSError *__autoreleasing *)anError
{
    if (!rsaKey) {
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:@"待加密明文或秘钥为空"];
        }
        return nil;
    }

    int status;
    const char *input = [self UTF8String];
    size_t length = strlen(input);

    NSInteger flen = [self getBlockSizeWithRsa:rsaKey PaddingType:PADDING];

    if (length > flen) {
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:[NSString stringWithFormat:@"明文长度过长，最大%d", (int)flen]];
        }
        return nil;
    }

    char *encData = (char *)malloc(flen);
    bzero(encData, flen);

    if (keyType == HJRSAKeyTypePrivate) {
        status = RSA_private_encrypt((int)length,
                                     (unsigned char *)input,
                                     (unsigned char *)encData,
                                     rsaKey,
                                     PADDING);
    }
    else {
        status = RSA_public_encrypt((int)length,
                                    (unsigned char *)input,
                                    (unsigned char *)encData,
                                    rsaKey,
                                    PADDING);
    }

    NSData *returnData = nil;
    if (status > 0) {
        returnData = [NSData dataWithBytes:encData length:status];
    }
    else {
        char buf[1024];
        ERR_error_string(ERR_get_error(), buf);
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:[NSString stringWithFormat:@"加密失败: %s", buf]];
        }
    }

    free(encData);
    encData = NULL;

    return returnData;
}

#pragma mark - 解密

/**
 *  RSA解密字符。
 *  解密流程：base64 decode --> RSA decrypt --> to string(NSUTF8StringEncoding)
 *
 *  @param encryptText 密文
 *  @param key         RSA秘钥
 *  @param keyType     秘钥类型（私钥 or 公钥）
 *  @param anError     返回的错误信息
 *
 *  @return 明文数据
 */
- (NSString *)decryptByRSAKey:(NSString *)textKey
                      keyType:(HJRSAKeyType)keyType
                        error:(NSError *__autoreleasing *)anError
{
    RSA *key = [self rsaKeyWithString:textKey withType:keyType];
    NSData *data = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [self decryptData:data
                                    byRSA:key
                                  keyType:keyType
                                    error:anError];
    NSString *plainText = [[NSString alloc] initWithData:plainData
                                                encoding:NSUTF8StringEncoding];
    return plainText;
}

- (NSString *)decryptByRSAKeyPath:(NSString *)keyName
                          keyType:(HJRSAKeyType)keyType
                            error:(NSError **)anError
{
    RSA *key = [self rsaKeyWithPath:keyName keyType:keyType];
    NSData *data = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [self decryptData:data
                                    byRSA:key
                                  keyType:keyType
                                    error:anError];
    NSString *plainText = [[NSString alloc] initWithData:plainData
                                                encoding:NSUTF8StringEncoding];
    return plainText;
}

- (NSData *)decryptData:(NSData *)encryptData
                  byRSA:(RSA *)rsaKey
                keyType:(HJRSAKeyType)keyType
                  error:(NSError **)anError
{
    if (!rsaKey || !encryptData || [encryptData length] <= 0) {
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:@"密文或秘钥为空"];
        }
        return nil;
    }

    int status;
    int length = (int)[encryptData length];

    NSInteger flen = [self getBlockSizeWithRsa:rsaKey PaddingType:PADDING];
    char *decData = (char *)malloc(flen);
    bzero(decData, flen);

    if (keyType == HJRSAKeyTypePrivate) {
        status = RSA_private_decrypt(length,
                                     (unsigned char *)[encryptData bytes],
                                     (unsigned char *)decData,
                                     rsaKey,
                                     PADDING);
    }
    else {
        status = RSA_public_decrypt(length,
                                    (unsigned char *)[encryptData bytes],
                                    (unsigned char *)decData,
                                    rsaKey,
                                    PADDING);
    }

    NSData *data = nil;
    if (status > 0) {
        data = [NSData dataWithBytes:decData length:strlen(decData)];
    }
    else {
        char buf[1024];
        ERR_error_string(ERR_get_error(), buf);
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:[NSString stringWithFormat:@"解密失败: %s", buf]];
        }
    }

    free(decData);
    decData = NULL;

    return data;
}

#pragma mark - 秘钥

/**
 *  从mainBundle中导入RSA公钥
 *  注意：该公钥文件为pem格式，不是公钥证书
 *
 *  @param name 公钥名，不包含后缀".pem"
 *  @param type 秘钥类型（公钥、私钥）
 *
 *  @return 是否导入成功
 */
- (RSA *)rsaKeyWithPath:(NSString *)keyPath keyType:(HJRSAKeyType)type
{
    RSA *rsaKey = NULL;

    FILE *file = fopen([keyPath UTF8String], "rb");

    if (NULL != file) {
        if (type == HJRSAKeyTypePrivate) {
            rsaKey = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
        }
        else {
            rsaKey = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
        }
        fclose(file);
    }

    return rsaKey;
}

/**
 *  从字符串中获取RSA秘钥
 *
 *  @param keyText 秘钥文本
 *  @param keyType 秘钥类型（私钥 or 公钥）
 *
 *  @return RSA 
 */
- (RSA *)rsaKeyWithString:(NSString *)keyText withType:(HJRSAKeyType)keyType
{
    const char *p = (char *)[keyText UTF8String];

    BIO *bufio;
    NSUInteger byteCount = [keyText lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

    bufio = BIO_new_mem_buf((void *)p, (int)byteCount);
    RSA *rsa = NULL;
    if (keyType == HJRSAKeyTypePrivate) {
        rsa = PEM_read_bio_RSAPrivateKey(bufio, NULL, NULL, NULL);
    }
    else {
        rsa = PEM_read_bio_RSA_PUBKEY(bufio, 0, 0, 0);
    }

    return rsa;
}

#pragma mark -

- (int)getBlockSizeWithRsa:(RSA *)rsaKey PaddingType:(ERsaPaddingType)paddingType
{
    int len = RSA_size(rsaKey);

    if (paddingType == kRsaPaddingTypePKCS1 || paddingType == kRsaPaddingTypeSSLV23) {
        len -= 11;
    }

    return len;
}

@end
