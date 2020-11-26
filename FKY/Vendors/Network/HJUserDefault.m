//
//  HJUserDefault.m
//  YYW
//
//  Created by 张斌 on 2017/3/9.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "HJUserDefault.h"

@implementation HJUserDefault

+ (void)setValue:(id)anObject forKey:(NSString *)aKey {
    if ( ! aKey || ! [aKey isKindOfClass:[NSString class]]) {
        return ;
    }
    
    if (anObject)
    {
        [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:aKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValueForKey:(NSString *)aKey {
    if ( ! aKey || ! [aKey isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
}

@end
