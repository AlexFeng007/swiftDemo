//
//  UIBarItem+UIAppearance_Swift.m
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "UIBarItem+UIAppearance_Swift.h"

@implementation UIBarItem (UIAppearance_Swift)

+ (instancetype)aw_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass{
    return [self appearanceWhenContainedIn:containerClass, nil];
}

@end
