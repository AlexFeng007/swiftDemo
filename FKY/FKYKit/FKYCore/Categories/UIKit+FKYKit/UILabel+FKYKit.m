//
//  UILabel+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/10/17.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "UILabel+FKYKit.h"
#import <objc/runtime.h>
#import "NSString+Contains.h"

@implementation UILabel (FKYKit)

+ (void)load {
    SEL originalSelector = @selector(setText:);
    SEL swizzledSelector = @selector(FKY_setText:);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)FKY_setText:(NSString *)text {
    if ([text containsaString:@"(null)"] || [text containsaString:@"null"]) {
        text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"null" withString:@""];
    }
    else if (!text) {
        text = @"";
    }
    return [self FKY_setText:text];
}

- (CGFloat)singleLineStringLength {
    return [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.font.lineHeight)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName :self.font}
                                   context:nil].size.width;
}

- (void)setFontTuble:(NSDictionary *)fontTuble {
    if (fontTuble) {
        self.textColor = fontTuble[@"color"];
        self.font = fontTuble[@"font"];
    }
}

@end
