//
//  UIButton+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "UIButton+FKYKit.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@implementation UIButton (FKYKit)

@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (void)setTitleLeftAndImageRightWithSpace:(CGFloat)space {
    CGSize imageSize = self.imageView.image.size;
    CGFloat textLength = ((CGRect)[self.titleLabel.text boundingRectWithSize:CGSizeZero
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName:self.titleLabel.font}
                                                                     context:nil]).size.width;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, (textLength + space/2.0), 0, -(textLength + space/2.0))];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width + space/2.0), 0, (imageSize.width + space/2.0))];
}

- (void)setBtnStyle:(NSDictionary *)btnStyle {
    NSNumber *width = btnStyle[@"width"];
    NSNumber *height = btnStyle[@"height"];
    UIColor *borderColor = btnStyle[@"borderColor"];
    UIColor *textColor = btnStyle[@"textColor"];
    UIFont *textFont = btnStyle[@"textFont"];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = true;
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = textFont;
}

@end
