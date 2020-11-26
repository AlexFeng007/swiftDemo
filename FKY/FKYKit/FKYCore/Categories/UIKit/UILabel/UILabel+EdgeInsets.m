//
//  UILabel+EdgeInsets.m
//  FKY
//
//  Created by 夏志勇 on 2018/9/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "UILabel+EdgeInsets.h"

@implementation UILabel (EdgeInsets)

static char kContentInsetsKey;
static char kshowContentInsetsKey;


#pragma mark - load

+ (void)load
{
    [super load];
    
    // class_getInstanceMethod()
    Method fromMethod = class_getInstanceMethod([self class], @selector(drawTextInRect:));
    Method toMethod = class_getInstanceMethod([self class], @selector(tt_drawTextInRect:));
    
    // class_addMethod()
    if (!class_addMethod([self class], @selector(drawTextInRect:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}


#pragma mark -

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    objc_setAssociatedObject(self, &kContentInsetsKey, NSStringFromUIEdgeInsets(contentInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &kshowContentInsetsKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIEdgeInsets)contentInsets
{
    return UIEdgeInsetsFromString(objc_getAssociatedObject(self, &kContentInsetsKey));
}


#pragma mark -

- (void)tt_drawTextInRect:(CGRect)rect
{
    BOOL show = objc_getAssociatedObject(self, &kshowContentInsetsKey);
    if (show) {
        rect = UIEdgeInsetsInsetRect(rect, self.contentInsets);
    }
    [self tt_drawTextInRect:rect];
}


@end
