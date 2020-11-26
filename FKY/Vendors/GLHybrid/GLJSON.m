//
//  GLJSON.m
//  YYW
//
//  Created by Rabe on 2017/2/23.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLJSON.h"

@implementation NSArray (GLJSONSerializing)

- (NSString *)gl_JSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];

    if (error != nil) {
        NSLog(@"NSArray JSONString error: %@", [error localizedDescription]);
        return nil;
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSDictionary (GLJSONSerializing)

- (NSString *)gl_JSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];

    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSString (GLJSONSerializing)

- (id)gl_JSONObject
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];

    if (error != nil) {
        NSLog(@"NSString JSONObject error: %@", [error localizedDescription]);
    }

    return object;
}

@end
