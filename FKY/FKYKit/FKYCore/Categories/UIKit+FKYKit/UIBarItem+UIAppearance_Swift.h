//
//  UIBarItem+UIAppearance_Swift.h
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarItem (UIAppearance_Swift)

+ (instancetype)aw_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;

@end
