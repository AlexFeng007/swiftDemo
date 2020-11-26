//
//  NSString+AESSecurity.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015 HJ. All rights reserved.
//

#import "NSString+AESSecurity.h"
#import "NSError+HJFramework.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (AESSecurity)

- (NSString *)decryptByAESKey:(NSString *)key
                        error:(NSError *__autoreleasing *)anError
{
    if (!key) {
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:@"秘钥为空"];
        }
        return nil;
    }

    NSData *data = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [self transform:kCCDecrypt
                                   data:data
                                  byKey:key
                                  error:anError];

    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

- (NSString *)encryptByAESKey:(NSString *)key
                        error:(NSError *__autoreleasing *)anError
{
    if (!key) {
        if (anError) {
            *anError = [NSError frameworkErrorWithMessage:@"秘钥为空"];
        }
        return nil;
    }

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainData = [self transform:kCCEncrypt
                                   data:data
                                  byKey:key
                                  error:anError];

    return [plainData base64EncodedString];
}

- (NSData *)transform:(CCOperation)encryptOrDecrypt
                 data:(NSData *)inputData
                byKey:(NSString *)key
                error:(NSError *__autoreleasing *)anError
{
    NSData *secretKey = [self getAESKey:key];

    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;

    uint8_t iv[kCCBlockSizeAES128 + 1];
    memset((void *)iv, 0x0, (size_t)sizeof(iv));

    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                             [secretKey bytes], kCCKeySizeAES128, iv, &cryptor);

    if (status != kCCSuccess) {
        return nil;
    }

    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[inputData length], true);

    void *buf = malloc(bufsize * sizeof(uint8_t));
    memset(buf, 0x0, bufsize);

    size_t bufused = 0;
    size_t bytesTotal = 0;

    status = CCCryptorUpdate(cryptor, [inputData bytes], (size_t)[inputData length],
                             buf, bufsize, &bufused);

    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }

    bytesTotal += bufused;

    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);

    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }

    bytesTotal += bufused;

    CCCryptorRelease(cryptor);

    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

- (NSData *)getAESKey:(NSString *)passport
{
    char key[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    NSData *keyData = [passport dataUsingEncoding:NSUTF8StringEncoding];
    char *keyBytes = (char *)[keyData bytes];

    NSInteger len = keyData.length < 16 ? keyData.length : 16;
    for (int i = 0; i < len; i++) {
        key[i] = keyBytes[i];
    }
    return [NSData dataWithBytes:key length:16];
}

@end
