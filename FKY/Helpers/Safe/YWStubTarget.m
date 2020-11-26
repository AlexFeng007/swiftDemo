//
//  YWStubTarget.m
//  YYW
//
//  Created by HUI on 2019/2/14.
//  Copyright © 2019 YYW. All rights reserved.
//

#import "YWStubTarget.h"

@implementation YWStubTarget

- (void)fireProxyTimer:(NSTimer *)userInfo {
    if (self.weakTarget) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.weakTarget performSelector:self.weakSelector withObject:userInfo];
#pragma clang diagnostic pop
    } else {
        [self.weakTimer invalidate];
        self.weakTimer = nil;
    }
}

- (void)dealloc {
    NSLog(@"YWStubTarget dealloc");
}

@end
