//
//  FKYTabBarControllerURLMap.m
//  FKY
//
//  Created by yangyouyong on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYTabBarControllerURLMap.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYTabBarController.h"

@implementation FKYTabBarControllerURLMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
                      NSStringFromProtocol(@protocol(FKY_TabBarController)) : FKYTabBarController.class,
                      };
    }
    return self;
}

@end
