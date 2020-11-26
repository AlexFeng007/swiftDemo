//
//  FKYWebURLMap
//  FKY
//
//  Created by yangyouyong on 2017/1/11.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYWebURLMap.h"
#import "FKYWebSchemeProtocol.h"

@implementation FKYWebURLMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maps = @{
                      NSStringFromProtocol(@protocol(FKY_Web)) : GLWebVC.class,
                      };
    }
    return self;
}

@end
