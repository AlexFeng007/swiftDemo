//
//  UIBarButtonItem+FKY.m
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "UIBarButtonItem+FKY.h"

@implementation UIBarButtonItem (FKY)

+ (UIBarButtonItem*)fky_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}

@end
