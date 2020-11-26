//
//  GLHybridSettings.h
//  YYW
//
//  Created by Rabe on 17/04/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHybridSettings : NSObject

+ (id)settingForKey:(NSString *)key class:(Class)cla defaultVal:(id)val;

@end
