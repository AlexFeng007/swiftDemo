//
//  GLHybridSettings.m
//  YYW
//
//  Created by Rabe on 17/04/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLHybridSettings.h"

@implementation GLHybridSettings

+ (NSDictionary *)settingsOfHybridBundle
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hybridSettings" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (id)settingForKey:(NSString *)key class:(Class)cla defaultVal:(id)val
{
    NSDictionary *settings = [self settingsOfHybridBundle];
    if (settings && [settings.allKeys containsObject:key]) {
        id ret = [settings objectForKey:key];
        if ([ret isKindOfClass:cla]) {
            return ret;
        }
        return val;
    }
    return val;
}

@end
