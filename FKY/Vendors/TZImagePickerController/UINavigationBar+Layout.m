//
//  UINavigationBar+Layout.m
//  FKY
//
//  Created by 夏志勇 on 2019/9/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "UINavigationBar+Layout.h"

@implementation UINavigationBar (Layout)

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    BOOL IS_IPHONE_X = NO; // 默认不是X系列
//    // 适配iPhoneXs
//    if (@available(iOS 11, *)) {
//        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
//        if (insets.bottom > 0) {
//            IS_IPHONE_X = YES;
//        }
//    }
//
//    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
//    for (UIView *view in self.subviews) {
//        if (systemVersion >= 11.0) {
//            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
//                CGRect frame = view.frame;
//                frame.size.height = 64;
//                if (IS_IPHONE_X) {
//                    frame.size.height = 88;
//                }
//                view.frame = frame;
//            }
//            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
//                CGRect frame = view.frame;
//                frame.origin.y = 20;
//                if (IS_IPHONE_X) {
//                    frame.origin.y = 44;
//                }
//                view.frame = frame;
//            }
//        }
//    }
//}

@end
