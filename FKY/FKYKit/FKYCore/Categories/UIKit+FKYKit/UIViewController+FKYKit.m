//
//  UIViewController+FKYKit.m
//  FKY
//
//  Created by mahui on 15/12/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "UIViewController+FKYKit.h"
#import <objc/runtime.h>
#import "MobClick.h"

@implementation UIViewController (FKYKit)

//+ (void)load{
//    SEL viewWillAppearSelector = @selector(viewWillAppear:);
//    SEL midSelector = viewWillAppearSelector;
//    SEL exchangSelector = @selector(FKY_viewWillAppear:);
//    
//    Method originMethod = class_getClassMethod(self, midSelector);
//    Method exchangMethod = class_getClassMethod(self, exchangSelector);
//    method_exchangeImplementations(originMethod, exchangMethod);
//    
//    SEL disappearSelector = @selector(viewWillDisappear:);
//    SEL midDisappearSelector = disappearSelector;
//    SEL exchangDisappearSelector = @selector(FKY_viewWillDisappear:);
//    
//    Method originDisappearMethod = class_getClassMethod(self, midDisappearSelector);
//    Method exchangDisappearMethod = class_getClassMethod(self, exchangDisappearSelector);
//    method_exchangeImplementations(originDisappearMethod, exchangDisappearMethod);
//}
//
//- (void)FKY_viewWillAppear:(BOOL)animated{
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
//}
//
//- (void)FKY_viewWillDisappear:(BOOL)animated{
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
//}

@end
